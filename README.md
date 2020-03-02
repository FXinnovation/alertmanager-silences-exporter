# alertmanager-silences-exporter
Prometheus exporter exposing [AlertManager Silences](https://prometheus.io/docs/alerting/alertmanager/#silences) as metrics.

## Getting Started

### Prerequisites

To run this project, you will need a [working Go environment](https://golang.org/doc/install).

### Installing

```bash
go get -u github.com/FXinnovation/alertmanager-silences-exporter
```

## Building

Build the sources with

```bash
make build
```

## Run the binary

The exporter expects a config file as one of its arguments:

```bash
./alertmanager-silences-exporter --config.file=sample-config.yml
```

The exporter's Alertmanager API connection can also be configured by defining the following environment variable(s). If they are present, they will take precedence over the corresponding variables in the config file.

Environment Variable | Description
---------------------| -----------
ALERTMANAGER_URL | URL of the exported alertmanager api (eg: "http://localhost:9093/")


Use -h flag to list available options.

## Testing

### Running unit tests

```bash
make test
```

## Configuration

An example can be found in
[sample-config.yml](https://github.com/FXinnovation/alertmanager-silences-exporter/blob/master/sample-config.yml).

Configuration element | Description
--------------------- | -----------
alertmanager_url | (Mandatory) URL of the exported alertmanager api (eg: "http://localhost:9093/")

## Docker image

You can run images published in [dockerhub](https://hub.docker.com/r/fxinnovation/alertmanager-silences-exporter).

You can also build a docker image using:

```bash
make docker
```

The resulting image is named `fxinnovation/alertmanager-silences-exporter:<git-branch>`.

The image exposes port 9666 and expects a config in `/opt/alertmanager-silences-exporter/config.yml`.
To configure it, you can pass the environment variables, and bind-mount a config from your host:

```bash
docker run -p 9666:9666 -v /path/on/host/config/config.yml:/opt/alertmanager-silences-exporter/config/config.yml -e ALERTMANAGER_URL="http://localhost:9093/" fxinnovation/alertmanager-silences-exporter:<git-branch>
```

## Exposed metrics

Metric | Description
------ | -----------
alertmanager_silence_info | [AlertManager Silences](https://prometheus.io/docs/alerting/alertmanager/#silences) exposed as gauge values, to confirm if a silence is currently active for the labels associated to it.
alertmanager_silence_start_seconds | The start time of an Alertmanager Silence, exposed in unix/epoch time.
alertmanager_silence_end_seconds | The end time of an Alertmanager Silence, exposed in unix/epoch time.

Example:

```
# HELP alertmanager_silence_info Alertmanager silence info metric
# TYPE alertmanager_silence_info gauge
alertmanager_silence_info{comment="me",createdBy="me",id="7aa4fb96-9aac-4a3a-899c-ee5f20afd730",matcher_customer="foo",status="active"} 1
# HELP alertmanager_silence_end_seconds Alertmanager silence end time, elapsed seconds since epoch.
# TYPE alertmanager_silence_end_seconds gauge
alertmanager_silence_end_seconds{id="7aa4fb96-9aac-4a3a-899c-ee5f20afd730"} 1 1582909200000
# HELP alertmanager_silence_start_seconds Alertmanager silence start time, elapsed seconds since epoch.
# TYPE alertmanager_silence_start_seconds gauge
alertmanager_silence_start_seconds{id="7aa4fb96-9aac-4a3a-899c-ee5f20afd730"} 1 1582571132089
```

## Contributing

Refer to [CONTRIBUTING.md](https://github.com/FXinnovation/alertmanager-silences-exporter/blob/master/CONTRIBUTING.md).

## License

Apache License 2.0, see [LICENSE](https://github.com/FXinnovation/alertmanager-silences-exporter/blob/master/LICENSE).
