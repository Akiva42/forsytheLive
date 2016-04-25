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