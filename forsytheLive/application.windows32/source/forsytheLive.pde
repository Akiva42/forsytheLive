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
import at.mukprojects.console.*;
//---------------
//kinect stuff
KinectPV2 kinect;
ArrayList<KSkeleton> skeletonArray;
//all the lines
public ArrayList<Lineoid> lineoids = new ArrayList<Lineoid>();
//voice stuff
WebSocketP5 socket;
String voiceInput = "";
String fullVoiceText = "";
//on screen console
Console console;
boolean debug = true;
//---------------
void setup() {
  fullScreen();
  //size(1920, 1080);
  //size(600,600);
  //set up kinect components
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();
  //set up voice stuff
  socket = new WebSocketP5(this, 8080);
  //on screen console
  console = new Console(this);
  //console.start();
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

  //draw the debug info at the top of the screen
  if (debug) {
    pushStyle();
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
  }

  //draw on screen consol
  //console.draw(0, 0, width/4, 55);
  //console.print();
}