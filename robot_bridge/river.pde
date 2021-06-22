class River {
  float riverHeight;
  River(float riverHeight) {
    this.riverHeight = riverHeight;
  }

  //Draw river
  void drawRiver() {
    fill(#38afcd);
    noStroke();
    rect(0, height/2.0 - this.riverHeight/2.0, width, this.riverHeight);
  }
}
