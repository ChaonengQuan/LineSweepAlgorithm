/* @SkipList author Chaoneng Quan
 * the other half is credit to 345 TAs
 */
/*======================================================================
 |>>> SkipNode Class
 +=====================================================================*/
class SkipNode {
  private Float value;
  private Segment segment;
  private int rank;  //This rank of the SkipNode (how many levels of the SkipList it occupies)
  private SkipNode nodeU, nodeD, nodeL, nodeR;

  public SkipNode(Segment s, Float v) {
    segment = s;
    value = v;
    rank = -9999;
    nodeU = nodeD = nodeL = nodeR = null;
  } // Ends Constructor

  //--------------------------------------------------------------------
  //>>> GETTERS
  //--------------------------------------------------------------------

  public Float ValueOf() {
    return value;
  } // Ends Function ValueOf

  public Segment SegmentOf() {
    return segment;
  } // Ends Function SegmentOf

  public SkipNode GetLink(char where) {

    // Handles capital letter input i.e. 'R' vs 'r'
    if (where < 97) {
      where +=32;
    }

    switch(where) {
    case 'u': 
      return nodeU;
    case 'd': 
      return nodeD;
    case 'l': 
      return nodeL;
    case 'r': 
      return nodeR;
    default: 
      println("Error! Expected 'where' input of options {u, d, l, r} --- got {"+where+"} instead!"); 
      return null;
    }
  } // Ends Function SetLink

  public int GetRank() {
    return rank;
  } // Ends Function GetRank

  public String ToString() {
    String out = "SkipNode Info: Value = "+value+" | Rank = "+rank;

    out += (segment==null) ? "" : " | Endpoints: "+segment.EndpointsToString();

    out += " | "+LinkStatus();

    return out;
  } // Ends Function ToString

  private String LinkStatus() {
    String out = "Non-null Links: {";   
    if (nodeU!=null) {
      out+="U";
    }
    if (nodeD!=null) {
      out+="D";
    }
    if (nodeL!=null) {
      out+="L";
    }
    if (nodeR!=null) {
      out+="R";
    } 
    out+="}";  
    return out;
  } // Ends Function LinkStatus

  //--------------------------------------------------------------------
  //>>> SETTERS
  //--------------------------------------------------------------------

  public void SetLink(char where, SkipNode what) {

    // Handles capital letter input i.e. 'R' vs 'r'
    if (where < 97) {
      where +=32;
    }

    switch(where) {
    case 'u': 
      nodeU = what; 
      break;
    case 'd': 
      nodeD = what; 
      break;
    case 'l': 
      nodeL = what; 
      break;
    case 'r': 
      nodeR = what; 
      break;
    default: 
      println("Error! Expected 'where' input of options {u, d, l, r} --- got {"+where+"} instead!");
    }
  } // Ends Function SetLink

  // Note: Trivially uses an 'Honor System' i.e. you can enter any rank you want
  public void SetRank(int r) {
    rank=r;
  } // Ends Function SetRank
} // Ends Class SkipNode



/*======================================================================
 |>>> SkipList Class
 +=====================================================================*/
class SkipList {

  // First and Last nodes of Skiplist uppermost level 
  private SkipNode head;
  private SkipNode tail;

  // Positive and Negative Sentinel values
  private float   negSenVal = -9999; // Negative Sentinel Value
  private float   posSenVal = 9999;  // Positive Sentinel Value

  /*--------------------------------------------------------------------
   | Note: A variable is used for promotion probability as an opportunity
   |       for students to play with different values, i.e. to visualize
   |       what 'Skinny' (p=0.1) and 'Fat' (p=0.9) Skiplists look like!
   +-------------------------------------------------------------------*/
  private float probPromo = 0.5f;  // Promotion Probability

  private int listLength;
  private int listHeight;

  //SkipList Constructor
  public SkipList(int rSeed) {
    head = new SkipNode(null, negSenVal);
    tail = new SkipNode(null, posSenVal);    
    head.SetLink('r', tail);
    tail.SetLink('l', head);
    listLength = 0;
    listHeight = 1;                // height is zero-indexed
    randomSeed(rSeed);
  } // Ends Constructor



