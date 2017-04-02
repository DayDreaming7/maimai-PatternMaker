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
    ellipse(x, y, hitPointOutterR, hitPointOutterR);
    fill(hitPointInnerColor);
    ellipse(x, y, hitPointInnerR, hitPointInnerR);
  }
}