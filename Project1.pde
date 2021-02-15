/*@author Chaoneng Quan  //<>// //<>//
 */
private static final int RAND_SEED = 345;
private static final String HORIZONTAL_FILENAME = "horizontal_steve01.in";
private static final String VERTICAL_FILENAME = "vertical_steve01.in";


MinHeap myMinHeap = new MinHeap();
MinHeap myMinHeapCopy = new MinHeap();
SkipList mySkipList = new SkipList(RAND_SEED);
ArrayList<Event> eventList = new ArrayList<Event>();
PrintWriter output;
ArrayList<String> outputLines = new ArrayList<String>();

void setup() {
  //GUI setup
  size(850, 850);
  //File operation
  String fileLine = null;
  BufferedReader reader;
  int x1, y1, x2, y2;
  //Reading horizontal.in file
  try {
    reader = createReader(HORIZONTAL_FILENAME);  //change file name here for different testcases
    fileLine = reader.readLine();  //read size first, but i dont need it.
    println("First line of the file is: "+fileLine);
    while ((fileLine = reader.readLine()) != null) {
      String[] fileds = fileLine.split(",");
      x1 = parseInt(fileds[0].trim());
      y1 = parseInt(fileds[1].trim());
      x2 = parseInt(fileds[2].trim());
      y2 = parseInt(fileds[3].trim());
      //println("("+x1+", "+y1+")"+"("+x2+", "+y2+")");
      //line(x1,y1,x2,y2);
      //Adding events into MinHeap
      //once per line
      Segment sgmt = new Segment(x1, y1, x2, y2);
      Event birth = new Event(sgmt, (float)x1, 'b');
      Event death = new Event(sgmt, (float)x2, 'd');
      myMinHeap.addEvent(birth);
      myMinHeap.addEvent(death);
      myMinHeapCopy.addEvent(birth);
      myMinHeapCopy.addEvent(death);
    }
    reader.close();
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  //Reading vertical.in file
  try {
    reader = createReader(VERTICAL_FILENAME);  //change file name here for different testcases
    fileLine = reader.readLine();  //read size first, but i dont need it.
    println("First line of the file is: "+fileLine);
    while ((fileLine = reader.readLine()) != null) {
      String[] fileds = fileLine.split(",");
      x1 = parseInt(fileds[0].trim());
      y1 = parseInt(fileds[1].trim());
      x2 = parseInt(fileds[2].trim());
      y2 = parseInt(fileds[3].trim());
      //println("("+x1+", "+y1+")"+"("+x2+", "+y2+")");
      //line(x1,y1,x2,y2);
      //Adding events into MinHeap
      //once per line
      Segment sgmt = new Segment(x1, y1, x2, y2);
      Event vertical = new Event(sgmt, x1, 'v');
      myMinHeap.addEvent(vertical);
      myMinHeapCopy.addEvent(vertical);
    }
    reader.close();
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  //Populate the eventList
  while (myMinHeapCopy.getSize()>0) {
    eventList.add(myMinHeapCopy.extractMin());
  }
}

int index = 0;
int startX;

void draw() {

  stroke(192);
  line(startX, 0, startX, height);
  stroke(0);


  for (Event event : eventList) {
    if (event.getType() == 'b' && startX == event.getX()) {
      noLoop();
      nextStep();
    }
    if (event.getType() == 'd' && startX == event.getX()) {
      noLoop();
      nextStep();
    }
    if (event.getType() == 'v' && startX == event.getX()) {
      noLoop();
      nextStep();
    }
  }

  startX++;

  //keep drawing all the segments
  for (Event event : eventList) {
    event.getSegment().display();
  }

  if (startX == width) {
    println("Creating output file under same directory");
    CreateResults();
  }
}


void keyPressed() {
  if (key == 'n')
    loop();
}

void nextStep() {

  if (index == eventList.size()) {
    println("Program Done!");
  } else {
    Event currentEvent = eventList.get(index);

    if (currentEvent.getType() == 'b') {
      println("brith");
      mySkipList.InsertBySegment(currentEvent.getSegment());
    } else if (currentEvent.getType() == 'd') {
      println("death");
      currentEvent.getSegment().changeColor('g');  //change the segment color to green after explored
      mySkipList.DeleteBySegment(currentEvent.getSegment());
    } else {  //vertical event

      currentEvent.getSegment().changeColor('r');
      float currentX = currentEvent.getX();
      float lowerY = currentEvent.getSegment().getLowerY();
      float upperY = currentEvent.getSegment().getUpperY();
      SkipNode[] nodesInRange = mySkipList.GetInValueRange(lowerY, upperY);
      for (SkipNode node : nodesInRange) {
        ellipse(currentX, node.ValueOf(), 8, 8);
        String outLine = "("+(int)currentX+","+(int)(float)node.ValueOf()+")";
        outputLines.add(outLine);
      }
      outputLines.add("Marker");
    }
    index++;
  }
}


void CreateResults() {
  output = createWriter("intersections.out");

  for (String str : outputLines) {
    if(str.equals("Marker")){
      output.print(" ; ");
    }else{
      output.print(str);
    }
  }

  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}
