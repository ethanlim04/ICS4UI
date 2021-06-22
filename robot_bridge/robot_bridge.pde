import g4p_controls.*;

Robot bot1, bot2;

//Configurable
int bridgeX = 50;
int bridgeWidth = 50;
float riverHeight = 300;

River river = new River(riverHeight);
Bridge bridge = new Bridge(bridgeX, bridgeWidth, river);
int defaultX = 1000/2;
int defaultSpeed = 10;
int f;

void setup() {
  size(1200, 800);
  background(#2C5F2D);
  bot1 = new Robot(loadImage("robot1-new.png"), "CG", new PVector(defaultX, height/2.0 - river.riverHeight/2.0 - 50 - 50), defaultSpeed, 50, 50, bridge);
  bot2 = new Robot(loadImage("robot2-new.png"), "DA", new PVector(defaultX, height/2.0 + river.riverHeight/2.0 + 50), defaultSpeed, 50, 50, bridge);
  bot1.drawBot();
  bot2.drawBot();
  frameRate(60);
  createGUI();
  f = 0;
}

void draw() {
  //Update the positions of both robots
  bot1.update(f);
  bot2.update(f);
  background(#2C5F2D);
  //Draw river
  river.drawRiver();
  //Draw bridge
  bridge.drawBridge();
  //Draw both robots
  bot1.drawBot();
  bot2.drawBot();

  fill(0);
  rect(1000, 0, 200, height);

  //Display information for robot 1
  textSize(30);
  fill(0, 0, 255);
  text("Robot 1", 1012, 50);
  textSize(15);
  text("Constant Growth", 1012, 70);
  text("Total Searched: " + str(bot1.totalSearched), 1012, 90);
  if (bot1.foundBridge) {
    text("Located Bridge: YES", 1012, 110);
    text("Time took: " + str(bot1.framesTook) + " frames", 1012, 130);
  } else {
    text("Located Bridge: NO", 1012, 110);
    text("Time: " + str(f) + " frames", 1012, 130);
  }
  text("Speed:", 1012, 150);

  //Display information for robot 2
  textSize(30);
  fill(255, 0, 0);
  text("Robot 2", 1012, 250);
  textSize(15);
  text("Doubling Algorithm", 1012, 270);
  text("Total Searched: " + str(bot2.totalSearched), 1012, 290);
  if (bot2.foundBridge) {
    text("Located Bridge: YES", 1012, 310);
    text("Time took: " + str(bot2.framesTook) + " frames", 1012, 330);
  } else {
    text("Located Bridge: NO", 1012, 310);
    text("Time: " + str(f) + " frames", 1012, 330);
  }
  text("Speed:", 1012, 350);

  textSize(20);
  fill(255);
  text("Starting Location", 1012, 540);
  text("Step Size", 1012, 650);

  //Continue to increment frames if both robots are moving
  if (bot1.animate && !bot1.needsRestart) {
    f++;
  }
}
