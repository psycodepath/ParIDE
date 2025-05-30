# initial thoughts

The first list of requirements that comes to my mind is the following: 

1. It needs to be performant
    - as no one likes a laggy infrastructure
2. It needs to allow pair and / mob programming
    - often times there is more than one person doing simultainious 
3. Setting it up needs to be easy
   - to have any chance of adoption it needs to be easy to deploy the server
   - the protocol should not be overly complex
4. It needs to be secure
   - since it may come in touch with sensitive data it has to be secure from the ground up
5. It needs to be language / editor agnostic
    - to have any chance of adoption the language you program your client in should not matter 
6. It needs to be well documented 
   - no plugin developer will dare to touch it if the documentation sucks. 

### Where to go from here? 

You can write performant code in every language but as this is a greenfield
it would be wise to think how we could give us a slight benefit here. 

So when i think about languages, it should be a language that compiles down 
to a binary. Since i don't want to lock in on a specific OS and it should 
be easy to setup i think go would be a good fit / compromise. 

It can compile to multiple architectures on the same machine, concurrency 
is the strong suite of go and the std. lib has most of the things we
need. So installing external dependies / libs probably wont be necessary. 

We have sycnchronous encryption, asynchronous encryption to aid 
in the security side of things right in the std lib. 

Another advantage would be that there are no discussions about 
code style, as it is dictated by go anyways. 

But the tipping point that lets me choose go is that it has really 
good support for protobuf and GRPC. This would aid us in the language / editor
agnostic requirement as well. 

Protocol buffers have the additional benefit, that we could directly supply
a form of documention, from which you can autogenerate client code 
or even implement your own server for the protocol. 

So lets get to work on them first.

### Planned features: 

- **GRPC endpoint for creating a session**
    - Initiates a new collaborative session with a unique session ID
    - Returns session metadata including permissions, participant limits, and authentication tokens
    - Allows configuration of session settings like read-only participants, file access restrictions, and timeout policies
    - The session creator becomes the host with elevated privileges (ability to kick participants, modify session settings)

- **GRPC endpoint for joining a session** 
    - Allows participants to connect to an existing session using a session ID or invitation token
    - Handles authentication and authorization based on session policies
    - Returns current session state including active files, participant list, and initial cursor positions
    - Supports different join modes (observer, contributor, etc.)

- **GRPC endpoint for leaving a session** 
    - Gracefully removes a participant from the session
    - Cleans up participant-specific state (cursors, selections, locks)
    - Notifies other participants of the departure
    - Handles session cleanup if the host leaves (transfer ownership or terminate session)

- **GRPC streaming endpoint for edit events**
    - **move cursor for participant at file, line and char**
        - Broadcasts real-time cursor position updates to all session participants
        - Includes participant identification and cursor styling information
        - Handles multiple cursors per participant for advanced editing scenarios
    
    - **insert text at cursor**
        - Transmits text insertion operations with precise positioning
        - Includes conflict resolution for simultaneous edits at the same location
        - Maintains operation history for undo/redo functionality
    
    - **select range of text**
        - Communicates text selection boundaries (start/end positions) across participants
        - Supports multiple selections per participant
        - Provides visual highlighting coordination between different editors
    
    - **unselect range of text**
        - Clears specific text selections and removes associated highlighting
        - Handles partial deselection within larger selection ranges
    
    - **execute an editor command**
        - Allows participants to trigger custom editor actions that affect the shared workspace
        - Commands are extensible and editor-specific (VS Code commands, Vim motions, etc.)
        - Examples: git operations, test execution, formatting, refactoring tools
        - Includes command validation and permission checking
    
    - **create a file**
        - Handles new file creation with conflict detection (duplicate names)
        - Broadcasts file creation events to all participants
        - Manages file permissions and access controls
    
    - **remove a file**
        - Processes file deletion with safety confirmations
        - Handles cleanup of associated editor state (open tabs, cursors, etc.)
        - Provides rollback capabilities for accidental deletions

- **GRPC endpoint to list editor commands**
    - Returns available commands specific to the session host connected editor type
    - Each command includes:
        - Unique identifier for programmatic access
        - Human-readable description and usage instructions
        - Expected payload schema/structure for command parameters
        - Permission requirements and availability conditions

- **GRPC endpoint to list available files**
    - Provides a hierarchical view of the shared workspace file structure
    - Includes file metadata (size, last modified, permissions, lock status)
    - Supports filtering and search capabilities
    - Returns real-time updates as files are added, removed, or modified

- **GRPC endpoint to read a file**
    - Retrieves file contents with support for large files through streaming
    - Handles different file encodings and binary file detection
    - Includes file versioning information for conflict resolution
    - Supports partial file reading (specific line ranges) for performance optimization 

- **GRPC endpoints for chat messaging**
    - **Send chat messages** with support for different message types (text, code snippets, file references, announcements)
        - Real-time message delivery to all session participants
        - Message threading with reply-to functionality for organized conversations
        - Support for sharing code snippets with syntax highlighting context
        - File reference messages that link to specific files or line ranges in the workspace
        - System notifications for session events (participant joined/left, file changes)
    
    - **Chat history retrieval** with pagination support
        - Efficient loading of message history when joining sessions
        - Configurable message retention limits per session
        - Search and filtering capabilities for finding specific conversations
    
    - **Real-time chat events streaming**
        - Live message delivery and updates across all participants
        - Typing indicators to show when participants are actively writing
        - Message reactions with emoji support for quick feedback
        - Message editing and deletion with proper conflict resolution
        - Broadcast system for important announcements from session hosts
    
    - **Configurable chat settings**
        - Enable/disable chat functionality per session
        - Control message features (editing, deletion, reactions, code sharing)
        - Set message length limits and spam protection
        - Configure observer chat permissions and participation levels
        - Rate limiting to prevent abuse and maintain performance

Given these features i created the following [protobuf file](../../proto/v1/paride.proto) 