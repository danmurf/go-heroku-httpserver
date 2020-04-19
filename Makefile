APP_NAME = # Set to something bespoke if needed
GO_BUILD_ENV := CGO_ENABLED=0 GOOS=linux GOARCH=amd64
DOCKER_BUILD=$(shell pwd)/.docker_build
DOCKER_CMD=$(DOCKER_BUILD)/server

$(DOCKER_CMD): clean
	mkdir -p $(DOCKER_BUILD)
	$(GO_BUILD_ENV) go build -v -o $(DOCKER_CMD) cmd/server/server.go

clean:
	rm -rf $(DOCKER_BUILD)

# ================ HEROKU ================

heroku-create:
	heroku create $(APP_NAME) --region eu --no-remote

heroku-push: $(DOCKER_CMD)
	heroku container:push web

heroku-destroy:
	heroku destroy

# ================ DOCKER COMPOSE ================
docker-build: clean $(DOCKER_CMD)
	docker-compose build --force-rm

docker-up: docker-build
	docker-compose up -d --force-recreate

docker-logs:
	docker-compose logs -f web

docker-down:
	docker-compose down --volumes
