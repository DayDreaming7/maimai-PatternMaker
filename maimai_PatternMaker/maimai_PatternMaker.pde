//import processing.sound.*;
import ddf.minim.*;
import org.multiply.processing.*;
import lord_of_galaxy.timing_utils.*;

Minim minim;
AudioPlayer song;
String songName = "echo";
float songVolGain = -5.0;
AudioSample tapSound;
String tapSoundName = "tap";
float tapSoundVolGain = 8.0;

PrintWriter output;
String writerPath;

ArrayList <Tap> taps;
ArrayList <HitPoint> hitPoints;

PShape psTap;
PShape tapOutter;
PShape tapInner;
PShape tapPoint;

float centreX, centreY;
float tapDefSpeed = 10;

float mainRingOutterR;
float mainRingInnerR;
int ringThick = 50;

float tapOutterR;
float tapInnerR;
float tapPointR = 3;
int tapThick = 20;

float hitPointOutterR = 40;
float hitPointInnerR = 5;

color bgColor = #5C5D5D;
color ringColor = #FBFF39;
color tapColor = #FA5BB3;
color tapPointColor = #FA5BB3;
color hitPointOutterColor = #86FFF8;
color hitPointInnerColor = #F5FF76;

float displayTimeRate = 0.05;

Stopwatch recordTimer;
boolean recording = false;

void setup() {
  fullScreen();
  //size(1200,800);
  orientation(LANDSCAPE);
  noStroke();
  ellipseMode(RADIUS);

  shapeMode(CENTER);

  taps = new ArrayList();
  hitPoints = new ArrayList();

  minim = new Minim(this);
  song = minim.loadFile(songName + ".mp3");
  tapSound = minim.loadSample(tapSoundName + ".mp3", 512);
  song.setGain(songVolGain);
  tapSound.setGain(tapSoundVolGain);

  recordTimer = new Stopwatch(this);

  writerPath = "output/pattern" + year() + month() + day() + hour() + minute() + second() + ".txt";
  output = createWriter(writerPath);

  initSizeValue();
  psTap = createShape(GROUP);
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
  mainRingInnerR = mainRingOutterR - ringThick;

  tapOutterR = min(displayWidth /20 *1.5, displayWidth /20 *1.5) /2;
  tapInnerR = tapOutterR - tapThick;
}

void initAllShape() {
  tapOutter = createShape(ELLIPSE, 0, 0, tapOutterR, tapOutterR);
  tapOutter.setFill(tapColor);
  tapInner = createShape(ELLIPSE, 0, 0, tapInnerR, tapInnerR);
  tapInner.setFill(bgColor);
  tapPoint = createShape(ELLIPSE, 0, 0, tapPointR, tapPointR);
  tapPoint.setFill(tapPointColor);

  psTap.addChild(tapOutter);
  psTap.addChild(tapInner);
  psTap.addChild(tapPoint);
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
    x = centreX + xDirection * (mainRingOutterR - ringThick /2) * sin(radians(alpha));
    y = centreY + yDirection * (mainRingOutterR - ringThick /2) * cos(radians(alpha));
    HitPoint temp = new HitPoint(x, y);
    hitPoints.add(temp);
  }
}

void drawMainRing() {
  fill(ringColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingOutterR, mainRingOutterR);
  fill(bgColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingInnerR, mainRingInnerR);

  // for(byte i = 0; i<= hitPoints.size()-1; i++){
  //   HitPoint.display(i);
  // }
  for(HitPoint temp:hitPoints){
    temp.display();
  }
}


class HitPoint {
  float x, y;
  HitPoint(float tx, float ty) {
    x = tx;
    y = ty;
  }

  void display(){
    fill(hitPointOutterColor);
    //ellipse(hitPoints.get(i).x, hitPoints.get(i).y, hitPointOutterR, hitPointOutterR);
    ellipse(x, y, hitPointOutterR, hitPointOutterR);
    fill(hitPointInnerColor);
    //ellipse(hitPoints.get(i).x, hitPoints.get(i).y, hitPointInnerR, hitPointInnerR);
    ellipse(x, y, hitPointInnerR, hitPointInnerR);
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
      shape(psTap, x, y);

      //setFill(tapColor);
      //shape(tapOutter, x, y);
      //setFill(bgColor);
      //shape(tapInner, x, y);
      //etFill(tapPointColor);
      //shape(tapP)

      // fill(tapColor);
      // ellipse(x, y, tapOutterR, tapOutterR);
      // fill(bgColor);
      // ellipse(x, y, tapInnerR, tapInnerR);
      // fill(tapPointColor);
      // ellipse(x, y, tapPointR, tapPointR);
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
      song.rewind();
      recordTimer.start();
      song.play();
    } else {
      song.pause();
      output.flush();
      output.close();
    }
  } else if (key == ';') {
    Tap temp = new Tap(hitPoints.get(0).x, hitPoints.get(0).y, tapDefSpeed, byte(1), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "1");
    tapSound.trigger();
  } else if (key == '\'') {
    Tap temp = new Tap(hitPoints.get(1).x, hitPoints.get(1).y, tapDefSpeed, byte(2), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "2");
    tapSound.trigger();
  } else if (key == '/') {
    Tap temp = new Tap(hitPoints.get(2).x, hitPoints.get(2).y, tapDefSpeed, byte(3), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "3");
    tapSound.trigger();
  } else if (key == '.') {
    Tap temp = new Tap(hitPoints.get(3).x, hitPoints.get(3).y, tapDefSpeed, byte(4), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "4");
    tapSound.trigger();
  } else if (key == ',') {
    Tap temp = new Tap(hitPoints.get(4).x, hitPoints.get(4).y, tapDefSpeed, byte(5), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "5");
    tapSound.trigger();
  } else if (key == 'm' || key == 'M') {
    Tap temp = new Tap(hitPoints.get(5).x, hitPoints.get(5).y, tapDefSpeed, byte(6), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "6");
    tapSound.trigger();
  } else if (key == 'k' || key == 'K') {
    Tap temp = new Tap(hitPoints.get(6).x, hitPoints.get(1).y, tapDefSpeed, byte(7), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "7");
    tapSound.trigger();
  } else if (key == 'l' || key == 'L') {
    Tap temp = new Tap(hitPoints.get(7).x, hitPoints.get(7).y, tapDefSpeed, byte(8), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "8");
    tapSound.trigger();
  } else if (key == 'x' || key == 'X') {
    exit();
  }
}