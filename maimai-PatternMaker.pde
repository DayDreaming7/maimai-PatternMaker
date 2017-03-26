import processing.sound.*;
SoundFile song;
String songName = "echo";

PrintWriter output;

ArrayList <Tap> taps;
ArrayList <HitPoint> hitPoints;

PShape psTap;
PShape tapOutter;
PShape tapInner;

float centreX, centreY;
float tapDefSpeed = 10;

float mainRingOutterR;
float mainRingInnerR;
int ringSize = 50;

float tapOutterR;
float tapInnerR;
int tapSize = 20;

color bgColor = #5C5D5D;
color ringColor = #FBFF39;
color tapColor = #FA5BB3;

float displayTimeRate = 0.05;

boolean recording = false;
long recordingStartTime;

void setup() {
  fullScreen();
  //size(1200,800);
  orientation(LANDSCAPE);
  noStroke();
  ellipseMode(CENTER);
  shapeMode(CENTER);

  taps = new ArrayList();
  hitPoints = new ArrayList();

  song = new SoundFile(this, songName + ".mp3");
  output = createWriter("/output/pattern" + year() + month() + day() + hour() + minute() + second());

  initSizeValue();
  psTap = createShape();
  initAllShape();
  initHitPoints();
}

void draw() {
  background(bgColor);
  drawMainRing();
  displayAll();

  if (recording) {
    fill(#1FFF49);
  } else {
    fill(#FC3B4B);
  }
  rect(10, 10, 20, 20);
}

void initSizeValue() {
  centreX = displayWidth/2;
  centreY = displayHeight/2;

  mainRingOutterR = min(displayWidth /20 *10, displayWidth /20 *10) /2;
  mainRingInnerR = mainRingOutterR - ringSize;

  tapOutterR = min(displayWidth /20 *1.5, displayWidth /20 *1.5) /2;
  tapInnerR = tapOutterR - tapSize;
}

void initAllShape() {
  tapOutter = createShape(ELLIPSE, 0, 0, tapOutterR*2, tapOutterR*2);
  tapOutter.setFill(tapColor);
  tapInner = createShape(ELLIPSE, 0, 0, tapInnerR*2, tapInnerR*2);
  tapInner.setFill(bgColor);
  psTap.addChild(tapOutter);
  psTap.addChild(tapInner);
  psTap.setFill(tapColor);
}

void initHitPoints() {
  for (byte i = 1; i<=8; i++) {
    float x, y;
    float alpha = 0;
    int xDirection = 1;
    int yDirection = 1;
    switch(i) {   
    case 1:
    case 4:
    case 5:
    case 8:
      alpha = 22.5;
      break;
    case 2:
    case 3:
    case 6:
    case 7:
      alpha = 67.5;
      break;
    }
    switch(i) {    
    case 5:
    case 6:
      xDirection = -1;
      break;
    case 1:
    case 2:
      yDirection = -1;
      break;
    case 7:
    case 8:
      xDirection = -1;
      yDirection = -1;
    }
    x = centreX + xDirection * (mainRingOutterR - ringSize /2) * sin(radians(alpha));
    y = centreY + yDirection * (mainRingOutterR - ringSize /2) * cos(radians(alpha));
    HitPoint temp = new HitPoint(x, y);
    hitPoints.add(temp);
  }
}

void drawMainRing() {
  fill(ringColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingOutterR * 2, mainRingOutterR * 2);
  fill(bgColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingInnerR * 2, mainRingInnerR * 2);
}


class HitPoint {
  float x, y;
  HitPoint(float tx, float ty) {
    x = tx;
    y = ty;
  }
}

class Tap {
  float x, y;
  float speed;
  byte pos;
  float displayTime;

  Tap(float tx, float ty, float ts, byte tp, float tdp) {
    x = tx;
    y = ty;
    speed = ts;
    pos = tp;
    displayTime = tdp;
  }

  void display() {
    //shape(psTap, x, y);
    if (displayTime > 0) {
      shape(tapOutter, x, y);
      shape(tapInner, x, y);
      displayTime -= displayTimeRate;
    }
  }
}


void displayAll() {
  for (Tap temp : taps) {
    temp.display();
  }
}

void keyPressed() {
  if (key == ' ') {
    recording = !recording;
    if (recording) {
      recordingStartTime = millis();
      song.play();
    } else {
      song.stop();
      song.cue(0);
      output.flush();
      output.close();
    }
  } else if (key == '9') {
    Tap temp = new Tap(hitPoints.get(0).x, hitPoints.get(0).y, tapDefSpeed, byte(1), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "1");
  } else if (key == '+') {
    Tap temp = new Tap(hitPoints.get(1).x, hitPoints.get(1).y, tapDefSpeed, byte(2), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "2");
  } else if (key == ENTER) {
    Tap temp = new Tap(hitPoints.get(2).x, hitPoints.get(2).y, tapDefSpeed, byte(3), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "3");
  } else if (key == '.') {
    Tap temp = new Tap(hitPoints.get(3).x, hitPoints.get(3).y, tapDefSpeed, byte(4), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "4");
  } else if (key == '0') {
    Tap temp = new Tap(hitPoints.get(4).x, hitPoints.get(4).y, tapDefSpeed, byte(5), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "5");
  } else if (key == '1') {
    Tap temp = new Tap(hitPoints.get(5).x, hitPoints.get(5).y, tapDefSpeed, byte(6), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "6");
  } else if (key == '4') {
    Tap temp = new Tap(hitPoints.get(6).x, hitPoints.get(1).y, tapDefSpeed, byte(7), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "7");
  } else if (key == '8') {
    Tap temp = new Tap(hitPoints.get(7).x, hitPoints.get(7).y, tapDefSpeed, byte(8), 0.5);
    taps.add(temp);
    if (recording)output.println((millis() - recordingStartTime) + "/" + "8");
  } else if (key == 'x' || key == 'X') {
    exit();
  }
}