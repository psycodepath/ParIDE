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

- Real-time collaborative editing (not implemented yet)
- Language/editor agnostic protocol (not implemented yet)
- Built-in chat functionality (not implemented yet)



### Prerequisites

- Go 1.21 or later
- Protocol Buffers compiler (`protoc`)
- Make


### Disclaimer:
This project is currently in the bootstraping phase so everything is in constant flow. Don't 
rely on anything inside this repo.

## License

This project is licensed under the [MIT License](LICENSE).