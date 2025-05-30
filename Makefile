.PHONY: all build clean proto install-deps test fmt vet

# Variables
PROTO_DIR := proto/v1
PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)
GO_OUT_DIR := pkg/proto/paride_api_v1/
BINARY_NAME := paride-server

# Default target
all: proto build

# Install required dependencies
install-deps:
	@echo "Installing protobuf dependencies..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Generate Go code from protobuf files
proto: install-deps
	@echo "Generating protobuf code..."
	@mkdir -p $(GO_OUT_DIR)
	protoc --proto_path=$(PROTO_DIR) \
		--go_out=$(GO_OUT_DIR) \
		--go_opt=paths=source_relative \
		--go-grpc_out=$(GO_OUT_DIR) \
		--go-grpc_opt=paths=source_relative \
		$(PROTO_FILES)
	@echo "Formatting generated protobuf code..."
	go fmt $(GO_OUT_DIR)/...

# Build the server binary
build: proto
	@echo "Building server..."
	go build -o bin/$(BINARY_NAME) ./cmd/server

# Run tests
test:
	go test -v ./...

# Format code
fmt:
	go fmt ./...

# Vet code
vet:
	go vet ./...

# Clean generated files and binaries
clean:
	@echo "Cleaning up..."
	rm -rf $(GO_OUT_DIR)
	rm -rf bin/

# Run the server (for development)
run: build
	./bin/$(BINARY_NAME)

# Generate and build everything
generate: clean proto build

# Development workflow
dev: fmt vet test build
