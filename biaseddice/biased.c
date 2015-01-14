/*
	given a set of weights for a biased dice generate a random number using that dice 
*/
#include <stdio.h>
#include <stdlib.h>

int binsearch(double target, double cprobs[], int start, int end)
{
	if(end - start == 1) {
		if(target < cprobs[end])
		{
			return start;
		}
		else
		{
			return end;
		}
	}
	
	int mid = (start + end) / 2;
	double comp = cprobs[mid];
	

	if(target == comp) 
	{
		return mid;
	} 
	else if(target < comp) 
	{
		return binsearch(target, cprobs, start, mid);
	}
	else
	{
		return binsearch(target, cprobs, mid, end);
	}
}

void cumsum(double probs[], int len)
{ //convert weights to cdf
	int i;
	double total = 0;
	
	for(i = 0; i < len; i++)
	{
		total += probs[i];
		probs[i] = total;
	}

	
	if(total != 1)
	{
		printf("probabilities do not add to 1\n");
		exit(1);
	}
	
}

double rand01() 
{ //generates random doubles between 0 and 1, excluding 1
	return (double)rand() / ((double) RAND_MAX + 1);
}


int main() 
{
	int i, n = 10000;
	double weights[] = {0, 0.2, 0.3, 0.05, 0.1, 0.2, 0.15}; //note that first number must be 0, and is not one of the weights
	int len = sizeof(weights) / sizeof(double);
	
	cumsum(weights, len);
	
	for(i = 0; i < n; i++)
	{
		printf("%d ", binsearch(rand01(), weights, 0, len));
	}
	
	putchar('\n');
	return 0;
}