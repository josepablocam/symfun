(* 
a simple implementation of a priority queue using ML, part of a series posted to symfun.wordpress.com

Note that given our use of a simple list to implement the priority queue, our enqueue function is 0(N), dequeue is O(1) and dequeue_pred is O(N).

We could instead implement using a heap to get O(log N) enqueue and dequeue operations. However, we leave that for a later post on heaps in general
*)


(* list of tuples is a queue *)
datatype 'a queue = Q of ('a * int) list; 

(* enqueue helper returns a list for enqueue to wrap in data constructor *)
fun enqueue0 new [] = [new]
|	enqueue0 (new as (n, p1)) (old as (e, p2) :: xs) = 
	if p1 <= p2 then (e, p2) :: enqueue0 new xs 
	else new :: old
;

(* returns a new queue with the element enqueued according to priority *)
fun enqueue e p (Q q) = Q (enqueue0 (e, p) q); 

(* returns a tuple of an option containing the element and new queue *)
fun dequeue (Q []) = (NONE, Q [])
|	dequeue (Q ((e,p) :: xs)) = (SOME e, Q xs)
;

(* returns first element in queue,but not the new queue *)
fun peek x = #1 (dequeue x);


(* a helper for dequeue_pred which returns the first element to satisfy a predicate *)
fun dequeue_pred0 f [] _ = (NONE, [])
|	dequeue_pred0 f ((e, p) :: xs) ys = 
	if f (e, p) then (SOME e, (rev ys) @ xs) 
	else dequeue_pred0 f xs ((e, p) :: ys)
;

fun dequeue_pred f (Q q) = 
	let 
		val (e, ls) = dequeue_pred0 f q [] 
	in 
		(e, Q ls) 
	end;
		
(* merge 2 priority queues...terrible perf O(n^2), effectively insertion sort *)
fun merge (Q q1) (Q q2) = foldl (fn ((e, p), q) => enqueue e p q) (Q q1) q2;		


val q = Q [];
val qi = enqueue 10 1 q;
val qi = enqueue 2 4 qi;
val qi = enqueue 3 0 qi;
val qi = enqueue 4 2 qi;
val (e, qi) = dequeue qi;
val (e, qi) = dequeue_pred (fn (e, p) => e mod 2 = 1) qi;

val qi2 = enqueue ~1 4 q;
val qi2 = enqueue ~2 2 qi2;

val qim = merge qi qi2; 

val qs = enqueue "a" 1 q;
val qs = enqueue "b" 2 qs;
val qs = enqueue "c" 3 qs;

val sorted = merge (Q []) (Q [(~1, ~1), (2, 2), (3, 3), (1, 1)]);





