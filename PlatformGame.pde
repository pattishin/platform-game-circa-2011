import java.lang.reflect.*;
import java.util.*;

/***********************************************************************************************
 * Basic Game Objects/ Hierarchy 
 * author: Patricia Shin
 * due date: 9/14/11
 ***********************************************************************************************/

/*Base member objects*/
private CharacterSpawnPoint characPoint;
private Obstacle ground;
private DeathZone deathZoneLine;
private BoundingBox boundBox;
private EventManager manager;
private int count = 0;

private boolean configFileLoaded = false;
public int windowWidth; //environment width
public int windowHeight; //environment height
public int strokeColor; //color of stroke
public int gameFrameRate; //set framerate

private String [] configFileLines;
private String characID = "C_";
private String platID = "Pl_";
private String pareID = "PlPa_";
private String groundID = "G_";

private String collisionEvent = "Event: Collision";

private int DEFAULT_SIZE = 10;
private int platformCount = 0;
private int platformParentCount = 0;
private int wallCount = 0;
private int characCount = 0;

/*Base member variables*/
private boolean jumpRight = false;
private boolean jumpLeft = false;

private PlatformParent [] listOfParents;
private Character mainCharacter;
private ArrayList listOfPlatforms;

private List <GameObjectModel> gameObjectList;

//Networking variables  
public Thread runner;
public Thread server;
public Thread client;
public GameClient gameClient;
public GameServer gameServer;
private Thread dummyClient;
private Thread platformServer;
public PApplet engine;


/***************************************
 * PLATFORM SCENE Set-up
 * configuration file integrated
 **************************************/
