#include <stdio.h>
#include <stdlib.h>
#include <limits.h>


int main(int argc, char *argv[])
{
	if(argc < 2)
	{
		printf("please provide # of fibs to calc\n");
		exit(1);
	}
	
	int num = atoi(argv[1]);
	unsigned long n = 1, n_1 = 0, n_2 = 0;
	

	while(num-- > 0 && n_1 <= ULONG_MAX - n_2 )
	{
		printf("%lu ", n);
		n_2 = n_1;
		n_1 = n;
		n = n_1 + n_2;
	}
	putchar('\n');
	return 0;
} 

