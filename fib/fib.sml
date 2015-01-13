local
	fun fib0 0 ls = ls
	|	fib0 n (ls as x :: y :: xs) = fib0 (n- 1) ((x + y) :: ls)
	handle Overflow => ls
	in
	fun fib n = if n <= 2 then [] else rev (fib0 (n - 2) [1, 1]);
end;


