graph:([src:(); dest:()] weight:`float$())

extendGraph:{[x;y] 
    g:x,(keys x) xkey select src:dest, dest:first 0#dest, weight:first 0#weight from x where not dest in src; //add rows for sinks
    update est:(0w 0)src=y, visited:0b, path:0#'src from g
    }

updateEst:{[x;y]
	adj:select updest:first est+weight, first path by src:dest from x where src=y; //adjustments based on new info
	new:update est:adj[([]src);`updest], path:(adj[([]src);`path],'src) from x where src in (exec src from adj), est>adj[([]src);`updest];
	update visited:1b from new where src=y
	}

ssp:{
 result:{updateEst[x;exec first src from x where not visited, est=min est]}/[{sum not (0!x)`visited}; extendGraph[x;y]];
 `dest`dist xcol delete dest,visited,weight from select by src from result
 } 

`graph upsert ("a";"b"; 4.0)
`graph upsert ("a";"c"; 2.0)
`graph upsert ("b";"c"; 5.0)
`graph upsert ("b";"d"; 10.0)
`graph upsert ("c";"e"; 3.0)
`graph upsert ("d";"f"; 11.0)
`graph upsert ("e";"d"; 4.0)
ssp[graph;"a"]
ssp[graph;"b"]
