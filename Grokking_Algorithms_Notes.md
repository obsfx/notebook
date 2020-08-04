##### Logarithms [Page 7]

You may not remember what logarithms are, but you probably know what
exponentials are. log 10 100 is like asking, “How many 10s do we multiply
together to get 100?” The answer is 2: 10 × 10. So log 10 100 = 2. Logs are the flip of exponentials.



##### Big O notation [Page 11]

*Algorithm running times grow at different rates*

The run time in Big O notation is O(n). Where are the seconds? There are none—Big O doesn’t tell you the speed in seconds. Big O notation lets you compare the number of operations. It tells you how fast the algorithm grows.

• O(log n), also known as log time. Example: Binary search.

• O(n), also known as linear time. Example: Simple search.

• O(n * log n). Example: A fast sorting algorithm, like quicksort
(coming up in chapter 4).

• O(n 2 ). Example: A slow sorting algorithm, like selection sort
(coming up in chapter 2).

• O(n!). Example: A really slow algorithm, like the traveling
salesperson (coming up next!).



##### Arrays and linked lists [Page 24]

With linked lists, your items can be anywhere in memory. Each item stores the address of the next item in the list. A bunch of random memory addresses are linked together.



##### Checking fewer elements each time [Page 35]

Maybe you’re wondering: as you go through the operations, the number
of elements you have to check keeps decreasing. Eventually, you’re down
to having to check just one element. So how can the run time still be
O(n 2 )? That’s a good question, and the answer has to do with constants
in Big O notation. I’ll get into this more in chapter 4, but here’s the gist.
You’re right that you don’t have to check a list of n elements each time.
You check n elements, then n – 1, n - 2 ... 2, 1. On average, you check a
list that has 1 / 2 × n elements. The runtime is O(n × 1 / 2 × n). But constants like 1 / 2 are ignored in Big O notation (again, see chapter 4 for the full discussion), so you just write O(n × n) or O(n 2 ).



##### Recursion Recap

• Recursion is when a function calls itself.

• Every recursive function has two cases: the base case
and the recursive case.

• A stack has two operations: push and pop.

• All function calls go onto the call stack.

• The call stack can get very large, which takes up a lot of memory.



##### Hash Tables [Page 78]

The hash function tells you exactly where the price is stored, so you
don’t have to search at all! This works because

• The hash function consistently maps a name to the same index. Every
time you put in “avocado”, you’ll get the same number back. So you
can use it the first time to find where to store the price of an avocado,
and then you can use it to find where you stored that price.

• The hash function maps different strings to different indexes.
“Avocado” maps to index 4. “Milk” maps to index 0. Everything maps
to a different slot in the array where you can store its price.

• The hash function knows how big your array is and only returns valid
indexes. So if your array is 5 items, the hash function doesn’t return
100 ... that wouldn’t be a valid index in the array.

##### [Page 90]

##### [Page 104]

##### Dijkstra’s algorithm [Page 120]

To recap, Dijkstra’s algorithm has four steps:

1. Find the cheapest node. This is the node you can get to in the least
amount of time.

2. Check whether there’s a cheaper path to the neighbors of this node.
If so, update their costs.

3. Repeat until you’ve done this for every node in the graph.

4. Calculate the final path. (Coming up in the next section!)

To calculate the shortest path in an unweighted graph, use *breadth-first*
*search*. To calculate the shortest path in a weighted graph, use *Dijkstra’s*
*algorithm*.



With an undirected graph, each edge adds another cycle.
Dijkstra’s algorithm only works with *directed acyclic graphs,*
called DAGs for short.



**[Page 123]**



You can’t use Dijkstra’s algorithm if you have negative-weight edges. Negative-weight edges break the algorithm.

If you want to find the shortest path in a graph that has negative-weight edges, there’s an algorithm for that! It’s called the Bellman-Ford algorithm.
