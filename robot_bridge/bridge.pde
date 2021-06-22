class Bridge {
  //X position and width of bridge
  float xPos, bridgeWidth;
  //River
  River river;
  Bridge(float xPos, float bridgeWidth, River river) {
    this.xPos = xPos;
    this.bridgeWidth = bridgeWidth;
    this.river = river;
  }

  //Draw bridge
  void drawBridge() {
    float startY = height/2.0 - this.river.riverHeight/2.0 - 15;
    float endY = height/2.0 + this.river.riverHeight/2.0 + 15;
    float blockHeight = (endY - startY)/10.0;
    fill(150, 75, 0);
    stroke(0);
    for (float pos = startY; pos < endY; pos += blockHeight) {
      rect(this.xPos - this.bridgeWidth/2.0, pos, bridgeWidth, blockHeight);
    }
  }
}
