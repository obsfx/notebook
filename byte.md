# things about bytes

#### a byte is the smallest unit of memory access, i.e. each memory address specifies a different byte

```
1 byte -> 8bit 	-> 00000000
2 byte -> 16bit -> 00000000 00000000
4 byte -> 32bit -> 00000000 00000000 00000000 00000000
8 byte -> 64bit -> 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
```

ref: [https://carld.github.io/2017/06/20/lisp-in-less-than-200-lines-of-c.html](https://carld.github.io/2017/06/20/lisp-in-less-than-200-lines-of-c.html)

```c
#define is_pair(x) (((long)x & 0x1) == 0x1)  /* tag pointer to pair with 0x1 (alignment dependent)*/
#define untag(x)   ((long) x & ~0x1)
#define tag(x)     ((long) x | 0x1)
```

Above contains a curiosity that can be found in many language implementations. Remember from the List structure that the data pointer can be either a char * a symbol, or List * another List. The way we are indicating the type of pointer is by setting the lowest bit on the pointer on. 

For example, given a pointer to the address **0x100200230**, if it’s a pair we’ll modify that pointer with a bitwise or with 1 so the address becomes **0x100200231**. The questionable thing about modifying a pointer in this way is how can we tell a pointer tagged with 1, from a regular untagged address. 

Well, partly as a performance optimization, many computers and their Operating Systems, allocate memory on set boundaries .It’s referred to as memory alignment, and if for example the alignment is to an 8-byte (64 bit) boundary, it means that when memory is allocated it’s address will be a multiple of 8.

For example the next 8 byte boundary for the address **0x100200230** is **0x100200238**. Memory could be aligned to 16-bits (2 bytes), 32-bits (4 bytes) as well. Typically it will be aligned on machine word, which means 32-bits if you have a 32-bit CPU and bus.