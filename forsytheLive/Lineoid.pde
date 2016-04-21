class Lineoid {
  public PVector start;
  public PVector end;
  public boolean ray;
  public boolean live;
  public int startBody = 0;
  public int startJoint;
  public int endBody = 0;
  public int endJoint;
  float screenDiag = sqrt(width*width + height*height);
  //---------------
  //set up a lineoid
  Lineoid(int startJointIn, int endJointIn, int startBodyIn, int endBodyIn, boolean rayIn, boolean liveIn) {
    startJoint = startJointIn;
    endJoint = endJointIn;
    startBody = startBodyIn;
    endBody = endBodyIn;
    ray = rayIn;
    live = liveIn;
    start = new PVector(0, 0, 0);
    end = new PVector(0, 0, 0);
  }
  //--------------
  void updateLineoid(ArrayList<KSkeleton> skeletonArray) {
    //get start skeleton
    if (skeletonArray.size()>0) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(startBody);
      if (skeleton.isTracked()) {
        //get startBody's joins set
        KJoint[] joints = skeleton.getJoints();
        //set the start point to the current start joint position
        start = new PVector(joints[startJoint].getX(), joints[startJoint].getY(), joints[startJoint].getZ());
      }
      //switch to end skeleton
      skeleton = (KSkeleton) skeletonArray.get(endBody);
      if (skeleton.isTracked()) {
        //get endBody's joins set
        KJoint[] joints = skeleton.getJoints();
        //set the end point to the current end join position
        end = new PVector(joints[endJoint].getX(), joints[endJoint].getY(), joints[endJoint].getZ());
      }
    }
  }
  //---------------------
  //draw the acutal lineoid
  void drawLineoid() {
    //set up style
    stroke(255);
    strokeWeight(20);
    
    if (!ray) {
      //draw line segment
      line(start.x, start.y, start.z, end.x, end.y, end.z);
      point(start.x, start.y, start.z);
      point(end.x, end.y, end.z);
    } else {
      //draw "ray"
      float tempX = (start.x-end.x)*100;
      float tempY = (start.y-end.y)*100;
      float tempZ = (start.z-end.z)*100;
      line(start.x-tempX, start.y-tempY, start.z-tempZ, end.x+tempX, end.y+tempY, end.z+tempZ);
    }
  }
}