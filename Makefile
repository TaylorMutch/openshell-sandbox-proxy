CARGO ?= cargo
HELM ?= helm
IMAGE ?= openshell/sandbox-proxy:poc
PLATFORM ?= linux/amd64
CHART := deploy/helm/openshell-sandbox-proxy

.PHONY: check test build image helm-check
check:
	$(CARGO) fmt --all -- --check
	$(CARGO) clippy --locked --all-targets -- -D warnings
	$(CARGO) test --locked

test:
	$(CARGO) test --locked

build:
	$(CARGO) build --locked --release

image:
	docker build --platform $(PLATFORM) -t $(IMAGE) .

helm-check:
	$(HELM) lint $(CHART) --set gatewayEndpoint=https://gateway.example.com --set workspace=default
	$(HELM) unittest $(CHART)
