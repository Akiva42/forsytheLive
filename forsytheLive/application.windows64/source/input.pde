void keyPressed() {
  if (key == ' ') {
    if(personTalking == 0){
     personTalking = 1; 
    }else{
     personTalking = 0; 
    }
  }
  if(key == '1'){
   lineoids.add(new Lineoid(KinectPV2.JointType_HandRight, KinectPV2.JointType_HandLeft, 0, 0, false, true)); 
  }
  if(key == '2'){
   lineoids.add(new Lineoid(KinectPV2.JointType_HandRight, KinectPV2.JointType_HandLeft, 0, 1, false, true));
   println("spawing line");
  }
  if(key == '`'){
   lineoids = new ArrayList<Lineoid>(); 
  }
}

void mousePressed(){
   //debug = !debug; 
   lineoids.add(new Lineoid(KinectPV2.JointType_HandRight, KinectPV2.JointType_HandLeft, 0, 1, false, true));
}