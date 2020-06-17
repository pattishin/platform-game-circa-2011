import java.lang.*;
import java.util.*;

/*************************************************************************************
 * EventManager class:
 * Handles events of arbirtrary types
 * Keeps track of which engine systems/game objects are registered
 * to recieve events and dispatches those events
 *************************************************************************************/
public class EventManager implements Runnable{

  /*EventManager field variables*/
  boolean replayKeyPressed = false;

  private GameObjectModel [] gameObjects;
  private GameLogger gameLogger;
  private GameLogger remoteLogger;
  private GameRecorder recorder;
  private String characID = "C_0";
  private String platID = "Pl_";
  private String pareID = "PlPa_";
  private String groundID = "G_";
  private ArrayList replaySession;
  private ArrayList replaySlowSession;
  private ArrayList replayFastSession;
  private ArrayList replayNormSession;
  private int totalPositionsToReplay;

  boolean replayRequested = false;
  boolean speedUpRequested = false;
  boolean slowDownRequested = false;
  boolean normalSpeedRequested = false;

  private boolean remoteLoggingRequested = false;
  private String  remoteLoggerEventNotifStatement = "";

  //Client
  private DataOutputStream out;
  private DataInputStream in;
  private Socket s;
  public boolean clientServerTalkOn = false;

  public EventManager(){
    gameLogger = new GameLogger();
    remoteLogger = new GameLogger();
    recorder = new GameRecorder();
  }

  private void setGameObjectList(GameObjectModel [] objects){
    gameObjects = objects; 
  }

  private boolean checkForEventOccurance(){
    for(int i = 0; i< gameObjects.length; i++){
      if(gameObjects[i]!=null){
        if(gameObjects[i].eventOccurance()){
          informAllObjectsOfEvent(gameObjects[i].myEventName, gameObjects[i].getMyGUID());
          logEventMessage(gameObjects[i].myEventName, gameObjects[i].getMyGUID());
          gameObjects[i].reset();
          return true;
        }
      }
    }
    return false;
  }

  private void informAllObjectsOfEvent(String event, String guid){
    for(int i = 0; i< gameObjects.length; i++){
      if(gameObjects[i]!=null) gameObjects[i].eventListener(event);
    }
  }

  private void logEventMessage(String event, String guid){
    gameLogger.printToFile(guid + " " + event);
    remoteLoggerEventNotifStatement = guid + " -- " + event;
    remoteLoggingRequested = true;
    System.out.println(remoteLoggerEventNotifStatement);
  }

