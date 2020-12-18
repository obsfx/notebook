# Summary of Socket Notes

`refereance page: https://www.cs.rpi.edu/~moorthy/Courses/os98/Pgms/socket.html`

*Client* needs to know of the existence of and the adress of the *server*, but the *server* does not need to know the address of (or even existence of) the *client* before to the connection being established.

Once a connection is established, *both sides* can send and receive information.

Server and Client each establish their own *socket*.

Steps of establishing a socket on *client side*:

1. Create a socket with the `socket()` system call.

2. Connect the socket to the address of the server using the `connect()` system call.

3. Send and receive data. Simplest way is using `read()` and `write()` system calls.

Steps of establishing a socket on the *server side*:

1. Create a socket with the `socket()` system call.

2. Bind the socket to an adress using `bind()` system call. For a server socket on the internet, an adress consist of a port number on the host machine.

3. Listen for connections with the `listen()` system call.

4. Accept a connection with the accept system all. This call typically blocks until a client connect with the server.

### Socket Types

When a socket is created the program has to specify the *address domain* and the *socket type*.

Two widely used address domains:

1. `unix domain`: two processes share a common file system communicate.

2. `internet domain`: two processes running on any two hosts on the internet communicate.

Each one has its own address format.

*The address of a socket in* `unix domain` *is a character string which is basically an entery in the file system.*

*The address of a socket in the* `internet domain` *consist of the internet address of the host machine* `(every computer on the internet has a unique 32-bit addressi often referred as its IP address)`.

Each socket needs a port number on that host. Port numbers are `16-bit unsigned integers`. The lower numbers reserved in *unix* for standart services.

*It is important that standart services be at same port on all computers so that clients will know their addresses.*

There are to widely used socket types and each one has their own communication protocol:

1. `stream sockets`: treat communications as a continuous stream of characters. Use `TCP(Transmission Control Protocol)` which is reliable and stream oriented protocol.

2. `datagram sockets`: have to read entire messages at once. Use `UDP(Unix Datagram Protocol)` which is unreliable and message oriented.

#### What is POSIX ?

`refereance page: https://en.wikipedia.org/wiki/POSIX`

The Portable Operating System Interface (POSIX) is a family of standards specified by the IEEE Computer Society for maintaining compatibility between operating systems. POSIX defines the application programming interface (API), along with command line shells and utility interfaces, for software compatibility with variants of Unix and other operating systems.


#### What are File Descriptors ?

`refereance video: https://youtu.be/Ftg8fjY_YWU?t=219`

In unix `everyting is a file` and every `file` needs to `file descriptors` to access `resources like sockets, devices, directories, I/O` to perform their task. For example: `stdin, stdout, stderr` are file descriptors. If you want to perform I/O thing, your file will use this `file descriptors`. File descriptors are represented by numbers but in programming environments there are constant variables which are stand for that file descriptor numbers to make things easier.

##### Every process has their own file descriptor and this refers to the their own `file descriptor table`. This a small table that just maps some of the numbers into the kernel.

##### `strace` command to see system calls of an app. strace ./read.py


`sockfd = socket(AF_INET, SOCK_STREAM, 0)`
If the third argument is zero (and it always should be except for unusual circumstances), the operating system will choose the most *appropriate* protocol. It will choose `TCP for stream sockets`and `UDP for datagram sockets`.

The socket system call returns an entry into the file descriptor table (i.e. a small integer). This value is used for all subsequent references to this socket.


To allow the server to handle multiple simultaneous connections, we make the following changes the code:

1. Put the `accept` statement and the following code in an infinite loop.

2. After a connection established, call `fork()` to create a new process.

3. The child process will close `sockfd` and call `dostuff() (a psuedo function that contains all stuff)`, passing the new socket file descriptor as an argument. When the two processes have completed their conversation, as indicated by `dostuff()` returning, this process simply exits.

4. The parent process closes `newsockfd`. Because all of this code is in an infinite loop, it will return to the accept statement to wait for the next connection.





















