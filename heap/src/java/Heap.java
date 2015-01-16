public class Heap<T> {
	private final int maxSize;
	private int size;
	private T[] queue;
	private HeapCompare<T> comp;
	private static final int ROOT = 0;
	
	
	private static int parent(int i) {
		return (i - 1) / 2; // parent of node i
	}
	
	private static int left(int i) {
		return (2 * i) + 1; //left child
	}
	
	private static int right(int i) {
		return (2 * i) + 2; //right child
	}
	
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
	

	//establish heap property for tree rooted at i using an arbitrary comparison operattion
	private static <E> void heapify(E[] arr, int i, int size, HeapCompare<E> comp) {
		int leftChild = left(i), rightChild = right(i);
		int root = i; //index of largest(in max-heap) or smallest (in min-heap) value, initially assume heap property holds
		
		if(leftChild < size && comp.eval(arr[leftChild], arr[root])) {
			root = leftChild;
		}
		
		if(rightChild < size && comp.eval(arr[rightChild], arr[root])) {
			root = rightChild;
		}
		
		if(root != i) { //heap prop doesn't hold, we need to heapify
			E temp = arr[i];
			arr[i] = arr[root]; //swap to put the true root in it's place...
			arr[root] = temp;
	
			Heap.<E>heapify(arr, root, size, comp); //recursively heapify subtree
		}
		
		
	}
	

	public void insert(T elem) throws HeapException { 
		/* place the element in the next empty space and let value bubble up 
			if necessary to maintain heap property */
			
		if(isFull()) {
			throw new HeapException("Heap is Full");
		}	
		
		int i = size;
		queue[i] = elem; //placed it in the currently empty spot
		
		int p;
		
		while((p = parent(i)) >= ROOT && comp.eval(queue[i], queue[p])) {
			// we can only swap when there are more than 1 element, and when the heap prop is violated and
			// we need to let the value "float" up
			T temp = queue[p];
			queue[p] = queue[i];
			queue[i] = temp;
			i = p;
		}
		
		size++;
	}
	
	
	public T remove() throws HeapException { 
		/* take element from the root, swap in the element at the end of the heap,
			 and heapify */
		if(isEmpty()) {
			throw new HeapException("Heap is Empty");
		}
		
		T elem = queue[ROOT];
		size--; 
		
		if(size >= 1) { //there are other elements in the heap
			queue[ROOT] = queue[size]; //last element in the heap (we already reduced this by 1)
			Heap.<T>heapify(queue, ROOT, size, comp); //restablish the heap property		
		}
		
		
		return elem;
	}

	public T peek() throws HeapException {
		//return root of heap without removing
		if(isEmpty()) {
			throw new HeapException("Heap is Empty");
		}
		
		return queue[ROOT];
	}

	public static <E> void makeHeap(E[] arr, HeapCompare<E> comp) {
		//make a regular array conform to the heap property
		for(int i = (arr.length - 1) / 2; i >= 0; i--) {
			Heap.<E>heapify(arr, i, arr.length, comp);
		}		
	}


	public static <E> void heapSort(E[] arr, HeapCompare<E> comp) {
		//sort an array using heap sort, make it into a heap and then
		//repeatedly swap root and last element, decrease size and then heapify
		int size = arr.length;
		
		makeHeap(arr, comp);
		
		for(int i = size - 1; i >= 1; i--) { //iterate from last to second to first element (no need to do on the first)
			//swap root and and last, decrease size
			E temp = arr[i];
			arr[i] = arr[ROOT]; 
			arr[ROOT] = temp;
			Heap.<E>heapify(arr, ROOT, --size, comp);	
		} 
		
		
	}
	
	
	public Heap(int maxSize, HeapCompare comp) {
		this.maxSize = maxSize;
		this.size = 0;
		queue = (T[]) new Object[maxSize]; //type un-safe 
		this.comp = comp;
	}
	
}