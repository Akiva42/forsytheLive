void keyPressed() {
  if (key == ' ') {
    //make the lineoid
    lineoids.add(new Lineoid(KinectPV2.JointType_HandRight, KinectPV2.JointType_HandLeft, 0, 0, false, true));
    //not sure I need this line?
    lineoids.get(lineoids.size()-1).updateLineoid(skeletonArray);
  }
}

void mousePressed(){
  //make the lineoid
    lineoids.add(new Lineoid(KinectPV2.JointType_HandRight, KinectPV2.JointType_HandLeft, 0, 0, false, true));
    //not sure I need this line?
    lineoids.get(lineoids.size()-1).updateLineoid(skeletonArray);
}