import java.util.NoSuchElementException;

class QueueElem<T>{
	private T payload;
	private int priority;
	private QueueElem<T> next; /* for linked list purposes */	
	
	public void setPayload(T payload) {
		this.payload = payload;
	}
	
	public T getPayload() {
		return payload;
	}
	
	public void setPriority(int priority) {
		this.priority = priority;
	}
	
	public int getPriority() {
		return priority;
	}
	
	public void setNext(QueueElem<T> next) {
		this.next = next;
	}
	
	public QueueElem<T> getNext() {
		return next;
	}
	
	
	public QueueElem(T payload, int priority) {
		setPayload(payload);
		setPriority(priority);
		setNext(null);
	}
}



public class PriorityQueue<T> {
	private QueueElem<T> head = null;
	
	public boolean isEmpty() {
		return head == null;
	}
	
	
	public void enqueue(T elem, int priority) {
		QueueElem<T> new_elem = new QueueElem<T>(elem, priority); /* create element */
		
		QueueElem<T> prior = null;
		QueueElem<T> curr = head;
			
		while(curr != null && curr.getPriority() >= priority) {
			/* we must find the right position, based on priority */
			prior = curr;
			curr = curr.getNext();
		}
			
		if(prior == null) { 
			/* our new element should be the new head*/
			head = new_elem;
			new_elem.setNext(curr); /* if queue was empty, this correctly sets to null */
		} else {
			prior.setNext(new_elem);
			new_elem.setNext(curr);
		}
			
			
	}
	
	public QueueElem<T> peek() throws NoSuchElementException {
		if(this.isEmpty()) {
			throw new NoSuchElementException();
		} else {
			return head;
		}
		
	}	
	
	public QueueElem<T> dequeue() throws NoSuchElementException {
		
		QueueElem<T> elem =  this.peek();
		head = elem.getNext();
		elem.setNext(null);
		
		return elem;
		
	}
	

		

	
}