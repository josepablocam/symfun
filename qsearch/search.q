// remove attribute, clutters print
sort:{`#raze asc each x (asc key g)#g:group count each string x}
// find non null matches for prefix
startWith:{[v;p] v where (not null v)&(string v) like string[p],"*"}
// variables
vars:{system "v ",string x}
// functions
funs:{system "f ",string x}
// tables
ts:tables;
// search across all and sort
search:{[ns;p] (sort startWith[ ;p]@) each `vars`funs`ts!(vars;funs;tables)@\:ns}
// add info for each found and format nicely
format:{[ns;d] select by n from update t:(type each get each ` sv/:ns,/:n) from ([]n:raze value d; tag:raze (count each d)#'(key d))}
// get last term in a "sentence" to use as search
getLast:{((count x)^neg first where not reverse[x] in "_.",.Q.an) sublist x}
// split into namespace path and prefix of name
split:{(`.^`$"." sv -1_s),`$last s:"." vs x}
// provide info for a partial term
info:{format[first a; ] search . a:split getLast x}
// wrapped to catch errors
safeInfo:{@[info;x;{1 "invalid ns: ",x,"\n";}]}
// attach to input handler
.z.pi:{show $[x like "search *";safeInfo " " sv 1_" " vs -1_x;value x];}
