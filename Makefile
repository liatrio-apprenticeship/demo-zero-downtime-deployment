VERSION?=0.0.1

.PHONY: setup destroy build publish deploy port-forward watch-deploy clean

setup:
	kind create cluster --config=kind.yaml

destroy:
	kind delete cluster

build:
	docker build -t zero-downtime-deploy-demo:${VERSION} .

publish: build
	kind load docker-image zero-downtime-deploy-demo:${VERSION}

deploy: publish
	helm upgrade --namespace demo zero-downtime-deploy-demo chart --install --create-namespace --set image.tag=${VERSION}

port-forward:
	kubectl -n demo port-forward deployment.apps/zero-downtime-deploy-demo 8080:8080 > /dev/null &

watch-deploy:
	watch -n1 kubectl -n demo get all

watch-app:
	watch -n1 curl -vs http://127.0.0.1:30000

clean:
	helm uninstall --namespace demo zero-downtime-deploy-demo