  //--------------------------------------------------------------------  
  //>>> GENERAL GETTERS  
  //--------------------------------------------------------------------

  public int Length() {
    return listLength;
  } // Ends Function Length

  public int Height() {
    return listHeight;
  } // Ends Function Height

  public boolean IsEmpty() {
    return (listLength==0);
  } // Ends Function IsEmpty

  public SkipNode GetHeadNode() {
    return head;
  } // Ends Function GetHeadNode

  public void PrintList() {
    PrintList('v');
  } // Ends Function PrintList

  //Print the SkipList level by level start from the top
  public void PrintList(char opcode) {  
    println("Skiplist Basic Stats: #Elements = "+listLength+" | #Levels = "+listHeight);    
    SkipNode buff = head;  
    while (buff!=null) {
      PrintListLevel(buff, opcode);
      buff = buff.GetLink('d');
    }
    println();
  } // Ends Function PrintList [opcode]

  // MODES: 'v'-> Value | 'r'-> Rank
  private void PrintListLevel(SkipNode n, char mode) {
    while (n!=null) {
      if (mode=='v') {
        print("["+n.ValueOf()+"] ");
      }
      if (mode=='r') {
        print("["+n.GetRank()+"] ");
      }
      n = n.GetLink('r');
    }
    println();
  }


  ////--------------------------------------------------------------------
  ////>>> VALUE-ORIENTED GETTERS AND SETTERS
  ////--------------------------------------------------------------------  
  public SkipNode FindByValue(Float v) {  // if v is not in the list, return this one one the left
    SkipNode p = head;
    while (true) {
      while (p.GetLink('r').ValueOf() <= v) {
        p = p.GetLink('r');
      }
      if (p.GetLink('d') == null) {
        return p;
      }
      p = p.GetLink('d');
    }
  }  

  public SkipNode[] GetInValueRange(float l, float r) {
    SkipNode left = FindByValue(l);               
    SkipNode right = FindByValue(r);
    if (left.ValueOf() == right.ValueOf()) {  //if no such nodes are found returns null
      return new SkipNode[0];
    }
    ArrayList<SkipNode> nodes = new ArrayList<SkipNode>();
    SkipNode p = left.GetLink('r');
    while (p.ValueOf() <= right.ValueOf()) {
      nodes.add(p);
      p = p.GetLink('r');
    }
    SkipNode[] result = new SkipNode[nodes.size()];
    for (int i = 0; i < nodes.size(); i++) {
      result[i] = nodes.get(i);
    }
    return result;
  }   


  public void InsertByValue(Float v) {
    int numLevels = getNumLevelOccupied();  //coin flip
    SkipNode p = this.head;
    ArrayList<SkipNode> toBeAdded = new ArrayList<SkipNode>();

    while (listHeight < numLevels) {
      listHeight++;
      SkipNode curLevelHead = new SkipNode(null, negSenVal);
      SkipNode curLevelTail = new SkipNode(null, posSenVal);    
      curLevelHead.SetLink('r', curLevelTail);
      curLevelTail.SetLink('l', curLevelHead);
      curLevelHead.SetLink('d', head);
      this.head = curLevelHead;        //update the head
    }

    p = this.head;
    //modified version of find, use an array to store all the nodes before going down a level
    while (true) {
      while (p.GetLink('r').ValueOf() <= v) {
        p = p.GetLink('r');
      }
      if (p.GetLink('d') == null) {
        toBeAdded.add(p);
        break;
      }
      toBeAdded.add(p);
      p = p.GetLink('d');
    }//end of modified verison of find

    int originalSize = toBeAdded.size();
    for (int i = 0; i < originalSize - numLevels; i++) {
      toBeAdded.remove(0);
    }

    //insert newNode at each numLevel horizontally
    for (int i = 0; i < toBeAdded.size(); i++) {
      //splice at each level
      SkipNode newNode = new SkipNode(null, v);
      newNode.SetLink('r', toBeAdded.get(i).GetLink('r'));
      toBeAdded.get(i).SetLink('r', newNode);
    }

    //connect the new node vetically from top to bottom
    for (int i = 0; i < toBeAdded.size() - 1; i++ ) {
      toBeAdded.get(i).GetLink('r').SetLink('d', toBeAdded.get(i+1).GetLink('r'));
    }

    listLength++; //update listLength
  }