void setup() {
  engine  = new PlatformGameEngine();

  gameObjectList  = new ArrayList<GameObjectModel>();
  gameServer      = new GameServer();
  // gameClient      = new GameClient();
  listOfParents   = new PlatformParent[DEFAULT_SIZE];
  listOfPlatforms = new ArrayList();



  //Parses text lines from filename into an array and initializes all required components for platform game
  configFileLines = loadStrings("configFile.txt");
  if(configFileLines!=null){
    for (int i=0; i < configFileLines.length; i++) {
      //if section describes ENVIRONMENT variables
      if(configFileLines[i].equals("Environment")){
        int j = 0;
        while(j < configFileLines[i+1].length()){ //sets environment width
          if(configFileLines[i+1].charAt(j)==':'){ windowWidth = Integer.parseInt(configFileLines[i+1].substring(j+2, configFileLines[i+1].length())); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+2].length()){ //sets environment height
          if(configFileLines[i+2].charAt(j)==':'){ windowHeight = Integer.parseInt(configFileLines[i+2].substring(j+2, configFileLines[i+2].length())); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+3].length()){ //sets frame rate
          if(configFileLines[i+3].charAt(j)==':'){ gameFrameRate = Integer.parseInt(configFileLines[i+3].substring(j+2, configFileLines[i+3].length())); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+4].length()){ //sets stroke color
          if(configFileLines[i+4].charAt(j)==':'){ strokeColor = Integer.parseInt(configFileLines[i+4].substring(j+2, configFileLines[i+4].length())); }
          j++;
        }
      }

      //if section decribes a GAME OBJECT MODEL
      if(configFileLines[i].contains("create GameObject")){
        for(int k = 0; k < configFileLines[i].length(); k++){ 
          String classType = null;
          if(configFileLines[i].charAt(k) ==':'){ 
            classType = configFileLines[i].substring(k+2, configFileLines[i].length());   
            //Utilizing java.lang.reflect.*
            Class newClass = null;
            try {
              newClass = Class.forName("PlatformGame$"+classType);
              Constructor ctorlist[] = newClass.getDeclaredConstructors();
              for (int j = 0; j < ctorlist.length; j++) {
                Constructor ct = ctorlist[j];
                Class pvec[] = ct.getParameterTypes();       

                //for (int inc = 0; inc < pvec.length; inc++)  System.out.println("param #"  + inc + " " + pvec[inc]);

                //arguement list to give to constructor when a new class is created
                Object [] arglist = null;

                //Execute if the class type requested is Character
                if(classType.equals("Character")){
                  int inc = 0;
                  arglist= new Object[pvec.length];
                  arglist[0] = this;
                  while(inc < configFileLines[i+1].length()){ 
                    if(configFileLines[i+1].charAt(inc)==':'){ arglist[1] = configFileLines[i+1].substring(inc+2, configFileLines[i+1].length()); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+2].length()){ 
                    if(configFileLines[i+2].charAt(inc)==':'){ arglist[2] = Integer.parseInt(configFileLines[i+2].substring(inc+2, configFileLines[i+2].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+3].length()){ 
                    if(configFileLines[i+3].charAt(inc)==':'){ arglist[3] = Integer.parseInt(configFileLines[i+3].substring(inc+2, configFileLines[i+3].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+4].length()){
                    if(configFileLines[i+4].charAt(inc)==':'){ arglist[4] = Integer.parseInt(configFileLines[i+4].substring(inc+2, configFileLines[i+4].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+5].length()){
                    if(configFileLines[i+5].charAt(inc)==':'){ arglist[5] = Integer.parseInt(configFileLines[i+5].substring(inc+2, configFileLines[i+5].length())); }
                    inc++;
                  }
                  mainCharacter = (Character) ct.newInstance(arglist); //returns class Object, so cast needed
                  mainCharacter.setMyGUID(characID+characCount);       //sets GUID
                  mainCharacter.myEventName = collisionEvent;          //sets collision event
                  gameObjectList.add(mainCharacter);

                }
                if(classType.equals("BoundingBox")){
                  int inc = 0;
                  arglist= new Object[pvec.length];
                  arglist[0] = this;
                  while(inc < configFileLines[i+1].length()){ 
                    if(configFileLines[i+1].charAt(inc)==':'){ arglist[1] = Integer.parseInt(configFileLines[i+1].substring(inc+2, configFileLines[i+1].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+2].length()){ 
                    if(configFileLines[i+2].charAt(inc)==':'){ arglist[2] = Integer.parseInt(configFileLines[i+2].substring(inc+2, configFileLines[i+2].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+3].length()){ 
                    if(configFileLines[i+3].charAt(inc)==':'){ arglist[3] = Integer.parseInt(configFileLines[i+3].substring(inc+2, configFileLines[i+3].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+4].length()){
                    if(configFileLines[i+4].charAt(inc)==':'){ arglist[4] = Integer.parseInt(configFileLines[i+4].substring(inc+2, configFileLines[i+4].length())); }
                    inc++;
                  }
                  boundBox = (BoundingBox) ct.newInstance(arglist);
                  boundBox.setMyGUID("BB_0");
                  boundBox.myEventName = collisionEvent;
                  gameObjectList.add(boundBox);
                }
                if(classType.equals("CharacterSpawnPoint")){
                  int inc = 0;
                  arglist= new Object[pvec.length];
                  arglist[0] = this;
                  while(inc < configFileLines[i+1].length()){ 
                    if(configFileLines[i+1].charAt(inc)==':'){ arglist[1]= Integer.parseInt(configFileLines[i+1].substring(inc+2, configFileLines[i+1].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+2].length()){ 
                    if(configFileLines[i+2].charAt(inc)==':'){ arglist[2] = Integer.parseInt(configFileLines[i+2].substring(inc+2, configFileLines[i+2].length())); }
                    inc++;
                  }
                  characPoint = (CharacterSpawnPoint) ct.newInstance(arglist);
                  characPoint.setMyGUID("CPoint_0");
                  characPoint.myEventName = collisionEvent;
                  gameObjectList.add(characPoint);
                }
                if(classType.equals("DeathZone")){
                  int inc = 0;
                  arglist= new Object[pvec.length];
                  arglist[0] = this;
                  while(inc < configFileLines[i+1].length()){ 
                    if(configFileLines[i+1].charAt(inc)==':'){ arglist[1] = Integer.parseInt(configFileLines[i+1].substring(inc+2, configFileLines[i+1].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+2].length()){ 
                    if(configFileLines[i+2].charAt(inc)==':'){ arglist[2] = Integer.parseInt(configFileLines[i+2].substring(inc+2, configFileLines[i+2].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+3].length()){ 
                    if(configFileLines[i+3].charAt(inc)==':'){ arglist[3] = Integer.parseInt(configFileLines[i+3].substring(inc+2, configFileLines[i+3].length())); }
                    inc++;
                  }
                  inc = 0;
                  while(inc < configFileLines[i+4].length()){
                    if(configFileLines[i+4].charAt(inc)==':'){ arglist[4] = Integer.parseInt(configFileLines[i+4].substring(inc+2, configFileLines[i+4].length())); }
                    inc++;
                  }
                  deathZoneLine = (DeathZone) ct.newInstance(arglist);
                  deathZoneLine.setMyGUID("Death_0");
                  deathZoneLine.myEventName = collisionEvent;
                  gameObjectList.add(deathZoneLine); 
                }
                if(classType.equals("Obstacle")){
                  int inc = 0;
                  arglist= new Object[pvec.length];
                  arglist[0] = this;
                }
                if(classType.equals("PlatformParent")){
                  int inc = 0;
                  arglist= new Object[pvec.length];
                  arglist[0] = this;
                }
              }          
            } 
            catch (Throwable e) { System.out.println("Class " + classType + " doesn't exist."); }
          }
        }
      }

      //if section decribes a platformparent
      if(configFileLines[i].equals("create GameObject: PlatformParent")){
        int parentNum = -1; int j = 0;
        while(j < configFileLines[i+1].length()){ 
          if(configFileLines[i+1].charAt(j)==':'){ parentNum = Integer.parseInt(configFileLines[i+1].substring(j+2, configFileLines[i+1].length())); }
          j++;
        }
        if(!(listOfParents.length > platformParentCount)){
          PlatformParent[] holder = new PlatformParent[listOfParents.length+DEFAULT_SIZE];
          for(int icount = 0; icount< listOfParents.length; icount++){
            holder[icount] = listOfParents[icount]; 
          }
          listOfParents = holder;
        }
        listOfParents[platformParentCount] = new PlatformParent(parentNum);
        listOfParents[platformParentCount].setMyGUID(pareID+platformParentCount);
        listOfParents[platformParentCount].myEventName = collisionEvent;
        gameObjectList.add(listOfParents[platformParentCount]);
        platformParentCount++;
      }

      //if section decribes a platform
      if(configFileLines[i].equals("create GameObject: Obstacle")){
        String name = ""; int setParent = -1; int locationX = 0; int locationY = 0; int oHeight = 0; int oWidth = 0;  int j = 0;
        while(j < configFileLines[i+1].length()){ 
          if(configFileLines[i+1].charAt(j)==':'){ name = configFileLines[i+1].substring(j+2, configFileLines[i+1].length()); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+2].length()){ 
          if(configFileLines[i+2].charAt(j)==':'){ setParent = Integer.parseInt(configFileLines[i+2].substring(j+2, configFileLines[i+2].length())); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+3].length()){ 
          if(configFileLines[i+3].charAt(j)==':'){ locationX = Integer.parseInt(configFileLines[i+3].substring(j+2, configFileLines[i+3].length())); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+4].length()){ 
          if(configFileLines[i+4].charAt(j)==':'){ locationY = Integer.parseInt(configFileLines[i+4].substring(j+2, configFileLines[i+4].length())); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+5].length()){ 
          if(configFileLines[i+5].charAt(j)==':'){ oHeight = Integer.parseInt(configFileLines[i+5].substring(j+2, configFileLines[i+5].length())); }
          j++;
        }
        j = 0;
        while(j < configFileLines[i+6].length()){ 
          if(configFileLines[i+6].charAt(j)==':'){ oWidth = Integer.parseInt(configFileLines[i+6].substring(j+2, configFileLines[i+6].length())); }
          j++;
        }
        if(name.equals("platform")){
          Obstacle newPlatformToAdd = new Obstacle(platformCount, locationX, locationY, oHeight, oWidth, setParent);
          newPlatformToAdd.setMyGUID(platID+platformCount);
          newPlatformToAdd.myEventName = collisionEvent;
          listOfPlatforms.add(newPlatformToAdd);

          addPlatformChildToParent(newPlatformToAdd, setParent);
          gameObjectList.add(newPlatformToAdd);

          platformCount++;
        }

        if(name.equals("ground")){
          ground = new Obstacle(0, ((float)locationX), ((float)locationY), oHeight, oWidth, setParent);
          ground.setMyGUID(groundID+"0");
          ground.myEventName = collisionEvent;
          gameObjectList.add(ground);
        }
      }

      for(int icount = 0; icount< listOfParents.length; icount++){
        if(listOfParents[icount]!=null && mainCharacter!=null){
          mainCharacter.addAPlatformParentToMyWorld(listOfParents[icount]);
        }
      }

      if(boundBox!=null && ground!=null && deathZoneLine!=null && characPoint!=null && mainCharacter!=null){
        mainCharacter.setBoundingBox(boundBox);
        mainCharacter.setGroundPlatform(ground);
        mainCharacter.setDeathZone(deathZoneLine);
        mainCharacter.setSpawnPoint(characPoint);
      }       
    }
    //instantiates server/client variables

    manager = new EventManager();
    GameObjectModel [] newList = new GameObjectModel[gameObjectList.toArray().length];
    for(int i = 0; i< gameObjectList.toArray().length; i++){
      newList[i] = (GameObjectModel) gameObjectList.toArray()[i];
    }
    manager.setGameObjectList(newList);  
    server = new Thread(gameServer);
    client = new Thread(gameClient);
    runner = new Thread(manager);
    server.start();
    runner.start(); 
    manager.clientServerTalkOn = true;


    //For Peer to Peer usage
    GameClient dumdum = new GameClient("PEER-TO-PEER GAME CLIENT THREAD", 5225); //sending port number 5555
    dummyClient = new Thread(dumdum, "PEER-TO-PEER GAME CLIENT THREAD");
    dummyClient.start();
    //For Peer to Peer usage
    /* GameServer gserve = new GameServer("PEER-TO-PEER GAME CLIENT THREAD", 5005); //sending port number 5555
       platformServer = new Thread(gserve, "PEER-TO-PEER GAME CLIENT THREAD");
       platformServer.start(); */     


  } 
  else { System.out.print("ERROR: File specified was not found."); }

  //utilizes config text declared variables

  size(windowWidth, windowHeight);
  stroke(strokeColor);
  smooth();
  frameRate(gameFrameRate);

}

void addPlatformChildToParent(Obstacle child, int parent){
  for(int icount=0; icount< platformParentCount; icount++){
    if(listOfParents[icount]!=null){
      if(listOfParents[icount].platformParentNum==parent){
        listOfParents[icount].addNewChildPlatform(child);
      }
    }
  } 
}


/***************************************
 * Draw method for PLATFORM SCENE
 **************************************/
void draw() {
  background(0, 0, 0);
  boundBox.display();
  characPoint.display();
  ground.display();
  mainCharacter.display();
  deathZoneLine.display();

  GameObjectModel [] newList = new GameObjectModel[gameObjectList.toArray().length];
  for(int i = 0; i< gameObjectList.toArray().length; i++){
    newList[i] = (GameObjectModel) gameObjectList.toArray()[i];
  }
  manager.setGameObjectList(newList); 

  for(int i = 0; i< platformParentCount; i++){
    if(listOfParents[i]!=null){
      listOfParents[i].setColorForMyPlatforms(color(0, 0, 255));
      listOfParents[i].masterDisplay();
    }
  }
  boolean eventOccurred = manager.checkForEventOccurance();
}

