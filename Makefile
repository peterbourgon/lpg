PROMETHEUS_VERSION ?= 2.49.1
GRAFANA_VERSION    ?= 10.3.3
OS                 ?= $(shell go env GOOS)
ARCH               ?= $(shell go env GOARCH)
ROOT_DIR           ?= /tmp/lpg

PROMETHEUS_ID            = prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}
PROMETHEUS_ARTIFACT      = prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}.tar.gz
PROMETHEUS_URL           = https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_ARTIFACT}
PROMETHEUS_DST           = ${ROOT_DIR}/prometheus

GRAFANA_ID               = grafana-v${GRAFANA_VERSION}
GRAFANA_ARTIFACT         = grafana-${GRAFANA_VERSION}.${OS}-${ARCH}.tar.gz
GRAFANA_URL              = https://dl.grafana.com/oss/release/${GRAFANA_ARTIFACT}
GRAFANA_DST              = ${ROOT_DIR}/grafana

.PHONY: all
all: install run

.PHONY: install
install: install-prometheus install-grafana

.PHONY: install-prometheus
install-prometheus: ${PROMETHEUS_DST}/prometheus ${PROMETHEUS_DST}/prometheus.yml
	@${PROMETHEUS_DST}/prometheus --version
	@echo

${PROMETHEUS_DST}/prometheus: ${PROMETHEUS_DST}

${PROMETHEUS_DST}/prometheus.yml: ${PROMETHEUS_DST} prometheus.yml
	cp prometheus.yml ${PROMETHEUS_DST}/prometheus.yml

${PROMETHEUS_DST}: ${PROMETHEUS_ARTIFACT}
	mkdir -p ${PROMETHEUS_DST}
	tar zxvf ${PROMETHEUS_ARTIFACT} --strip-components=1 --directory=${PROMETHEUS_DST}

${PROMETHEUS_ARTIFACT}:
	wget -O ${PROMETHEUS_ARTIFACT} ${PROMETHEUS_URL}

.PHONY: install-grafana
install-grafana: ${GRAFANA_DST}/bin/grafana ${GRAFANA_DST}/grafana.ini
	@${GRAFANA_DST}/bin/grafana --version
	@echo

${GRAFANA_DST}/bin/grafana: ${GRAFANA_DST}

${GRAFANA_DST}/grafana.ini: ${GRAFANA_DST} grafana.ini
	cat grafana.ini | env GRAFANA_DST=${GRAFANA_DST} envsubst > ${GRAFANA_DST}/grafana.ini

${GRAFANA_DST}: ${GRAFANA_ARTIFACT}
	mkdir -p ${GRAFANA_DST}
	tar zxvf ${GRAFANA_ARTIFACT} --strip-components=1 --directory=${GRAFANA_DST}

${GRAFANA_ARTIFACT}:
	wget -O ${GRAFANA_ARTIFACT} ${GRAFANA_URL}

.PHONY: run
run: install-prometheus install-grafana
	@./run.bash ${ROOT_DIR}

.PHONY: clean-prometheus-data
clean-prometheus-data:
	rm -rf ${PROMETHEUS_DST}/data

.PHONY: clean-grafana-data
clean-grafana-data:
	rm -rf ${GRAFANA_DST}/data

.PHONY: clean-all
clean-all:
	rm -rf ${PROMETHEUS_DST} ${GRAFANA_DST} *.tar.gz
