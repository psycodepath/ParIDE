# ParIDE - Collaborative Programming server & protocol

## About 
Remote working is a blessing in the modern software development world. But it comes with pitfalls. 
For example it is not that easy to pair program by just sitting next to your coworker (physically). 

There are decent solutions on the commercial market but they assume, that you have a rather uniform 
dev environment setup (same editor / ide) or wont let you have a good experience. 

This project aims to solve this by providing an open source solution for an pair programming 
protocol that can be utilized by Plugin / IDE developers. 

There are two main goals here:

1. Create the protocol specification
2. Create a server implementation that can be used as default 

## Features

- Real-time collaborative editing
- Pair and mob programming support
- Language/editor agnostic protocol
- Secure by design
- Easy deployment
- Built-in chat functionality

## How to Build

### Prerequisites

- Go 1.21 or later
- Protocol Buffers compiler (`protoc`)
- Make

### Building the Project

1. **Install dependencies and generate protobuf code:**
   ```bash
   make install-deps
   make proto
   ```

2. **Build the server:**
   ```bash
   make build
   ```

3. **Run all steps (recommended for first build):**
   ```bash
   make all
   ```

### Available Make Targets

- `make all` - Generate protobuf code and build the server
- `make install-deps` - Install required protobuf dependencies
- `make proto` - Generate Go code from protobuf files
- `make build` - Build the server binary
- `make test` - Run tests
- `make fmt` - Format code
- `make vet` - Run go vet
- `make clean` - Clean generated files and binaries
- `make run` - Build and run the server
- `make dev` - Development workflow (format, vet, test, build)

### Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd ParIDE

# Build everything
make all

# Run the server
make run
```

## Project Structure

```
ParIDE/
├── cmd/server/          # Server application entry point
├── pkg/proto/v1/        # Generated protobuf Go code (auto-generated)
├── proto/v1/            # Protocol buffer definitions
├── docs/                # Documentation
└── Makefile             # Build automation
```

## Development

For development, use the `make dev` target which runs formatting, vetting, testing, and building in sequence.

Generated protobuf files are automatically excluded from version control via `.gitignore`.

### Disclaimer:
This project is currently in the bootstraping phase so everything is in constant flow. Don't 
rely on anything inside this repo.

## License

This project is licensed under the [MIT License](LICENSE).