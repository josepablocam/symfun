val rng = Random.rand(0, 0);
fun rand from to = from + ((to - from) * Random.randReal rng);
fun randList from to sz = List.tabulate(sz, fn x => rand from to);


(* plain Monte carlo integration *)
fun plain f from to n = ((to - from) / (real n)) * (foldl (fn (x, y) => f(x) + y) 0.0 (randList from to n));
	
	
(* stratified monte carlo integration *)
fun strat f from to n = 
	let
		val mid = (from + to) / 2.0;
		val halfn = n div 2
	in
		if n < 2 then plain f from to n else 
			((strat f from mid halfn) + (strat f mid to halfn)) 
	end;

