GO_BUILD_ENV := CGO_ENABLED=0 GOOS=linux GOARCH=amd64
DOCKER_BUILD=$(shell pwd)/.docker_build
DOCKER_CMD=$(DOCKER_BUILD)/server

$(DOCKER_CMD): clean
	mkdir -p $(DOCKER_BUILD)
	$(GO_BUILD_ENV) go build -v -o $(DOCKER_CMD) cmd/server/server.go

clean:
	rm -rf $(DOCKER_BUILD)

# ================ HEROKU ================

heroku-create: # Creates a new app with a random name on Heroku
	heroku create --region eu --no-remote

heroku-login:
	heroku container:login

heroku-push: heroku-login $(DOCKER_CMD) # Pushes the current local image to heroku for deployment
	heroku container:push web

heroku-release: # Releases the current image on heroku to production
	heroku container:release web

heroku-deploy: $(DOCKER_CMD) heroku-login heroku-push heroku-release # Builds, pushes and releases to production

heroku-destroy: # Deletes the current app from Heroku. Requires confirmation.
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
