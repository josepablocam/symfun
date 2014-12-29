class IsOdd implements QueuePredicate<Integer> {
	public boolean eval(QueueElem<Integer> e) {
		return e.getPayload() % 2 != 0;
	}
}


public class PriorityQueueTestDrive {
	
	public static int priority_limit = 10;
	public static int size = 10;
	
	public static int randPriority() {
		return (int) (Math.random() * priority_limit);
	}
	
	
	public static void main(String[] args) {
		PriorityQueue<Integer> q = new PriorityQueue<Integer>();
		
		
		int priority;
		
		for(int i = 0; i < size; i++) {
			priority = randPriority();
			System.out.println("Enqueueing " + i + " w/ priority " + priority);
			q.enqueue(i, priority);
		}
		
		/* dequeueing first odd, risky since we're not catching exception,
			 but we expect size/2 odds so shoudl be fine */
			
		System.out.println("Dequeued with predicate " + q.dequeuePred(new IsOdd()));	
		
		
		while(!q.isEmpty()) {
			
			Integer elem= q.dequeue();
			System.out.println("Dequeued " + elem);
		}
		
		
	} 
	
	
}