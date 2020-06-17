import java.util.*; 
/*************************************************************************************
 * GameRecorder class:
 *************************************************************************************/
public class GameRecorder {

  /*GameObjectModel field variables*/
  private ArrayList pastMovements;
  private HashMap positions2Replay;
  private GameTimeline gameTimeline;
  private PrintWriter output = null;
  private String []  positionFileLines;

  public GameRecorder(){
    pastMovements = new ArrayList(); 
    positions2Replay = new HashMap();
    gameTimeline = new GameTimeline();
  }

  public void addCurrentPosition(String guid, PVector position){
    pastMovements.add(position);
    positions2Replay.put(guid, position);
    gameTimeline.addPosition2Timeline(guid, position);

    try {
      output = new PrintWriter(new BufferedWriter(new FileWriter("positionOutput.txt", true))); // true means: "append"
      output.println(guid + "=");
      output.println("x:" + position.x);
      output.println("y:" + position.y);
    } 
    catch (IOException e) { System.out.println("IO Exception caught"); }
    finally {  if(output != null){ output.flush(); output.close(); } }

    // getPositionsFromFile();  
  }

  public int numOfPositions(){
    return pastMovements.size(); 
  }

  public HashMap replay(){   
    return ((HashMap) positions2Replay.clone());
  }

  public ArrayList replay2(){     
    return ((ArrayList) pastMovements.clone());
  }

  public ArrayList speedMeUp(){     
    return ((ArrayList) gameTimeline.speedUpByTwo().clone());
  }

  public ArrayList slowMeDown(){     
    return ((ArrayList) gameTimeline.slowDownByHalfSpeed().clone());
  }

  public ArrayList normalSpeed(){     
    return ((ArrayList) gameTimeline.normalSpeed().clone());
  }

  public void getPositionsFromFile(){
    ArrayList pos = new ArrayList();
    HashMap hashPos = new HashMap();
    positionFileLines = loadStrings("positionOutput.txt");
    String guid = ""; float x = 0; float y = 0;
    if(positionFileLines!=null){
      for(int i = 1; i< positionFileLines.length; i++){
        int j = 0;
        while(j < positionFileLines[i].length()){ 
          if(positionFileLines[i].charAt(j)=='='){ guid = positionFileLines[i]; }
          j++;
        }
        j = 0;
        while(j < positionFileLines[i].length()){ 
          if(positionFileLines[i].charAt(j)=='x'){ x = Float.valueOf(positionFileLines[i].substring(j+2, positionFileLines[i].length())); }
          j++;
        }
        j= 0;
        while(j < positionFileLines[i].length()){ 
          if(positionFileLines[i].charAt(j)=='y'){ y = Float.valueOf(positionFileLines[i].substring(j+2, positionFileLines[i].length())); }
          j++;
        }
        hashPos.put(guid, new PVector(x, y));
        pos.add(new PVector(x, y));

      }
      positions2Replay = hashPos;
      pastMovements = pos;
    }
    else { System.out.print("ERROR: File specified was not found.");  }
  }
}
