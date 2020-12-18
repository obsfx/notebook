# things about bytes

#### a byte is the smallest unit of memory access, i.e. each memory address specifies a different byte

```
1 byte -> 8bit 	-> 00000000
2 byte -> 16bit -> 00000000 00000000
4 byte -> 32bit -> 00000000 00000000 00000000 00000000
8 byte -> 64bit -> 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

0XFF -> 1 byte -> 8bit
0xFF -> 2 byte -> 16bit
```

In [computing](https://en.wikipedia.org/wiki/Computing), a **word** is the natural unit of data used by a particular [processor](https://en.wikipedia.org/wiki/Central_processing_unit) design. A word is a fixed-sized [piece of data](https://en.wikipedia.org/wiki/Data_(computing)) handled as a unit by the [instruction set](https://en.wikipedia.org/wiki/Instruction_set) or the hardware of the processor. The number of [bits](https://en.wikipedia.org/wiki/Bit) in a word (the *word size*, *word width*, or *word length*) is an important characteristic of any specific processor design or [computer architecture](https://en.wikipedia.org/wiki/Computer_architecture).



ref: [https://en.wikipedia.org/wiki/Data_structure_alignment#Problems](https://en.wikipedia.org/wiki/Data_structure_alignment#Problems)

> The CPU accesses memory by a single memory word at a time. As long as the memory word size is at least as large as the largest [primitive data type](https://en.wikipedia.org/wiki/Primitive_data_type) supported by the computer, aligned accesses will always access a single memory word. This may not be true for misaligned data accesses.
>
> If the highest and lowest bytes in a datum are not within the same memory word the computer must split the datum access into multiple memory accesses. This requires a lot of complex circuitry to generate the memory accesses and coordinate them. To handle the case where the memory words are in different memory pages the processor must either verify that both pages are present before executing the instruction or be able to handle a [TLB](https://en.wikipedia.org/wiki/Translation_lookaside_buffer) miss or a [page fault](https://en.wikipedia.org/wiki/Page_fault) on any memory access during the instruction execution.



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



Effectively for us it means that whenever we call `calloc` we’ll always get back an address where the lowest bit is off (0), so we can set it on if we want. (We always get a **even** number since the address is the **multiply of 4 or 8 which depends on the CPU**. So this guarantees that lower-bit of our address **always be off(0)**)

```
0x100200230 -> 100000000001000000000001000110000
0x100200238 -> 100000000001000000000001000111000
0x100200242 -> 100000000001000000000001001000010
.
.
```



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



### strcpy vs strdup

https://stackoverflow.com/questions/14020380/strcpy-vs-strdup

```
strcpy(ptr2, ptr1)` is equivalent to `while(*ptr2++ = *ptr1++)
```

where as strdup is equivalent to

```c
ptr2 = malloc(strlen(ptr1)+1);
strcpy(ptr2,ptr1);
```

([memcpy version](https://stackoverflow.com/a/38033333/2436175) might be more efficient)

So if you want the string which you have copied to be used in another function (as it is created in heap section) you can use strdup, else strcpy is enough.

(With **strcpy** we must create a pointer manually to copy the string to in it, but with **strdup** we dont have to do that because it does this job for us.)



### string interning

https://stackoverflow.com/questions/10578984/what-is-java-string-interning

Basically doing String.intern() on a series of strings will ensure that all strings having same contents share same memory. So if you have list of names where 'john' appears 1000 times, by interning you ensure only one 'john' is actually allocated memory.