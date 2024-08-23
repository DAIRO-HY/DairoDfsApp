import 'dart:isolate';

// The entry point for the new isolate.
void isolateEntry(SendPort sendPort) {
 // Create a ReceivePort for receiving messages from the main isolate.
 ReceivePort receivePort = ReceivePort();

 // Send the SendPort of this ReceivePort back to the main isolate.
 sendPort.send(receivePort.sendPort);

 // Listen for messages from the main isolate.
 receivePort.listen((message) {
  if (message is String) {
   print('Isolate received: $message');

   // Send a response back to the main isolate.
   sendPort.send('Hello from isolate');
  }
 });
}

void main() async {
 // Create a ReceivePort to receive messages from the isolate.
 ReceivePort receivePort = ReceivePort();

 // Start a new isolate.
 Isolate.spawn(isolateEntry, receivePort.sendPort);

 // Get the SendPort of the new isolate.
 SendPort? isolateSendPort;
 await for (var message in receivePort) {
  if (message is SendPort) {
   isolateSendPort = message;
   break;
  }
 }

 // Send a message to the new isolate.
 isolateSendPort?.send('Hello from main isolate');

 // Listen for responses from the new isolate.
 await for (var message in receivePort) {
  print('Main isolate received: $message');
  break;
 }
}
