import at.mukprojects.console.*;

//  (draw || place)(line || ray)(my || your)(joint name)(to)(my || your)(joint name)
/**head
 right/left hand
 right/left shoulder
 right/left elbow
 neck
 hips
 right/left knee
 right/left foot
 **/

import KinectPV2.*;
import KinectPV2.KJoint;
import muthesius.net.*;
import org.webbitserver.*;
import oscP5.*;
import netP5.*;
//---------------
//kinect stuff
KinectPV2 kinect;
ArrayList<KSkeleton> skeletonArray;
//all the lines
public ArrayList<Lineoid> lineoids = new ArrayList<Lineoid>();
//voice stuff
WebSocketP5 socket;
String voiceInput = "";
//osc stuff
OscP5 oscP5;
NetAddress myRemoteLocation;
//on screen console
Console console;
//---------------
void setup() {
  size(1920, 1080);
  //set up kinect components
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();
  //set up voice stuff
  socket = new WebSocketP5(this, 8080);
  //set up osc stuff
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 13000);
  //on screen console
  console = new Console(this);
  console.start();
}
//--------------
void draw() {
  //draw the color image
  image(kinect.getColorImage(), 0, 0, width, height);
  //create an array of all the skeletons (updated each frame)
  skeletonArray = kinect.getSkeletonColorMap();

  //update all the lineoids
  for (int i = 0; i < lineoids.size(); i++) {
    if (lineoids.get(i).live) {
      lineoids.get(i).updateLineoid(skeletonArray);
    }
    lineoids.get(i).drawLineoid();
  }

  pushStyle();
  //draw the debug info at the top of the screen
  noStroke();
  fill(0);
  rect(0, 0, width, 60);
  textSize(50);
  stroke(255);
  fill(255);
  textAlign(CENTER, TOP);
  text(voiceInput, width/2, 3);
  textAlign(LEFT, TOP);
  text(whosTalking(skeletonArray), 30, 3);
  textAlign(RIGHT, TOP);
  text(skeletonArray.size(), width-30, 3);
  popStyle();

  //draw on screen consol
  //console.draw(0, 0, width/4, 55);
  //console.print();

  //send the osc data out
  //sendOSCJoints();
}
//--------------
//send out osc data for each joint in each skeleton
void sendOSCJoints() {
  //create a message
  OscMessage myMessage = new OscMessage("/data");
  //set up the list of joints
  int numberOfJoins = 26;
  float[] tempJoints = new float[numberOfJoins*skeletonArray.size()];
  int tempJointsCount = 0;
  //put each of the joints in to the list
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);
    KJoint[] joints = skeleton.getJoints();
    for (int j = 0; j < skeleton.getJoints().length; j++) {
      tempJoints[tempJointsCount] = joints[KinectPV2.JointType_SpineBase].getX() - skeleton.getJoints()[j].getX();
      tempJointsCount ++;
      //tempJoints[tempJointsCount] = joints[KinectPV2.JointType_SpineBase].getY() - skeleton.getJoints()[j].getY();
      //tempJointsCount ++;
    }
  }

  //add the list of joints to the message
  myMessage.add(tempJoints);
  //send the message over osc
  oscP5.send(myMessage, myRemoteLocation);
}
//--------------
//pars the words people said and make that data in to a lineoid
void pars(String input) {
  int tempStartBody = 0;
  int tempEndBody = 0;
  //is the line live or does it stay in one place
  boolean tempLive = true;
  //is the line a "ray" or a line segment
  boolean tempRay = false;
  if (whosTalking(skeletonArray) >= 0) {

    //clear all the lines
    if (input.contains("clear all")) {
      lineoids = new ArrayList<Lineoid>();
    }
    if ((input.contains("draw") 
      || input.contains("place")) 
      && (input.contains("line") 
      || input.contains("ray") 
      || input.contains("raise"))) {
      if (countJoinsInText(input) == 2 ) {
        //split the string in the middle
        String[] list = split(input, "to");
        //check that there are two joints in the string
        if (joinInText(list[0]) != -1 && joinInText(list[1]) != -1) {
          println("got 2 valid joints");
          //what body is the first joint on?
          if (list[0].contains("my")) {
            tempStartBody = 0;
            println("part 1 : " + 0);
          }
          if (list[0].contains("your")) {
            tempStartBody = 1;
            println("part 1 : " + 1);
          }
          //what body is the second joint on?
          if (list[1].contains("my")) {
            tempEndBody = 0;
            println("part 2 : " + 0);
          }
          if (list[1].contains("your")) {
            tempEndBody = 1;
            println("part 2 : " + 1);
          }
          //set the booleans about the line
          if (input.contains("draw")) {
            tempLive = true;
          }
          if (input.contains("place")) {
            tempLive = false;
          }
          if (input.contains("line")) {
            tempRay = false;
          }
          if (input.contains("ray") || input.contains("raise")) {
            tempRay = true;
          }

          //make the lineoid
          voiceInput = voiceInput + " !";
          lineoids.add(new Lineoid(joinInText(list[0]), joinInText(list[1]), tempStartBody, tempEndBody, tempRay, tempLive));
          //not sure I need this line?
          lineoids.get(lineoids.size()-1).updateLineoid(skeletonArray);
        }
      }
    }
  }
}
//------------
//retunrs the integer "name" of the joint in a string (only send this strings with one joint name)
int joinInText(String input) {
  if (input.contains("face")) {
    return  KinectPV2.JointType_Head;
  }
  if (input.contains("right hand")) {
    return  KinectPV2.JointType_HandRight;
  }
  if (input.contains("left hand")) {
    return  KinectPV2.JointType_HandLeft;
  }
  if (input.contains("right shoulder")) {
    return  KinectPV2.JointType_ShoulderRight;
  }
  if (input.contains("left shoulder")) {
    return  KinectPV2.JointType_ShoulderLeft;
  }
  if (input.contains("right elbow")) {
    return  KinectPV2.JointType_ElbowRight;
  }
  if (input.contains("left elbow")) {
    return  KinectPV2.JointType_ElbowLeft;
  }
  if (input.contains("neck")) {
    return  KinectPV2.JointType_Neck;
  }
  if (input.contains("hips")) {
    return  KinectPV2.JointType_SpineBase;
  }
  if (input.contains("right knee")) {
    return  KinectPV2.JointType_KneeRight;
  }
  if (input.contains("left knee")) {
    return  KinectPV2.JointType_KneeLeft;
  }
  if (input.contains("right foot")) {
    return  KinectPV2.JointType_FootRight;
  }
  if (input.contains("left foot")) {
    return  KinectPV2.JointType_FootLeft;
  }
  return -1;
}
//------------
//count the number of joins talked about in a string
int countJoinsInText(String input) {
  int temp = 0;
  if (input.contains("face")) {
    temp +=1;
  }
  if (input.contains("right hand")) {
    temp +=1;
  }
  if (input.contains("left hand")) {
    temp +=1;
  }
  if (input.contains("right shoulder")) {
    temp +=1;
  }
  if (input.contains("left shoulder")) {
    temp +=1;
  }
  if (input.contains("right elbow")) {
    temp +=1;
  }
  if (input.contains("left elbow")) {
    temp +=1;
  }
  if (input.contains("neck")) {
    temp +=1;
  }
  if (input.contains("hips")) {
    temp +=1;
  }
  if (input.contains("right knee")) {
    temp +=1;
  }
  if (input.contains("left knee")) {
    temp +=1;
  }
  if (input.contains("right foot")) {
    temp +=1;
  }
  if (input.contains("left foot")) {
    temp +=1;
  }
  return temp;
}
//---------
//figure out what body said the phrase
int whosTalking(ArrayList<KSkeleton> skeletonArray) {
  if (skeletonArray.size()>0) {
    //setup first body
    KSkeleton skeleton0 = (KSkeleton) skeletonArray.get(0);
    KJoint[] joints0 = skeleton0.getJoints();
    //setup second body
    KJoint[] joints1 = joints0;
    if (skeletonArray.size() > 1) {
      KSkeleton skeleton1 = (KSkeleton) skeletonArray.get(1);
      joints1 = skeleton1.getJoints();
    }
    //first body is talking
    if (joints0[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Closed) {
      return 0;
    }
    //second body is talking
    if (skeletonArray.size()>1) {
      if (joints1[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Closed) {
        return 1;
      }
    }
  }
  //no one is talking
  return -1;
}
//-------------
//got a websocket message from the voice recognition program
void websocketOnMessage(WebSocketConnection con, String msg) {
  voiceInput = msg;
  println(voiceInput);
  pars(voiceInput);
}
//-------------
void websocketOnOpen(WebSocketConnection con) {
  println("A client joined");
}
//---------------
void websocketOnClosed(WebSocketConnection con) {
  println("A client left");
}
//------------
//stop the webSocket
void stop() {
  socket.stop();
}