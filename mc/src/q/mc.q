rng:{[s;e;n] s+n?(e - s)};
plain:{[f;s;e;n] (e-s)*avg f rng[s;e;n]};
strat:{[f;s;e;n] $[n<2;plain[f;s;e;n]; strat[f;s;m;nn] + strat[f; ;e;nn:n div 2] m:(e+s)%2 ]};
