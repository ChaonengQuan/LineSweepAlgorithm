/* @author Chaoneng Quan
 * A auto-adjust size MinHeap
 */
class MinHeap {
  private static final int INITIAL_CAPACITY = 45;  //initial capacity is 10
  private Event[] BaseArray;  //array based data structure
  private int size;  //number of elements

  /*----------Constructor----------*/
  // Set-up min-heap
  public MinHeap() {
    this.BaseArray = new Event[INITIAL_CAPACITY];  //initial capacity is 10
    size = 0; //initial size is 0
  }

  /*----------Public Methods----------*/
  // Pop the top of the heap.
  public Event extractMin() {
    Event min = BaseArray[0];  //The min is the first element of the array
    BaseArray[0] = BaseArray[size - 1];  //Move the last element to root
    size--;  //shrink array size by 1
    minHeapify(0);  //maintain the minHeap
    return min;
  }

  // Add an event to the heap.
  public void addEvent(Event e) {
    if (size == BaseArray.length) {  //If BaseArray is full, then grow the BaseArray's capacity by 10
      BaseArray = growBaseArray(BaseArray);
    }
    BaseArray[size] = e;
    HeapIncreaseKey(size);
    size++;
  }

  public int getSize() {
    return size;
  }

  /*----------Private Methods----------*/
  //Min Heapify the BaseArray, the algorithm can be found from class slides
  private void minHeapify(int currentIndex) {
    if (currentIndex == size) {
      return;
    }
    int left = getLeftChildIndex(currentIndex);
    int right = getRightChildIndex(currentIndex);
    int indexOfSmallest = getSmallestElementIndex(currentIndex, left, right);
    if (indexOfSmallest != currentIndex) {
      swap(currentIndex, indexOfSmallest);
      minHeapify(indexOfSmallest);
    }
  }

  //Return the index of the parent of currIndex's Event
  private int getParentIndex(int currentIndex) {
    return floor((currentIndex-1)/2);
  }

  //Return the index of the left child of currIndex's Event
  private int getLeftChildIndex(int currentIndex) {
    return 2*currentIndex + 1;
  }

  //Return the index of the right child of currIndex's Event
  private int getRightChildIndex(int currentIndex) {
    return 2*currentIndex + 2;
  }

  //Swap two events' position in the minHeap
  private void swap(int index1, int index2) {
    Event temp = BaseArray[index1];
    BaseArray[index1] = BaseArray[index2];
    BaseArray[index2] = temp;
  }

  //Recursively fix the new key and its parent to maintain the minHeap
  private void HeapIncreaseKey(int index) {
    while (index > 0 && (BaseArray[index].getX() < BaseArray[getParentIndex(index)].getX())) {
      swap(index, getParentIndex(index));
      index = getParentIndex(index);
    }
  }

  /*----------Helper Methods----------*/
  //Return a newArray which has same elements as the oldArray, but capacity plus ten
  private Event[] growBaseArray(Event[] oldArray) {
    Event[] newArray = new Event[oldArray.length + INITIAL_CAPACITY];  //capacity + 10
    for (int i = 0; i < oldArray.length; i++) { 
      newArray[i] = oldArray[i];  //copy the entire oldArray into the newArray
    }
    return newArray;
  }

  //Return the index of the Event which has the smallest x value
  private int getSmallestElementIndex(int current, int left, int right) {
    float minX;
    //minX is the smallest x value of three Events
    //If both children or one of them are not in the heap, ignore it.
    if (left >= size && right >= size) {
      minX = BaseArray[current].getX();
    } else if (left >= size) {  
      minX = min(BaseArray[current].getX(), BaseArray[right].getX());
    } else if (right >= size) {  
      minX = min(BaseArray[current].getX(), BaseArray[left].getX());
    } else {  //If all children are in the heap, compare all three
      minX = min(BaseArray[current].getX(), BaseArray[left].getX(), BaseArray[right].getX());  // minX is the smallest Event
    }
    //return the index of the smallest Event
    if (minX == BaseArray[current].getX()) {
      return current;
    } else if (minX == BaseArray[left].getX()) {
      return left;
    } else {
      return right;
    }
  }
}
