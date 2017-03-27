import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import org.multiply.processing.*; 
import lord_of_galaxy.timing_utils.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class maimai_PatternMaker extends PApplet {

//import processing.sound.*;




Minim minim;
AudioPlayer song;
String songName = "echo";
float songVolGain = -5.0f;
AudioSample tapSound;
String tapSoundName = "tap";
float tapSoundVolGain = 8.0f;

PrintWriter output;
String writerPath;

ArrayList <Tap> taps;
ArrayList <HitPoint> hitPoints;

PShape psTap;
PShape tapOutter;
PShape tapInner;

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

int bgColor = 0xff5C5D5D;
int ringColor = 0xffFBFF39;
int tapColor = 0xffFA5BB3;
int tapPointColor = 0xffFA5BB3;
int hitPointOutterColor = 0xff86FFF8;
int hitPointInnerColor = 0xffF5FF76;

float displayTimeRate = 0.05f;

Stopwatch recordTimer;
boolean recording = false;

public void setup() {
  
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
  psTap = createShape();
  //initAllShape();
  initHitPoints();
}

public void draw() {
  background(bgColor);
  drawMainRing();
  displayAll();

  if (recording) {
    fill(0xff1FFF49);
  } else {
    fill(0xffFC3B4B);
  }
  rect(10, 10, 20, 20);
}

public void initSizeValue() {
  centreX = displayWidth/2;
  centreY = displayHeight/2;

  mainRingOutterR = min(displayWidth /20 *10, displayWidth /20 *10) /2;
  mainRingInnerR = mainRingOutterR - ringThick;

  tapOutterR = min(displayWidth /20 *1.5f, displayWidth /20 *1.5f) /2;
  tapInnerR = tapOutterR - tapThick;
}

// void initAllShape() {
//   tapOutter = createShape(ELLIPSE, 0, 0, tapOutterR*2, tapOutterR*2);
//   tapOutter.setFill(tapColor);
//   tapInner = createShape(ELLIPSE, 0, 0, tapInnerR*2, tapInnerR*2);
//   tapInner.setFill(bgColor);
//   psTap.addChild(tapOutter);
//   psTap.addChild(tapInner);
//   psTap.setFill(tapColor);
// }

public void initHitPoints() {
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
      alpha = 22.5f;
      break;
    case 2:
    case 3:
    case 6:
    case 7:
      alpha = 67.5f;
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

public void drawMainRing() {
  fill(ringColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingOutterR, mainRingOutterR);
  fill(bgColor);
  ellipse(displayWidth/2, displayHeight/2, mainRingInnerR, mainRingInnerR);

  for(byte i = 0; i<= hitPoints.size()-1; i++){
    fill(hitPointOutterColor);
    ellipse(hitPoints.get(i).x, hitPoints.get(i).y, hitPointOutterR, hitPointOutterR);
    fill(hitPointInnerColor);
    ellipse(hitPoints.get(i).x, hitPoints.get(i).y, hitPointInnerR, hitPointInnerR);
  }
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

  public void display() {
    //shape(psTap, x, y);
    if (displayTime > 0) {
      // shape(tapOutter, x, y);
      // shape(tapInner, x, y);
      fill(tapColor);
      ellipse(x, y, tapOutterR, tapOutterR);
      fill(bgColor);
      ellipse(x, y, tapInnerR, tapInnerR);
      fill(tapPointColor);
      ellipse(x, y, tapPointR, tapPointR);
      displayTime -= displayTimeRate;
    }
  }
}


public void displayAll() {
  for (Tap temp : taps) {
    temp.display();
  }
}

public void keyPressed() {
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
    Tap temp = new Tap(hitPoints.get(0).x, hitPoints.get(0).y, tapDefSpeed, PApplet.parseByte(1), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "1");
    tapSound.trigger();
  } else if (key == '\'') {
    Tap temp = new Tap(hitPoints.get(1).x, hitPoints.get(1).y, tapDefSpeed, PApplet.parseByte(2), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "2");
    tapSound.trigger();
  } else if (key == '/') {
    Tap temp = new Tap(hitPoints.get(2).x, hitPoints.get(2).y, tapDefSpeed, PApplet.parseByte(3), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "3");
    tapSound.trigger();
  } else if (key == '.') {
    Tap temp = new Tap(hitPoints.get(3).x, hitPoints.get(3).y, tapDefSpeed, PApplet.parseByte(4), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "4");
    tapSound.trigger();
  } else if (key == ',') {
    Tap temp = new Tap(hitPoints.get(4).x, hitPoints.get(4).y, tapDefSpeed, PApplet.parseByte(5), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "5");
    tapSound.trigger();
  } else if (key == 'm' || key == 'M') {
    Tap temp = new Tap(hitPoints.get(5).x, hitPoints.get(5).y, tapDefSpeed, PApplet.parseByte(6), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "6");
    tapSound.trigger();
  } else if (key == 'k' || key == 'K') {
    Tap temp = new Tap(hitPoints.get(6).x, hitPoints.get(1).y, tapDefSpeed, PApplet.parseByte(7), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "7");
    tapSound.trigger();
  } else if (key == 'l' || key == 'L') {
    Tap temp = new Tap(hitPoints.get(7).x, hitPoints.get(7).y, tapDefSpeed, PApplet.parseByte(8), 0.5f);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "8");
    tapSound.trigger();
  } else if (key == 'x' || key == 'X') {
    exit();
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "maimai_PatternMaker" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
