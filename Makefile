# Put it first so that "make" without argument is like "make help".
run: build educates-start educates-deploy

reload: build educates-deploy

.PHONY: build educates-start educates-stop

educates-start:
	deploy/kind.sh

educates-stop:
	deploy/kind.sh stop

educates-deploy:
	deploy/educates/deploy.sh

build:
	docker build -t cnd-deploy-practices:latest .