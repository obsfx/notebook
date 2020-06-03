# Summary of HTTP(Hypertext Transfer Protocol) Notes

`referance page: https://www.jmarshall.com/easy/http/`

### What is HTTP ?

It's the network protocol used to deliver virtually all files and other data (collectively called resources) on the World Wide Web.

HTTP usually takes place through TCP/IP sockets.

A browser is an HTTP client because it sends requests to an HTTP server (Web server), which then sends responses back to the client.

### What is "Resources" ?

HTTP is used to transmit `resources`, not just files. A resource is some chunk of information that can be identified by a URL(Uniform Resource Locator) (it's the R in URL).

Almost all HTTP resources are currentlu either files or server-side script output.

### Structure of HTTP Transactions

HTTP uses client-server model. An `HTTP client` opens a connection and sends a request message to an `HTTP server` the server then returns a response message, usually containing the resource that was requested. After delivering the response the server closes the connection(making HTTP a `stateless` protocol, i.e. not maintaining any connection information between transactions).

*The format of the request and response messages are similar, and English-oriented. Both kind of messages consist of:*

1. an initial line
2. zero or more header lines
3. a blank line (i.e. CRLF by itself) and
4. an optional message body (e.g. a file, or query data or query output)

```
    <initial line, different for request vs. response>
    Header1: value1
    Header2: value2
    Header3: value3

    <optinal message body, like file contents or query data, it can be many lines long, or even binary data>
```

Initial lines and headers should end in CRLF.

#### Initial Request Line

[method name] [local path of the requested resource] [version of HTTP being used]

GET /path/to/file/index.html HTTP/1.0

#### Initial Response Line (Status Line)

[HTTP version] [response status] [phrase describing]

HTTP/1.0 200 OK 

or

HTTP/1.0 404 Not Found

#### The first digit of status codes identifies the general category of response:

1. *1xx* indicates an informational message only
2. *2xx* indicates success of some kind
3. *3xx* redirects the client to another URL
4. *4xx* indicates an error on the client's part
5. *5xx* indicates an error on the server's part

#### The most common status codes are:

1. *200 OK* The request succeeded, and the resulting resources is returned in the message body.
2. *404 Not Found* The requested resource does not exist.
3. *301 Moved Permanently*
4. *302 Moved Permanently*
5. *303 See Other(HTTP 1.1 only)*
6. *500 Server Error* An unexpedted server error. The most common cause ise a server-side script that has bad syntax, fails or otherwise can't run correctly.

### Header Lines 

Header lines provide information about the request or response, or about the object sent in the message body.

The header lines are in the usual text header format, which is: one line per header, of the form "Header-name: value", ending with CRLF. It's the same format used for email and news posting.

The following two headers are equivalent:

```
    Header1: some-long-value-1a, some-long-value-1b

    HEADER1:    some-long-value-1a, 
                some-long-value-1b
```

### The Message Body

An HTTP message may have a body of data sent after the header lines. In a response, this is where the requested resource is returned to the client(the most common use of the message body).

*If an HTTP message includes a body, there are usually header lines in the message that describe the body.*

The *Content-Type:* header gives the MIME-type of the data in the body, such as text/html or image/gif.

The *Content-Length*: header gives the number of bytes in the body.

### Sample HTTP Exchange

To retrive the file at the URL

`http://www.somehost.com/path/file.html`

first open a socket to the host www.somehost.com, port 80 ( use the default port of 80 because none is specified in the URL). Then, send something like the following through the socket:

```
    GET /path/file.html HTTP/1.0
    From: someuser@somedomain.com
    User-Agent: HTTPTool/1.0
    [blank line here]
```

The server should respond with something like the following, sent back through the same socket:

```
    HTTP/1.0 OK
    Date: Fri, 29 May 2020 22:00:00 GMT
    Content-Type: text/html
    Content-Length: 1354

    <html>
    <body>
    <h1>Header</h1>
    .
    .
    .
    .
    </body>
    </html>
```

After sending the response, the server closes the socket.

### Other HTTP Methods, HEAD and POST

#### HEAD Method

Just like a GET request but it only recieves the response header not the resource.

The reponse to a HEAD request must never contain a message body, just the status line and headers.

#### POST Method

A POST request is used to send data to the server to be processed in some way. A POST request is different from a GET request in the following ways:
1. There is a block of data sent with the request, in the message body. There are usually extra headers to describe this message body, like *Content-Type* and *Content-Length*.
2. The request URI is not a resource to retrive; it is usually a program to handle the data you are sending.
3. The HTTP response is normally program output, not a static file.

The most common use of POST, by fdar is to submit HTML form data. In this case the *Content-Type:* header is usually *application/x-www-form-urlencoded* and the *Content-Length:* header gives the length of the URL-encoded form data.

Here is a typical form submission, using POST:

```
    POST /path/script.php HTTP/1.0
    From: frog@domain.com
    User-Agent: HTTPTool/1.0
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 32

    home=Cosby&favorite+flavor=flies
```

### HTTP Proxies

An `HTTP proxy` is a program that acts as an intermediary between a client and a server. It receives requests from clients and forwards those requests to the intended servers. The responses pass back through it in the same way. Thus a proxy has functions of both client server.

Proxies are commonly used in firewalls, for LAN-wide caches or in other situations.

When a client uses a proxy, it typically sends all requests to that proxy instead of to the servers in the URLs. Requests to a proxy differ from normal requests in one way: in the first line they use the complete URL of the resource being requested, instead of just path. For example,

```
    GET http://www.somehost.com/path/file.html HTTP/1.0
```

That way, the proxy knows which server to forward the request to (through the proxy itself may use another proxy).

## HTTP 1.1

To comply with HTTP 1.1, clients must:

1. include `Host:` header with each request
2. accept responses with chunked data
3. either support persistent connections, or include the `Connection: close` header with each request
4. handle the `100 Continue` response

### Host: Header

Several domains living on the same server is like several people sharing one phone. Thus, every HTTP request must specify which host name.

```
    GET /path/file.html HTTP/1.1
    Host: www.host1.com
    [blank line here]
```

### Chunked Transfer-Encoding

If a server wants to start sending a response before knowing its total length(like with long script output), it might use the simple checked *transfer-encoding*, which breaks the complete response into smaller chunks and sends them in series. You can identify such a response because it contains the *Transfer-Encoding: chunked* header.

A chunked message body contains a series of chunks, followed by a line with "0"(zero), followed by optional footers(just like heders), and a blank line. Each chunk consists of two parts:

1. a line with size of the chunk data, in hex, possibly followed by a semicolon and extra parameters you can ignore and ending with CRLF.
2. the data itself, followed by CRLF

```
    HTTP/1.1 200 OK
    Date: Fri, 31 Dec 199 22:00:00 GMT
    Content-Type: text/plain
    Transfer-Encoding: chunked

    1a: ignore-stuff-here
    abcdefghijklmnopqrstuvwxyz
    10
    1234567890abcdef
    0
    some-footer: some-value
    another-footer: another-value
    [blank line here]
```

The chunks can contain any binary data, and may be much larger than the examples here. The size-line parameters are rarely used, but you should at least ignore then correctly. Footers are also rare, but might be appropriate for things like checksums or digital signatures.

For comprasion here is the equivalent to the above response, without using chunked encoding:

```
    HTTP/1.1 200 OK
    Date: Fri, 31 Dec 1999 23:59:59 GMT
    Content-Type: text/plain
    Content-Length: 42
    some-footer: some-value
    another-footer: another-value

    abcdefghijklmnopqrstuvwxyz1234567890abcdef
```






