  public void run(){       
    //Client side of the event manager
    System.out.println( "Event Client starting ");
    try {
      String host = "127.0.0.1";
      System.out.println( "Connecting to " + host + " ...");
      s = new Socket(host, 5225);
      System.out.println( "Connection established to " + s.getInetAddress().getHostName());
      out = new DataOutputStream(s.getOutputStream());
      in = new DataInputStream(s.getInputStream());
    } 
    catch (UnknownHostException e) {
      System.err.println("Don't know about host: hostname");
    } 
    catch (IOException e) {
      System.err.println("Couldn't get I/O for the connection to: hostname");
    }

    if(s!= null && out!= null && in!= null){
      try {
        out.writeBytes("Hello my server!\n");  
        String responseLine;
        while ((responseLine = in.readLine()) != null) {
          //prints out remote logger statements of a collision happening 
          out.writeBytes(remoteLoggerEventNotifStatement+"\n");


          System.out.println("Server: " + responseLine);
          if (responseLine.indexOf("Ok") != -1) {
            break;
          }



        }
        out.close();
        in.close();
        s.close();   
      } 
      catch (UnknownHostException e) {
        System.err.println("Trying to connect to unknown host: " + e);
      } 
      catch (IOException e) {
        System.err.println("IOException:  " + e);
      }
    }  

    /*********************************************************
     * Utilizing game recorder to track character's movements
     *********************************************************/
    Character mainCharacter = (Character)findCharacter();
    if(keyPressed){
      if(key=='r') replayRequested = true;
      if(key=='1') normalSpeedRequested = true;
      if(key=='2') speedUpRequested = true;
      if(key=='s') slowDownRequested = true;
    }

    if(!replayRequested&&!speedUpRequested&&!slowDownRequested&&!normalSpeedRequested&&!keyPressed){
      if(mainCharacter!=null){
        recorder.addCurrentPosition(mainCharacter.getMyGUID(), new PVector(mainCharacter.myLoc.x, mainCharacter.myLoc.y)); 
        totalPositionsToReplay = recorder.numOfPositions();
        replaySession = recorder.replay2();
        replaySlowSession = recorder.slowMeDown();
        replayFastSession = recorder.speedMeUp();
        replayNormSession = recorder.normalSpeed();
      }
    }

    //Replay Requested
    if(replayRequested){
      if(!replaySession.isEmpty()){
        System.out.println("---------------------------------");
        System.out.println("timestamp: " + hour() + " hours " + minute() + " minutes " + second() + " sec " + millis() + " millisec");
        Object [] positions = replaySession.toArray();
        PVector loc = (PVector)positions[0];

        if(mainCharacter!=null){
          mainCharacter.myLoc = loc;
          System.out.println("mainCharacter.myLoc -->" + mainCharacter.myLoc);
        }
        replaySession.remove(0);
      }
      else{
        System.out.println("STOP @ timestamp: " + hour() + " hours " + minute() + " minutes " + second() + " sec " + millis() + " millisec");
        replayRequested = false;
        replaySession = recorder.replay2();
      }
    }

    //Slow Down Requested
    if(slowDownRequested){
      if(!replaySlowSession.isEmpty()){
        System.out.println("--------SLOW-DOWN----------");
        System.out.println("timestamp: " + hour() + " hours " + minute() + " minutes " + second() + " sec " + millis() + " millisec");
        Object [] positions = replaySlowSession.toArray();
        PVector loc = (PVector)positions[0];

        if(mainCharacter!=null){ mainCharacter.myLoc = loc; }
        replaySlowSession.remove(0);
      }
      else{
        System.out.println("STOP @ timestamp: " + hour() + " hours " + minute() + " minutes " + second() + " sec " + millis() + " millisec");
        slowDownRequested = false;
        replaySlowSession = recorder.slowMeDown();
      }
    }

    //Speed Up Requested
    if(speedUpRequested){
      if(!replayFastSession.isEmpty()){
        System.out.println("--------SPEED-UP----------");
        System.out.println("timestamp: " + hour() + " hours " + minute() + " minutes " + second() + " sec " + millis() + " millisec");
        Object [] positions = replayFastSession.toArray();
        PVector loc = (PVector)positions[0];

        if(mainCharacter!=null){ mainCharacter.myLoc = loc; }
        replayFastSession.remove(0);
      }
      else{
        System.out.println("STOP @ timestamp: " + hour() + " hours " + minute() + " minutes " + second() + " sec " + millis() + " millisec");
        speedUpRequested = false;
        replayFastSession = recorder.speedMeUp();
      }
    }

    //Normal Speed Requested
    if(normalSpeedRequested){
      if(!replayNormSession.isEmpty()){
        
        Object [] positions = replayNormSession.toArray();
        PVector loc = (PVector)positions[0];

        if(mainCharacter!=null){ mainCharacter.myLoc = loc; }
        replayNormSession.remove(0);
      }
      else{
        System.out.println("STOP @ timestamp: " + hour() + " hours " + minute() + " minutes " + second() + " sec " + millis() + " millisec");
        normalSpeedRequested = false;
        replayNormSession = recorder.normalSpeed();
      }
    }
  }

  private GameObjectModel findCharacter(){
    for(int i = 0; i< gameObjects.length; i++){
      if(gameObjects[i]!=null){
        if(gameObjects[i].getMyGUID().equals(characID)) return gameObjects[i];
      }
    }
    return null;
  }

  public void printOutGameObjects(){
    for(int i = 0; i< gameObjects.length; i++){
      if(gameObjects[i]!=null){
        System.out.println("gameObjects.getMyGUID = " +  gameObjects[i].getMyGUID());
      }
    }
  }

}
