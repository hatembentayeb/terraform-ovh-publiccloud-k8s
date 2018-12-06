### add remote state backend in case tests is partially applied & breaks.
### allows further manual destroy or investigation
terraform {
  backend "swift" {
    container = "%%TESTNAME%%"
  }
}

data "template_file" "test_script" {
  template = <<TPL
#!/bin/bash
export ETCDCTL_API=3
ETCD_CMD="/opt/k8s/bin/etcdctl --cacert /opt/etcd/certs/ca.pem --cert /opt/etcd/certs/peer.pem --key /opt/etcd/certs/peer-key.pem --endpoints https://localhost:2379"
K8S_CMD="sudo /opt/k8s/bin/kubectl --kubeconfig /etc/kubernetes/admin.conf"

# test etcd
if [ $($ETCD_CMD member list | grep started | wc -l) == "${local.test_master_count}" ]; then
   echo "etcd is up" >&2
else
   echo "etcd is not ready. retry later" >&2
   exit 1
fi

# test k8s cluster
if [ $($K8S_CMD get nodes | grep master | grep -iw ready | wc -l) == "${local.test_master_count}" ]; then
   echo "k8s is up" >&2
else
   echo "k8s is not ready. retry later" >&2
   exit 1
fi

# create test daemonset
if ($K8S_CMD get daemonsets test >/dev/null); then
   echo test daemonset already exists >&2
else
   echo creating test daemonset >&2
   cat <<EOF | $K8S_CMD create -f -
apiVersion: apps/v1beta2
kind: DaemonSet
metadata:
  name: test
spec:
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
        - name: busybox
          image: busybox:1.28
          args:
             - sleep
             - "1000000"
EOF
fi

PODS=$($K8S_CMD get pods --field-selector=status.phase=Running -o json | jq -r '.items[].metadata.name')
# test running pods
if [ "$(echo $PODS | wc -w)" == "${local.test_worker_count}" ]; then
   echo "test daemonset pods are up" >&2
else
   echo "test daemonset pods arent ready. retry later" >&2
   exit 1
fi

IPS=$($K8S_CMD get pods -o json | jq -r '.items[].status.podIP')
echo ping all containers from first one >&2
for i in $IPS; do
   if ! ($K8S_CMD exec $(echo $PODS | awk '{print $1}') -- ping -c 1 $i >/dev/null); then
     echo pods cannot ping one another. networking maybe down. >&2
   fi
done

echo ping all containers from first one based on dns names >&2
for i in $IPS; do
   if ! ($K8S_CMD exec $(echo $PODS | awk '{print $1}') -- ping -c 1 $${iexpr}.default.pod.cluster.local >/dev/null); then
     echo pods cannot ping one another based on dns resolution. problem with coredns setup. >&2
   fi
done

echo ping ovh.com to test dns upstream resolution >&2
if ! ($K8S_CMD exec $(echo $PODS | awk '{print $1}') -- ping -c 1 ovh.com >/dev/null); then
  echo pods cannot ping ovh.com. networking maybe down. problem with coredns setup >&2
fi
TPL

  vars {
    # hack to double escape the bash interpolation string
    iexpr = "$${i//./-}"
  }
}

### this is the tests run by the CI
output "tf_test" {
  description = "This output is used by module tests to check if cluster is up & running"
  value       = "${local.test_ssh_prefix} bash /tmp/test.sh"
}
