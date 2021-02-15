class Segment {
  private PVector p1, p2;
  private color myColor;

  public Segment(int x1, int y1, int x2, int y2) {
    p1 = new PVector(x1, y1);
    p2 = new PVector(x2, y2);
    myColor = color(0);
  }

  void display() {
    stroke(myColor);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  public String ToString() {
    return "Segment Info: Endpoint 1 = "+PVectorToStringVec2(p1)+" | Endpoint 2 = "+PVectorToStringVec2(p2);
  }

  public String EndpointsToString() {
    return PVectorToStringVec2(p1)+", "+PVectorToStringVec2(p2);
  }

  private String PVectorToStringVec2(PVector point) {
    return "("+point.x+", "+point.y+")";
  }

  public void changeColor(char mode) {
    if (mode == 'g')
      myColor = color(0, 128, 0);
    else
      myColor = color(255, 0, 0);
  }

  public float getLowerY() {
    return min(p1.y, p2.y);
  }

  public float getUpperY() {
    return max(p1.y, p2.y);
  }
}
