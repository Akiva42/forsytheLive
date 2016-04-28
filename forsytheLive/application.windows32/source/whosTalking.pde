int personTalking = 0;

//figure out what body said the phrase
int whosTalkingHand(ArrayList<KSkeleton> skeletonArray) {
  if (skeletonArray.size()>0) {
    //there is only one person so they must be talking
    if (skeletonArray.size() == 1) {
      return 0;
    }
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

int whosTalking(ArrayList<KSkeleton> skeletonArray){
  return personTalking;
}