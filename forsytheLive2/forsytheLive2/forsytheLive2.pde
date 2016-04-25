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
import muthesius.net.*;
import netP5.*;
import oscP5.*;
//------------------
//kinect stuff
KinectPV2 kinect;
//all the lines
ArrayList<Lineoid> lineoids = new ArrayList<Lineoid>();
//voice stuff
WebSocketP5 socket;
String voiceInput = "";
//osc stuff
OscP5 oscP5;
NetAddress myRemoteLocation;
//------------------
void setup(){
 //size(1920,1080);
 size(600,600);
 //set up kinect components
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.init();
 //set up voice stuff
 socket = new WebSocketP5(this, 8080);
 //set up osc stuff
 oscP5 = new OscP5(this, 12345);
 myRemoteLocation = new NetAddress("127.0.0.1", 12346);
}
//-------------------
void draw(){
  //draw the color image
  image(kinect.getColorImage(), 0, 0, width, height);
}
//---------------
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  for (int i = 0; i < theOscMessage.arguments().length; i++) {
    println(theOscMessage.arguments()[i]);
  }
  println("-----------");
}