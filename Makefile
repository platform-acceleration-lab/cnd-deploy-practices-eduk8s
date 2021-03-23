NAME                  = cnd-deploy-practices
CONTAINER_REGISTRY    = my.registry.to.push.to.com
CONTAINER_REPOSITORY  = ${NAME}
version               = latest

# Put it first so that "make" without argument is like "make help".
run: build kind-start educates-deploy

reload: build educates-deploy educates-refresh

refresh: build educates-refresh

.PHONY: build kind-start kind-stop

kind-start:
	deploy/environment/kind/start.sh ${NAME}

kind-stop:
	deploy/environment/kind/stop.sh ${NAME}

educates-deploy:
	deploy/platform/educates/deploy.sh installEducates ${NAME}
	deploy/platform/educates/deploy.sh loadWorkshop ${NAME}
	deploy/platform/educates/deploy.sh loadContent ${NAME}

educates-refresh:
	deploy/platform/educates/deploy.sh loadContent ${NAME}

build:
	rm -rf build
	mkdir -p build/workshop
	cp -r workshop-files/* build
	cp -r workshop-instructions/* build/workshop
	tar -czf build/workshop.tar.gz -C build .

get-reporeg:
	@echo "${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}"

get-name:
	@echo "${NAME}"