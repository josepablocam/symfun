class GreaterThan implements HeapCompare<Integer> { //used to implement max heap)
	public boolean eval(Integer n1, Integer n2) {
		return n1 > n2;
	}
	
}


public class HeapExample {
	public static void main(String[] args) {
		
		Integer[] toInsert = {0, -1, 10, 2, 3, 8, -2, 8, 1, 11};
		Heap<Integer> intHeap = new Heap<Integer>(toInsert.length, new GreaterThan());
		
		//fill up our heap
		System.out.println("Inserting into max-heap");
		for(int i = 0; i < toInsert.length; i++) {
			try {
				intHeap.insert(toInsert[i]);
			} catch(HeapException ex) {
				ex.printStackTrace();
			}
		}
		
		//retrieve (and remove) values from heap
		System.out.println("Removing from max-heap");
		while(!intHeap.isEmpty()) {
			try {
				System.out.println(intHeap.remove());
			} catch(HeapException ex) {
				ex.printStackTrace();
			}
		}
		
		//Now let's use our static method heapSort to sort an array of integers
		Heap.<Integer>heapSort(toInsert, new GreaterThan());
		
		System.out.println("sorting");
		for(int i = 0; i < toInsert.length; i++) {
			System.out.print(toInsert[i] + " ");
		}
		System.out.println();
		
		
	}
	
}