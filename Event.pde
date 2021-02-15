class Event{
  private Segment segment; // Segment this is an event for
  private float x; // X position where this event occurs
  private char type; // 'b' for birth, 'd' for death, 'v' for vertical

  public Event(Segment segment, float x, char type){
    this.segment = segment;
    this.x = x;
    this.type = type;
  }

  public Segment getSegment(){
    return this.segment;
  }

  public float getX(){
    return this.x;
  }

  public char getType(){
    return this.type;
  }
}
