# Put it first so that "make" without argument is like "make help".
run: build educates-start

.PHONY: build educates-start educates-stop

educates-start:
	deploy/kind.sh
	deploy/educates/deploy.sh

educates-stop:
	deploy/kind.sh stop

educates-reload:
	deploy/educates/deploy.sh

build:
	docker build -t cnd-deploy-practices:latest .