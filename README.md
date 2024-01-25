# UERANSIM Docker Images
WARNING: **The following images are NOT official builds of UERANSIM**, in the future they may include beta-functionalities.

By default, configuration file from templating is used if no `--config` or `-c` is passed as argument. To start without argument, use:

```yaml
command: [" "]
```

## TUN interface
To be able to use both images, you have to give it some capabilities and define some devices to the containers you create or you won't be able to use them: this is totally normal and expected.
If you use Docker Compose for example, you have to add:
```yaml
cap_add:
  - NET_ADMIN
devices:
  - "/dev/net/tun"
```
This is the equivalent of `--cap-add=NET_ADMIN --device /dev/net/tun` option of Docker.

## UE image
- On DockerHub: [`louisroyer/ueransim-ue`](https://hub.docker.com/r/louisroyer/ueransim-ue)

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/ueransim/ue.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/ueransim/template-ue.yaml"
  ONESHOT: "true"
  PRE_INIT_HOOK: "daemonize.sh"
  PRE_INIT_HOOK_0: "routing.sh"
```

If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup).
The environment variable `ONESHOT` is set to `"true"`.

Environment variables for templating:
```yaml
environment:
  MCC: "001"
  MNC: "01"
  MSISDN: "0000000000"
  KEY: "8baf473f2f8fd09487cccbd7097c6862"
  OP: "8e27b6af0e692e750f32667a3b14605d"
  AMF: "8000"
  # The following variable have no default values
  # Replace the following example addresses with your gNB's ones
  GNBS: |-
    - 192.0.2.2
    - 2001:db8::2
  SESSIONS: |-
    - type: "IPv4"
      apn: "sliceA"
      slice:
        sst: 1
        sd: 0x010203
  CONFIGURED_NSSAI: |-
    - sst: 1
      sd: 0x010203
  DEFAULT_NSSAI: |-
    - sst: 1
      sd: 0x010203
```

## gNB image
- On DockerHub: [`louisroyer/ueransim-gnb`](https://hub.docker.com/r/louisroyer/ueransim-gnb)

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/ueransim/gnb.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/ueransim/template-gnb.yaml"
  ONESHOT: "true"
```

If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup).
The environment variable `ONESHOT` is set to `"true"`.

Environment variables for templating:
```yaml
environment:
  MCC: "001"
  MNC: "01"
  NCI: "0x000000010"
  ID_LEN: 32
  TAC: 1
  # The following variable have no default values
  RLS_IP: "10.0.0.2"
  N2_IP: "10.0.1.2"
  N3_IP: "10.0.2.2"
  AMF_CONFIGS: |-
    - address: 10.0.2.3
      port: 38412
  SUPPORTED_NSSAIS: |-
    - sst: 1
      sd: 0x010203
```
