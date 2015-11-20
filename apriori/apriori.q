// power set 
ps:{raze {[v;p] raze l,/:'(1+v?/:last each l:(),p)_\:v}[s;]\[s:(),x]};
// params: transaction list, minsupport, min confidence
apriori:{[ts;ms;mc]
  ee:enlist each;
  // aprior principle:subsets of freq items are freq items
  f:c where all each in\:[ ;c] ps each c:where ms<=(cts:count each group raze ps each ts);
  // have min conf and are not just reflexive rules
  #[;pr] where (not(~) ./:key pr)&mc<=pr:(raze (ee each a),\:'ee f)!raze cts[f]%cts a:ps each f
 };

ts:(1 2 5; 2 4; 2 3; 1 2 4; 1 3; 2 3; 1 3; 1 2 3 5; 1 2 3)
apriori[ts;2;0.5]