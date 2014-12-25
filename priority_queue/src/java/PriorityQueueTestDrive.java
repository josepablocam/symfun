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
		
		
		while(!q.isEmpty()) {
			
			QueueElem<Integer> elem= q.dequeue();
			System.out.println("Dequeued " + elem.getPayload());
		}
		
		
	} 
	
	
}