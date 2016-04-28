//got a websocket message from the voice recognition program
void websocketOnMessage(WebSocketConnection con, String msg) {
  //println("raw : " + msg);
  //println("fullVT : " + fullVoiceText);
  //String[] list = split(msg, fullVoiceText);
  //if(list[1].length() > 0){
  //fullVoiceText = msg;
  //voiceInput = list[1];
  //println(voiceInput);
  //pars(voiceInput);
  //}
  voiceInput = msg;
  println(msg);
  pars(voiceInput);
}
//---------------
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