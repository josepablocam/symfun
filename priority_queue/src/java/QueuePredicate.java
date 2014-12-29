public interface QueuePredicate<T> {
	public boolean eval(QueueElem<T> e);
}