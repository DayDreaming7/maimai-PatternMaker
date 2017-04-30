//import processing.sound.*;
import ddf.minim.*;
import org.multiply.processing.*;
import lord_of_galaxy.timing_utils.*;

//Sounds
Minim minim;
AudioPlayer song;
String songName = "echo";
float songVolGain = -5.0;
AudioSample tapSound;
String tapSoundName = "tap";
float tapSoundVolGain = 8.0;

//Output file
PrintWriter output;
String writerPath;

//ArrayLists
ArrayList <Tap> taps;
ArrayList <HitPoint> hitPoints;

//Shapes
PShape psTap;
PShape tapOutter;
PShape tapInner;
PShape tapPoint;

//Sizes of mainRing
float centreX, centreY;
float tapDefSpeed = 10;

float mainRingOutterR;
float mainRingInnerR;
int ringThick = 50;

//Sizes of tabs
float tapOutterR;
float tapInnerR;
float tapPointR = 3;
int tapThick = 20;

float hitPointOutterR = 30;
float hitPointInnerR = 5;

//Colors
color bgColor = #5C5D5D;
color ringColor = #FBFF39;
color tapColor = #FA5BB3;
color tapPointColor = #FA5BB3;
color hitPointOutterColor = #86FFF8;
color hitPointInnerColor = #F5FF76;

//Tab displayTime
float displayTimeRate = 0.05;

//Recording
Stopwatch recordTimer;
boolean recording = false;
//----------------------------------------------------------------------------
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

  writerPath = "output/pattern" + year() + nf(month(), 2) + nf(day(), 2) + "-" + nf(hour(), 2) + nf(minute(),2) + nf(second(),2) + ".txt";
  output = createWriter(writerPath);

  initializeAll(); //Size, Shapes, HitPoints of mainRing
}

void draw() {
  background(bgColor);
  update();

  if (recording) {
    fill(#1FFF49);
  } else {
    fill(#FC3B4B);
  }
  rect(10, 10, 20, 20);
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
  } else if (key == '9') {
    Tap temp = new Tap(hitPoints.get(0).x, hitPoints.get(0).y, tapDefSpeed, byte(1), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "1");
    tapSound.trigger();
  } else if (key == 'o'|| key == 'O') {
    Tap temp = new Tap(hitPoints.get(1).x, hitPoints.get(1).y, tapDefSpeed, byte(2), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "2");
    tapSound.trigger();
  } else if (key == 'l'|| key == 'L') {
    Tap temp = new Tap(hitPoints.get(2).x, hitPoints.get(2).y, tapDefSpeed, byte(3), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "3");
    tapSound.trigger();
  } else if (key == ',') {
    Tap temp = new Tap(hitPoints.get(3).x, hitPoints.get(3).y, tapDefSpeed, byte(4), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "4");
    tapSound.trigger();
  } else if (key == 'm'|| key == 'M') {
    Tap temp = new Tap(hitPoints.get(4).x, hitPoints.get(4).y, tapDefSpeed, byte(5), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "5");
    tapSound.trigger();
  } else if (key == 'j' || key == 'J') {
    Tap temp = new Tap(hitPoints.get(5).x, hitPoints.get(5).y, tapDefSpeed, byte(6), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "6");
    tapSound.trigger();
  } else if (key == 'u' || key == 'U') {
    Tap temp = new Tap(hitPoints.get(6).x, hitPoints.get(1).y, tapDefSpeed, byte(7), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "7");
    tapSound.trigger();
  } else if (key == '8') {
    Tap temp = new Tap(hitPoints.get(7).x, hitPoints.get(7).y, tapDefSpeed, byte(8), 0.5);
    taps.add(temp);
    if (recording)output.println(recordTimer.time() + "/" + "8");
    tapSound.trigger();
  } else if (key == 'x' || key == 'X') {
    exit();
  }
}