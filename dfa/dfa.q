/
Author: Jose Cambronero (jpc485@nyu.edu)
This is a simple NFA to DFA converter
\
mktbl:{[s;acc;e] update start:all each src in s, accept:any each dest in acc from flip `src`trans`dest!flip e} //convert our graph to a table (faster col access)
cleantbl:{s:exec distinct (src,dest) from x; `src`trans xasc update src:s?src, dest:s?dest from x} //clean up src/dest names
t:{[g;s;a] exec dest from g where src in ((),s), trans=a}    //transition from state s to dest on alphabet elem a, using graph g
//m:{[g;s;str] raze s t[g;;]\str}                              //simulate DFA on sentence str, assuming start state s and graph g

ec:{[g;s] asc raze {[g;s] exec dest from g where src in s, null trans}[g;]\[{count x};(),s]} //epsilon closure
step:{[g;s;a] (s;;) ./: a,'enlist each ec[g;] each t[g;s;] each a:(),a} //one iteration: move with each possible  letter in sentence, then epsilon closure generates new state, return triple (source;transition;ending)
remerr:{x where not all each null each x} //remove states consisting solely of errors
det:{[g;s;a] 
  dg:last {[g;a;e](remerr 1_um,except[ ;um] last each s; e[1],s:step[g; ;a] first um:e 0)}[g;a;]/[{count first x};(enlist ec[g;s];())];
  cleantbl mktbl[first first dg;exec distinct dest from g where accept;dg] 
  }

//printing with dot
stre0:{[s;t;d] ssr/["%s -> %d [label= %t];"; ("%s";"%t";"%d"); string(s;`eps^`$string t;`err^`$string d)]}
stre:{exec " " sv stre0 .'flip (src;trans;dest) from x}
stradd:{starts:exec " " sv (string[src],\:"[style=bold];") from x where start; starts,exec " "sv (string[dest],\:"[shape=doublecircle];") from x where accept}
format:{ssr/["digraph qgraph { %addl %trans } ";("%addl";"%trans");(stradd;stre)@\:x]}
dotprint:{[ofile;g] system ssr/["echo \"%graph\" | dot -Tpng -o %outfile";("%outfile";"%graph");(ofile;format g)]}

//consuming input
cons:{(`$trim each ","vs/:2#txt),enlist `$trim each "-"vs/:2_txt:read0 hsym `$x} //triple of starting states, accepting states, and edges
help:{show "Usage: <q-fa> [-of output_file] -if input_file [-det]";exit 0}

main:{
  if[not `if in key ops:.Q.opt .z.x;help[]]; //we always need input file
  if["1"~first first system"test -f ",(first ops`if),";echo $?"; show "Input file not found"; exit 1];
  g:mktbl . cons first ops`if;  //build graph from input file
  //if determinzation requested, print out nfa version, then determinize
  if[`det in key ops;dotprint["nfa_",first ops`of;g];g:det[g;exec src from g where start;exec distinct trans from g where not null trans]]; 
  dotprint[first ops`of;g]; //print out to file
  exit 0;
 }

main[]






/ 
example 
ex:((0;"x";1);
    (1;"x";2);
    (2;" ";1);
    (0;" ";3);
    (3;"y";4);
    (4;" ";3));
g:mktbl[0;2 4;ex]
dotprint["nfa.png";g]
dotprint["dfa.png";det[g;0;"xy"]]


ex2:((0;"a";1);
   (0;"b";3);
   (1;"a";2);
   (1;"b";0N);
   (2;"a";0N);
   (2;"b";0N);
   (3;"a";0N);
   (3;"b";0N))

g:mktbl[0;2 3;ex2]
det[g;0;"ab"]
dotprint["dfa_1.png";g]
dotprint["dfa_2.png";det[g;0;"ab"]]

