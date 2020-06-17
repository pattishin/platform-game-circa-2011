import java.util.*; 
import java.io.*;
import java.net.*;
import processing.net.*;

/*************************************************************************************
 * GameClient class:
 *************************************************************************************/
public class GameClient implements Runnable{
  private DataOutputStream out;
  private DataInputStream in;
  private Socket s;
  private int portNumber;
  private String threadName = "";

  public GameClient(String name, int port){
    this.threadName = name;
    this.portNumber = port;
  }

  public void run() {
    System.out.println( threadName + " starting ");

    try {
      String host = "127.0.0.1";
      System.out.println( "threadName" + ": Connecting to " + host + " ...");
      s = new Socket(host, this.portNumber);
      System.out.println( threadName +": Connection established to " + s.getInetAddress().getHostName());
      out = new DataOutputStream(s.getOutputStream());
      in = new DataInputStream(s.getInputStream());
    } 
    catch (UnknownHostException e) {
      System.err.println(threadName + ": Don't know about host: hostname");
    } 
    catch (IOException e) {
      System.err.println(threadName + ": Couldn't get I/O for the connection to: hostname");
    }

    if (s!= null && out!= null && in!= null) {
      try {
        out.writeBytes("HELO\n");    
        out.writeBytes("MAIL From: k3is@fundy.csd.unbsj.ca\n");
        out.writeBytes("RCPT To: k3is@fundy.csd.unbsj.ca\n");
        out.writeBytes("DATA\n");
        out.writeBytes("From: k3is@fundy.csd.unbsj.ca\n");
        out.writeBytes("Subject: testing\n");
        out.writeBytes("Hi there\n"); // message body
        out.writeBytes("\n.\n");
        out.writeBytes("QUIT");

        String responseLine;
        while ((responseLine = in.readLine()) != null) {
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
        System.err.println(threadName + ":Trying to connect to unknown host: " + e);
      } 
      catch (IOException e) {
        System.err.println(threadName + ":IOException:  " + e);
      }
    }  
  } 
}
