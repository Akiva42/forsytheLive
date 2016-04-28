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