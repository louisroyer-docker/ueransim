# UERANSIM Docker Images
WARNING: **The following images are NOT official builds of UERANSIM**, in the future they may include beta-functionalities.

By default, configuration file from templating is used if no `--config` or `-c` is passed as argument. To start without argument, use:

```yaml
command: [" "]
```

## UE image
- On DockerHub: [`louisroyer/ueransim-ue`](https://hub.docker.com/repository/docker/louisroyer/ueransim-ue)

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "routing.sh"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/ueransim/ue.yaml"
  CONFIG_TEMPLATE: "/etc/ueransim/template-ue.yaml"
```

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
  GNBS: |-
    - 127.0.0.1
    - ::1
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
- On DockerHub: [`louisroyer/ueransim-gnb`](https://hub.docker.com/repository/docker/louisroyer/ueransim-gnb)

Environment variable used to select templating system:
```yaml
environment:
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/ueransim/gnb.yaml"
  CONFIG_TEMPLATE: "/etc/ueransim/template-gnb.yaml"
```

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
