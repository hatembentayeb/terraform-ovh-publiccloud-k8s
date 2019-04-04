#!/bin/bash
function pubipaddr(){
    if ip route get 1.1.1.1 > /dev/null 2>&1; then
        ip -o route get 1.1.1.1 | sed 's/.*src \([0-9\.]*\) .*/\1/g'
    else
        return 1
    fi
}

if [ -z "$API_ENDPOINT" ]; then
    pubip="$(pubipaddr)"
    if [ -z "$pubip" ]; then
        echo "ERROR: cannot get pubip and no API_ENDPOINT defined" >&2
        exit 1
    fi
    CONTROL_PLANE_ENDPOINT="${pubip}:6443"
else
    CONTROL_PLANE_ENDPOINT="$API_ENDPOINT"
fi

cat <<EOF
apiVersion: kubeadm.k8s.io/v1alpha3
kind: ClusterConfiguration
kubernetesVersion: ${KUBERNETES_VERSION:-stable}
certificatesDir: "/etc/kubernetes/pki"
apiServerCertSANs:
$(echo "${API_SERVER_CERT_SANS:-127.0.0.1}" | cut -d, -f1- --output-delimiter=$'\n' | sed 's/\(.*\)/- \1/g')
controlPlaneEndpoint: "$CONTROL_PLANE_ENDPOINT"
etcd:
  external:
    endpoints:
$(echo "${ETCD_ENDPOINTS:-https://127.0.0.1:2379}" | cut -d, -f1- --output-delimiter=$'\n' | sed 's/\(.*\)/    - \1/g')
    caFile: ${ETCD_CA_FILE}
    certFile: ${ETCD_CERT_FILE}
    keyFile: ${ETCD_KEY_FILE}
kubeProxy:
  config:
    mode: ${KUBEPROXY_CONFIG_MODE:-iptables}
networking:
  dnsDomain: ${CLUSTER_DOMAIN:-cluster.local}
  serviceSubnet: ${NETWORKING_SERVICE_SUBNET:-10.96.0.0/12}
  podSubnet: ${NETWORKING_POD_SUBNET:-192.168.0.0/16}
nodeName: $(hostname)
authorizationModes:
$(echo "${AUTHORIZATION_MODES:-Node,RBAC}" | cut -d, -f1- --output-delimiter=$'\n' | sed 's/\(.*\)/- \1/g')
selfHosted: false
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: coredns
  namespace: kube-system
  resourceVersion: "214"
  selfLink: /api/v1/namespaces/kube-system/configmaps/coredns
data:
  Corefile: |
    .:53 {
        errors
        health
        kubernetes ${CLUSTER_DOMAIN} in-addr.arpa ip6.arpa {
           pods insecure
           upstream
           fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        proxy . ${UPSTREAM_RESOLVER}
        cache 30
        loop
        reload
        loadbalance
    }
EOF
