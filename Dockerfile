FROM golang:1.12 as builder
WORKDIR /alertmanager-silences-exporter/
COPY . .
RUN make getpromu test build

FROM ubuntu:18.04
COPY --from=builder /alertmanager-silences-exporter/alertmanager-silences-exporter /alertmanager-silences-exporter
ADD ./resources /resources
RUN /resources/build && rm -rf /resources
USER ase
EXPOSE 9666
WORKDIR /opt/alertmanager-silences-exporter
ENTRYPOINT  [ "/opt/alertmanager-silences-exporter/alertmanager-silences-exporter" ]

LABEL maintainer="FXinnovation CloudToolDevelopment <CloudToolDevelopment@fxinnovation.com>" \
      "org.label-schema.name"="alertmanager-silences-exporter" \
      "org.label-schema.base-image.name"="docker.io/library/ubuntu" \
      "org.label-schema.base-image.version"="18.04" \
      "org.label-schema.description"="alertmanager-silences-exporter in a container" \
      "org.label-schema.url"="https://github.com/FXinnovation/alertmanager-silences-exporter" \
      "org.label-schema.vcs-url"="https://github.com/FXinnovation/alertmanager-silences-exporter" \
      "org.label-schema.vendor"="FXinnovation" \
      "org.label-schema.schema-version"="1.0.0-rc.1" \
      "org.label-schema.usage"="Please see README.md"