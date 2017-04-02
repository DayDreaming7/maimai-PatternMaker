void initializeAll(){
    initSizeValue();
    initAllShape();
    initHitPoints();
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
  psTap = createShape(GROUP);

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