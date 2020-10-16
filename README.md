# nebula-deployer

An ansible playbook that allows deploying and managing [nebula](https://github.com/slackhq/nebula/) infrastructure. The install script is limited to support of armv6, armv7, arm64, and linux amd64 OS, however it can be adapted to support other distributions. You will want to adjust the actual configuration of nebula to your liking, what is included can be used as sensible defaults.

# usage

Provision your nebula certificate infrastructure and place the contents inside the `certs` folder. The `certs` folder contains example certs and was generated as follows:

```shell
$> nebula-cert ca -name "example ca"
$> nebula-cert sign -name "lighthouse-1" -ip "172.16.0.1/24"
$> nebula-cert sign -name "node-1" -ip "172.16.0.2/24"
$> nebula-cert sign -name "node-2" -ip "172.16.0.3/24"
```

Update `inventory/hosts.yml` with your lighthouse, and regular nebula nodes. Make sure to use the names you gave the certificates otherwise there will be deployment errors.

Run the playbook as follows, which will download and install nebula on supported linux distributions:

```shell
$> ansible-playbook playbook.yml --ask-become-pass -f 10
```
