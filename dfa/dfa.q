/
Author: Jose Cambronero (jpc485@nyu.edu)
This is a simple NFA to DFA converter
\

//Basic FA ops
mktbl:{[s;acc;e] update start:all each src in s, accept:any each dest in acc from flip `src`trans`dest!flip e} //convert our graph to a table (faster col access)
t:{[g;s;a] exec dest from g where src in ((),s), trans=a}    //transition from state s to dest on alphabet elem a, using graph g
m:{[g;s;str] raze s t[g;;]\str}                            //simulate DFA on sentence str, assuming start state s and graph g

//NFA to DFA
ec:{[g;s] asc raze {[g;s] s union exec dest from g where src in s, null trans}[g;]/[(),s]} //epsilon closure, inefficient but simple
rmerr:{x where not all each null each x} //remove states consisting solely of errors
gensts:{[g;s;a] (s;;) ./: a,'enlist each ec[g;] each rmerr each t[g;s;] each a:(),a} //move with each possible letter in sentence, then epsilon closure generates new state, return triple (source;transition;ending)
step:{[g;a;e](1_unmrk,except[ ;unmrk,mrk] distinct last each new; mrk:distinct e[1],enlist strt; e[2],new:gensts[g;;a] strt:first unmrk:e 0)} //triple: unmarked, marked, transitions
det:{[g;s;a] mktbl[enlist first first dg; exec distinct dest from g where accept;] dg:last step[g;a;]/[{count first x};(enlist ec[g;s];();())] }

//Printing in dot format (graphviz)
stre0:{[s;t;d] ssr/["%s -> %d [label= %t];"; ("%s";"%t";"%d"); string(s;`eps^`$string t;`err^`$string d)]}
stre:{exec " " sv stre0 .'flip (src;trans;dest) from x}
stradd:{starts:exec " " sv (string[src],\:"[style=bold];") from x where start; starts,exec " "sv (string[dest],\:"[shape=doublecircle];") from x where accept}
toset:{`$ssr["\"{%s}\"";"%s";"," sv string x]}                                                                 //represent a state as a set in bracekts
cleantblNoRename:{update src:toset each src, dest:toset each dest from x}                                      //clean up state names using set notation
cleantblRename:{s:distinct raze x`src`dest; `src`trans xasc update src:s?src, dest:s?dest from x}             //clean up state names using new names
todot:{ssr/["digraph qgraph { %addl %trans } ";("%addl";"%trans");(stradd;stre)@\:x]}

//User interactions
cons:{(`$trim each ","vs/:2#txt),enlist `$trim each "-"vs/:2_txt:txt where 0<count each txt:read0 hsym `$x} //triple of starting states, accepting states, and edges
help:{1 "Usage:q dfa.q -input file [-det][-rename]";exit 0}

main:{
  if[not `input in key ops:.Q.opt .z.x;help[]]; //we always need input file
  inputf:first ops`input;
  if["1"~first first system"test -f ",inputf,";echo $?"; show "Input file not found"; exit 1]; //could we read it?
  g:mktbl . cons inputf;  //build graph from input file
  cleantbl:$[`rename in key ops; cleantblRename; cleantblNoRename]; //set up type of state name cleaning
  1 todot $[`det in key ops;cleantbl det[g;exec distinct src from g where start;exec distinct trans from g where not null trans];g]; //determinize if requested  
  exit 0;
 }

main[]


