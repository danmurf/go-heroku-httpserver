.DEFAULT_GOAL := build
COMMAND_BUILD_FILE := server/server.go
COMMAND_NAME := server

build: lint test
	go build -o bin/${COMMAND_NAME} cmd/${COMMAND_BUILD_FILE}

lint:
	go fmt github.com/danmurf...

test:
	go test ./...

run: build
	bin/${COMMAND_NAME}
