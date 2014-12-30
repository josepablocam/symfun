public class Heap<T> {
	private final int maxSize;
	private int size;
	private T[] queue;
	private HeapCompare comp;
	private static final ROOT = 0;
	
	
	private static int parent(int i) {
		return (i - 1) / 2; // parent of node i
	}
	
	private static int left(int i) {
		return 2 * (i + 1); //left child
	}
	
	private static int right(int i) {
		return 2 * (i + 1) + 1; //right child
	}
	

	//maintain heap property for tree rooted at i
	private void heapify(T[] arr, int i, int size, HeapCompare comp) {
		int leftChild = left(i), rightChild = right(i);
		int max_i = i; //assume heap property holds
		
		if(leftChild < size && comp.eval(arr[leftChild], arr[max_i])) {
			max_i = leftChild;
		}
		
		if(rightChild < size && comp.eval(arr[rightChild], arr[max_i])) {
			max_i = rightChild;
		}
		
		if(max_i != i) { //we need to heapify
			T temp = arr[i];
			arr[i] = arr[max_i];
			arr[max_i] = temp;
	
			heapify(arr, max_i, size); //recursively heapify subtree
		}
		
		
	}
	
	/* we don't want setters for these */
	public int getMaxSize() {
		return maxSize;
	}
	
	public int getSize() {
		return size;
	}
	
	public boolean isFull() {
		return size == maxSize;
	}
	
	public boolean isEmpty() {
		return size == 0;
	}

	/* writing out signatures */
	public void insert(T elem) throws HeapException{ 
		/* place the element in the next empty space and let value bubble up 
			if necessary to maintain heap property */
			
		if(isFull()) {
			throw new HeapException("Heap is Full");
		}	
		
		int i = size;
		queue[i] = elem;
		
		
		while((int parent = parent(i)) >= ROOT && this.comp.eval(queue[parent], queue[i])) {
			//swap them
			T temp = queue[parent];
			queue[parent] = queue[i];
			queue[i] = temp;
			i = parent;
		}
		
		size++;
	}
	
	
	public T remove() throws HeapExcetion { 
		/* take element from the root, swap in the element at the end of the heap,
			 and heapify */
		if(isEmpty()) {
			throw new HeapException("Heap is Empty");
		}
		
		T elem = queue[ROOT];
		
		//we only swap around if there is more than 1 element in the heap
		if(size > 1) {
			queue[ROOT] = queue[this.size - 1]; //last element in the heap
			heapify(queue, ROOT, this.size, this.comp); //restablish the heap property		
		}
		
		size--;
		return elem;
	}


	public static void makeHeap(T[] arr, HeapCompare comp) {
		//make a regular array conform to the heap property
		for(int i = arr.length / 2; i >= 0; i--) {
			heapify(arr, i, arr.length, comp);
		}		
	}


	public static void heapSort(T[] arr, HeapCompare comp) {
		int size = arr.length;
		
		makeHeap(arr);
		
		for(int i = size - 1; i >= 0; i--) {
			//swap root and size value
			T temp = arr[i];
			arr[i] = arr[ROOT]; 
			arr[ROOT] = temp;
			heapify(arr, ROOT, size--, comp);	
		} 
		
		
	}
	
	
	public Heap(int maxSize) {
		this.maxSize = maxSize;
		queue = new T[maxSize];
	}
	
}