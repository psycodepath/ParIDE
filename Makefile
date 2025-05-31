# Variables
PROTOC = protoc
PROTO_INCLUDE_DIR = proto
PROTO_SRC_DIR = proto/paride_api_v1
# Base output directory for generated Go files.
# With paths=source_relative, protoc will create a subdirectory matching the proto package.
# e.g., for protos in proto/paride_api_v1, output will be in pkg/proto/paride_api_v1/
GO_OUT_DIR = pkg/proto
GRPC_GO_OUT_DIR = pkg/proto

# Calculated directory where generated package files will reside
GENERATED_PROTO_PKG_DIR = $(GO_OUT_DIR)/$(notdir $(PROTO_SRC_DIR))

# Go build variables
CMD_DIR = cmd
SERVER_MAIN = $(CMD_DIR)/paride-server/main.go
OUTPUT_BIN_DIR = bin
SERVER_BINARY = $(OUTPUT_BIN_DIR)/paride-server

# Find all .proto files in the source directory
PROTO_FILES = $(wildcard $(PROTO_SRC_DIR)/*.proto)

.PHONY: proto clean-proto all build-server clean-server

all: proto build-server

# Target to generate Go code from .proto files
proto:
	@echo "Generating Go code from .proto files..."
	@mkdir -p $(GENERATED_PROTO_PKG_DIR) # Ensure the target package directory exists
	$(PROTOC) -I=$(PROTO_INCLUDE_DIR) \
		--go_out=paths=source_relative:$(GO_OUT_DIR) \
		--go-grpc_out=paths=source_relative:$(GRPC_GO_OUT_DIR) \
		$(PROTO_FILES)
	@echo "Proto generation complete. Files in $(GENERATED_PROTO_PKG_DIR)"

# Target to clean generated Go files
clean-proto:
	@echo "Cleaning generated proto Go files..."
	# Remove .pb.go, _grpc.pb.go, and potentially .pb.gw.go files from the generated package directory
	rm -f $(GENERATED_PROTO_PKG_DIR)/*.pb.go
	rm -f $(GENERATED_PROTO_PKG_DIR)/*_grpc.pb.go
	rm -f $(GENERATED_PROTO_PKG_DIR)/*.pb.gw.go # If you generate gateway files
	@echo "Clean-up complete."

# Target to build the paride-server binary
build-server:
	@echo "Building paride-server binary..."
	@mkdir -p $(OUTPUT_BIN_DIR)
	go build -o $(SERVER_BINARY) $(SERVER_MAIN)
	@echo "Build complete: $(SERVER_BINARY)"

# Target to clean the built server binary
clean-server:
	@echo "Cleaning paride-server binary..."
	rm -f $(SERVER_BINARY)
	@echo "Clean-up complete."

# Example:
# To generate code: make proto
# To clean generated code: make clean-proto
# To build server: make build-server
# To clean server binary: make clean-server