  /* Coin flip algorithm to determine k */
  private int getNumLevelOccupied() {
    int k = 1;
    while (random(0, 1) <= probPromo) {
      k ++;
    }
    return k;
  }

  public void DeleteByValue(Float v) {  //CAUTION: assuming you don't want to delete some node not in the skip list
    SkipNode p = head;
    while (true) {
      while (p.GetLink('r').ValueOf() < v) {
        p = p.GetLink('r');
      }
      SkipNode temp;
      if (p.GetLink('r').ValueOf() == (float)v) {    //do splice
        temp = p.GetLink('r').GetLink('r');
        p.SetLink('r', temp);
      }
      if (p.GetLink('d') == null) {
        listLength--;
        return;
      }
      p = p.GetLink('d');
    }
  }


  ////-------------------------------------------------------------------- 
  ////>>> SEGMENT-ORIENTED GETTERS AND SETTERS
  ////--------------------------------------------------------------------
  public SkipNode   FindBySegment(Segment s) {
    SkipNode p = head;
    while (p.GetLink('d')!=null) {  //make sure p is at the bottom level
      p = p.GetLink('d');
    }
    while (! (p.SegmentOf().ToString().equals(s.ToString()))) {
      if (p.GetLink('r') == null)
        return null;
      p = p.GetLink('r');
    }
    return p;
  }
  public void       InsertBySegment(Segment s) {
    Float yValue = s.p1.y;
    /*A copy from InsertByValue with modification*/
    int numLevels = getNumLevelOccupied();  //coin flip
    SkipNode p = this.head;
    ArrayList<SkipNode> toBeAdded = new ArrayList<SkipNode>();

    while (listHeight < numLevels) {
      listHeight++;
      SkipNode curLevelHead = new SkipNode(null, negSenVal);
      SkipNode curLevelTail = new SkipNode(null, posSenVal);    
      curLevelHead.SetLink('r', curLevelTail);
      curLevelTail.SetLink('l', curLevelHead);
      curLevelHead.SetLink('d', head);
      this.head = curLevelHead;        //update the head
    }

    p = this.head;
    //modified version of find, use an array to store all the nodes before going down a level
    while (true) {
      while (p.GetLink('r').ValueOf() <= yValue) {
        p = p.GetLink('r');
      }
      if (p.GetLink('d') == null) {
        toBeAdded.add(p);
        break;
      }
      toBeAdded.add(p);
      p = p.GetLink('d');
    }//end of modified verison of find

    int originalSize = toBeAdded.size();
    for (int i = 0; i < originalSize - numLevels; i++) {
      toBeAdded.remove(0);
    }

    //insert newNode at each numLevel horizontally
    for (int i = 0; i < toBeAdded.size(); i++) {
      //splice at each level
      SkipNode newNode = new SkipNode(s, yValue);                            //Segment is inserted here
      newNode.SetLink('r', toBeAdded.get(i).GetLink('r'));
      toBeAdded.get(i).SetLink('r', newNode);
    }

    //connect the new node vetically from top to bottom
    for (int i = 0; i < toBeAdded.size() - 1; i++ ) {
      toBeAdded.get(i).GetLink('r').SetLink('d', toBeAdded.get(i+1).GetLink('r'));
    }

    /* End of A copy from InsertByValue with modification*/
    listLength++; //update listLength
  }
  public void       DeleteBySegment(Segment s) {
    Float yValue = s.p1.y;
    DeleteByValue(yValue);
  }
} // Ends Class SkipList
