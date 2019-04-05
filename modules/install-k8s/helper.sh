#!/bin/bash
export ETCDCTL_API=3
ETCD_ENDPOINTS=$(grep ETCD_ENDPOINTS /etc/sysconfig/kubernetes.conf | cut -d= -f2)
ETCD_CA_FILE=/etc/kubernetes/etcd/ca.crt
ETCD_CERT_FILE=/etc/kubernetes/etcd/client.crt
ETCD_KEY_FILE=/etc/kubernetes/etcd/client.key
ETCDCTL_COMMAND="/opt/k8s/bin/etcdctl --cacert $ETCD_CA_FILE --cert $ETCD_CERT_FILE --key $ETCD_KEY_FILE --endpoints $ETCD_ENDPOINTS"
CACRT_ETCD_KEY=k8s/cacrt CACRT_SHA256SUM_ETCD_KEY=k8s/cacrt-sha256 BOOTSTRAP_TOKEN_ETCD_KEY=k8s/bootstrap-token CERTIFICATE_KEY_ETCD_KEY=k8s/certificate-key
TOKEN=$($ETCDCTL_COMMAND get --print-value-only $BOOTSTRAP_TOKEN_ETCD_KEY)
CERTIFICATE_KEY=$($ETCDCTL_COMMAND get --print-value-only $CERTIFICATE_KEY_ETCD_KEY)
CACRT_SHA256SUM=$($ETCDCTL_COMMAND get --print-value-only $CACRT_SHA256SUM_ETCD_KEY)
MASTERS_ETCD_KEYPREFIX=k8s/masters
masterip=$($ETCDCTL_COMMAND get --prefix "$MASTERS_ETCD_KEYPREFIX" --print-value-only --limit 1)
