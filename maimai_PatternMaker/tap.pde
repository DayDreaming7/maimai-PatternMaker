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


void displayAllTabs() {
  for (Tap temp : taps) {
    temp.display();
  }
}