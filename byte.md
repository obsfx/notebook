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



ref: [ https://stackoverflow.com/questions/119123/why-isnt-sizeof-for-a-struct-equal-to-the-sum-of-sizeof-of-each-member/119134#119134](https://stackoverflow.com/questions/119123/why-isnt-sizeof-for-a-struct-equal-to-the-sum-of-sizeof-of-each-member/119134#119134)

> It's for alignment. Many processors can't access 2- and 4-byte quantities (e.g. ints and long ints) if they're crammed in every-which-way.
>
> Suppose you have this structure:

```c
struct {
    char a[3];
    short int b;
    long int c;
    char d[3];
};
```

> Now, you might think that it ought to be possible to pack this structure into memory like this:

```
+-------+-------+-------+-------+
|           a           |   b   |
+-------+-------+-------+-------+
|   b   |           c           |
+-------+-------+-------+-------+
|   c   |           d           |
+-------+-------+-------+-------+
```

> But it's much, much easier on the processor if the compiler arranges it like this:

```
+-------+-------+-------+
|           a           |
+-------+-------+-------+
|       b       |
+-------+-------+-------+-------+
|               c               |
+-------+-------+-------+-------+
|           d           |
+-------+-------+-------+
```

> In the packed version, notice how it's at least a little bit hard for you and me to see how the b and c fields wrap around? In a nutshell, it's hard for the processor, too. Therefore, most compilers will pad the structure (as if with extra, invisible fields) like this:

```
+-------+-------+-------+-------+
|           a           | pad1  |
+-------+-------+-------+-------+
|       b       |     pad2      |
+-------+-------+-------+-------+
|               c               |
+-------+-------+-------+-------+
|           d           | pad3  |
+-------+-------+-------+-------+
```



ref: [https://stackoverflow.com/a/119491](https://stackoverflow.com/a/119491)

If you want the structure to have a certain size with GCC for example use [`__attribute__((packed))`](http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/).

On Windows you can set the alignment to one byte when using the cl.exe compier with the [/Zp option](http://msdn.microsoft.com/en-us/library/xh3e3fd0(VS.80).aspx).

Usually it is easier for the CPU to access data that is a multiple of 4 (or 8), depending platform and also on the compiler.

So it is a matter of alignment basically.

**You need to have good reasons to change it.**