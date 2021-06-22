//Ethan Lim
//ICS4UI
int f;
FireworkEvent myEvent;
PImage bg;
void setup() {
  bg = loadImage("beach.png");
  f = 0;
  //myEvent = new FireworkEvent(color(0));
  myEvent = new FireworkEvent(bg);
  size(1000, 1000);

  for(int i = 0; i < 10; i++) {
    myEvent.addFirework(5, 1.6, width/10 * i, 10, color(250, 100, 100), color(255,215,0), 4, 10); //special pattern
  }
  
  //Add fireworks
  //Parameters: Acceleration of firework, Angle of firework, X-position of firework, Size of firework, Primary colour of firework, Secondary colour of firework, Pattern of sparks, When to launch firework
  myEvent.addFirework(5, 1.4, 100, 50, color(125, 250, 250), color(250, 125, 125), 2, 50);
  myEvent.addFirework(5, 1.9, 600, 10, color(125, 250, 250), color(250, 125, 125), 2, 50);
  myEvent.addFirework(5, 1.1, 500, 50, color(125, 250, 250), color(250, 125, 125), 2, 100);
  myEvent.addFirework(5, 1.1, 500, 50, color(125, 250, 250), color(250, 125, 125), 2, 120);
  myEvent.addFirework(5, 1.1, 100, 10, color(125, 250, 250), color(250, 125, 125), 2, 125);
  myEvent.addFirework(5, 1.1, 100, 10, color(125, 250, 250), color(250, 125, 125), 2, 150);
  myEvent.addFirework(5, 1.1, 100, 25, color(125, 250, 250), color(250, 125, 125), 2, 200);
}

void draw() {
  background(myEvent.bg);
  myEvent.update(f);
  f++;
  fill(255);
}