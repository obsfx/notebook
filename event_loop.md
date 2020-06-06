# What is the Event Loop ?

The Event loop is allows Node.js to perform non-blocking I/O operations - despite the fact that JavaScript is single threaded - by *offloding* operations to the system kernel whenever possible.
```
    Computional Offloding

    Computional offloading is transferring instensive computational task to a separate processor, such as a GPU, Math chip or a cloud.
    Simply, sharing load with other resources.
```

### The event loop's order of operations.
```
       ┌───────────────────────────┐
    ┌─>│           timers          │
    │  └─────────────┬─────────────┘
    │  ┌─────────────┴─────────────┐
    │  │     pending callbacks     │
    │  └─────────────┬─────────────┘
    │  ┌─────────────┴─────────────┐
    │  │       idle, prepare       │
    │  └─────────────┬─────────────┘      ┌───────────────┐
    │  ┌─────────────┴─────────────┐      │   incoming:   │
    │  │           poll            │<─────┤  connections, │
    │  └─────────────┬─────────────┘      │   data, etc.  │
    │  ┌─────────────┴─────────────┐      └───────────────┘
    │  │           check           │
    │  └─────────────┬─────────────┘
    │  ┌─────────────┴─────────────┐
    └──┤      close callbacks      │
       └───────────────────────────┘
```

   
note: each box will be referred to as a "phase" of the event loop.

### Phases Overview

1. timers: this phase executes callbacks scheduled by setTimeout() and setInterval().
2. pending callbacks: executes I/O callbacks deferred to the next loop iteration.
3. idle, prepare: only used internally.
4. poll: retrieve new I/O events; execute I/O related callbacks (almost all with the exception of close callbacks, the ones scheduled by timers, and setImmediate()); node will block here when appropriate.
5. check: setImmediate() callbacks are invoked here.
6. close callbacks: some close callbacks, e.g. socket.on('close', ...).

Between each run of the event loop, Node.js checks if it is waiting for any asynchronous I/O or timers and shuts down cleanly if there are not any.

### setImmediate() vs setTimeout()

`setImmediate()` and `setTimeout()` are similar, but behave in different ways depending on when they are called.

1. `setImmediate()` is designed to execute a script once the current *poll* phase completes.
2. `setTimeout()` schedules a script to be run after a minimum threshold in ms has elapsed.

The order in which the timers are executed will vary depending on the context in which they are called. If both are called from within the main module, then timing will be bound by the performance of the process.

if we run the following script which is not within an I/O cycle (i.e. the main module), the order in which the two timers are executed is non-deterministic, as it is bound by the performance of the process.

if you move the two calls within an I/O cycle, the immediate callback is always executed first.

### process.nextTick() vs setImmediate()

1. `process.nextTick()` fires immediately on the same phase.
2. `setImmediate()` fires on the following iteration or 'tick' of the event loop.

In essence, the names should be swapped. process.nextTick() fires more immediately than setImmediate(), but this is an artifact of the past which is unlikely to change. Making this switch would break a large percentage of the packages on npm.
