apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${cad}
    server: ${endpoint}
  name: ${name}
contexts:
- context:
    cluster: ${name}
    user: kubernetes-admin
  name: kubernetes-admin@${name}
current-context: kubernetes-admin@${name}
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    token: ${token}
