(* 
Heap implementation for symfun.wordpress.com 
Author: Jose Cambronero (josepablocam@gmail.com)

*)

(* A heap consists of a root node, and 2 children, each of which are in turn heaps
  additionally we include an int at the start that keeps track of the number of nodes *)
datatype 'a heap = Empty | H of int * 'a * 'a heap * 'a heap;

(* construct a node for the heap *)
fun make_node e =  H(1, e, Empty, Empty);

(* how many elements are in the tree rooted at x *)
fun get_size Empty = 0
|	get_size (H(n, _, _, _)) = n
;

(* insert a value into the heap *)
fun insert lte e Empty = make_node e
|	insert lte e (node as H(n, r, left, right)) = 
	let
		val bal_ins =  insert0 (get_size left <= get_size right) lte (* insert into branch with less elems, to keep balance *)
	in
		if lte(e, r) then bal_ins e node else bal_ins r (H(n, e, left, right))
	end
and insert0 in_left lte e (H(n, root, left, right)) = if in_left then H(n + 1, root, insert lte e left, right) else H(n + 1, root, left, insert lte e right) ;


(* if we remove the root of a subnode, we need to move one of the branches up to replace *)
fun move_up lte Empty = Empty 
|	move_up lte (H(_, _, Empty, Empty)) =  Empty
|	move_up lte (H(n, _, left as H(_, le, _, _), Empty)) = H(n - 1, le, move_up lte left, Empty)
|	move_up lte (H(n, _, Empty, right as H(_, re, _, _))) = H(n - 1, re, Empty, move_up lte right)
|	move_up lte (H(n, _, left as H(_, le, _ , _), right as H(_, re, _, _))) = if lte(le, re) then H(n - 1, re, left, move_up lte right) else H(n - 1, le, move_up lte left, right)
;


fun rem lte Empty = (NONE, Empty)
|	rem lte (heap as H(_, r, _, _)) = (SOME r, move_up lte heap)
;


fun make_heap lte ls = foldl (fn (e, h) => insert lte e h) Empty ls;

fun heapsort0 lte Empty = []
|	heapsort0 lte heap = let val (SOME e, new_heap) = rem lte heap in e::heapsort0 lte new_heap end;

fun heapsort lte ls = heapsort0 lte (make_heap lte ls);



fun print_heap0 spaces toString Empty = TextIO.print(spaces ^ "*\n")
|	print_heap0 spaces toString (H(_, root, left, right)) = 
	let 
		val next_print = print_heap0 (spaces ^ "  ") toString
	in 
	(TextIO.print (spaces ^ toString root ^ "\n"); next_print left; next_print right )
end
;

fun print_heap toString heap = print_heap0 "" toString heap;


heapsort op>= [4,7,1,0, ~10];
			 

val h = insert op<= 1 Empty;
val h = insert op<= 2 h;
val h = insert op<= 3 h;
val h = insert op<= 4 h;
val h = insert op<= 5 h;
val h = insert op<= 6 h;
val h = insert op<= 0 h;
val h = insert op<= ~2 h;

print_heap Int.toString h;

val (e, h) = rem op<= h;
val (e, h) = rem op<= h;
val (e, h) = rem op<= h;
val (e, h) = rem op<= h;
val (e, h) = rem op<= h;
val (e, h) = rem op<= h;
val (e, h) = rem op<= h;
val (e, h) = rem op<= h;


