(* a simple DSL for maps, aka dictionaries *)
datatype ('a, 'b) dEntry = E of 'a * 'b;

(* constructor *)
fun -->(k, v) = E(k, v);

(* lookup a key *)
fun ?((E(k, v)) :: xs, w) = if k = w then SOME(v) else ?(xs, w)
  | ?([], w) = NONE
  ;
  
(* add a key/value pair to existing dictionary *)
fun <--((he as E(k, v)) :: xs, new as (nk, nv)) = 
  if k = nk then (E(k, nv)) :: xs else he :: <--(xs, new)
  | <--([], new as (nk, nv)) = [ E new ]
  ;

(* drop a key from existing dictionary *)  
fun \((he as E(k, v)) :: xs, w) = if k = w then xs else he :: \(xs, w)
  | \([], w) = []
  ;
  
(* union maps, key/values in second arg win in case of conflict *)
fun U(m1, (E(k, v)) :: xs) = U(<--(m1, (k, v)), xs)
  | U(m1, []) = m1
  ;


(* intersect maps, values in second arg win in case of conflict *)
fun /\((he as E(k, v)) :: xs, m2) = 
  let 
    val matcher =
       fn NONE => /\(xs, m2)
       | SOME(v2) => (E(k, v2)) :: (/\(xs, m2))
    in
      matcher (?(m2, k))
    end
 | /\ ([], m2) = []
  ;
  

infix --> ? <-- \ U /\;

(* simple examples *)
val m1 = ["a" --> 1, "b" --> 2, "c" --> 3]; (* create dict *)
val m2 = ["a" --> 10, "d" --> 4]; (* create dict *)
SOME(1) = (m1 ? "a"); (* lookup a *)
NONE = (m1 ? "d"); (* lookup d *)
NONE = ((m1 \ "a") ? "a"); (* drop entry for key a, and then lookup a *)
SOME(4) = ((m1 U m2) ? "d"); (* union 2 dictionaries and lookup d *)
m1 /\ m2; (* intersect 2 dictionaries *)



