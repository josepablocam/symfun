/
	a simple implementation for distributed computation using q
	We use a map-reduce model
	
	General idea: we have 1 server, where the user provides a series of handles for clients
	The server should call the broader function synchronously, and distribute the tasks asynch (so we can send to all servers at once, regardless of whether they are busy)
	
	Clients will receive a function (map), and data, and perform computation (asynch)
	Client then returns results (asynch) into a list held by the server...
	The list is global..... (good/bad idea?)
	Now, the reduce function (also provided by the user) is used to fold over the global list. The client then gets the result
	
\


//////Server////////
.qdist.server.connections:`int$(); //list of nodes for work
.qdist.server.register:{.qdist.server.connections,:.z.w}
.qdist.server.reducedData:(::); //first elem should be null to keep list general
.qdist.server.initReducedData:{.qdist.server.reducedData:(::);}
.qdist.server.appendMapped:{.q.dist.server.reducedData,:x}
.qdist.server.distribute:{[map;reduce;datadist;data]
	.qdist.server.initReducedData[]; //clear reduce data
	{neg[y](`.qdist.node.compute;x;z;`.qdist.server.appendMapped)}[map]'[.qdist.server.connections;datadist data]; //distribute data and compute
	reduce/[.qdist.server.reducedData] //reduce
}


/////Node/////////
.qdist.node.init:{`.qdist.node.master set x}
.qdist.node.register:{(neg .qdist.node.master) `.qdist.server.register}
.qdist.node.compute:{[map;data;sendback]
	neg[.qdist.node.master] (sendback; map data);
	}

///Example: averaging 1e6 numbers
data:(`int$1e6)?100.;
distfun:{(count .q.dist.server.connections) cut x}; //distribute equally across nodes
map:{sum x}
reduce:{x+y}
%[;1e6] .qdist.server.distribute[map;reduce;distfun;data]






	
	