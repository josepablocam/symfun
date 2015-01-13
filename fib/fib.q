//fibunsafe:{{x,sum -2#x}/[x; 1 1]};
fibsafe:{-1_last {(-1+first x;l,sum -2#l:last x)}/[{(0<first x)&0<(last/)x};(x+1; 1 1)]}
//show fibunsafe 40
show fibsafe 40
