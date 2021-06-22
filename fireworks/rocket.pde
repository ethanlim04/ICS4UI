class Rocket {
  //parameters to calculate position of the rocket
  float p; //adjustment factor for acceleration
  float q; //adjustment factor for acceleration
  float a0; //starting acceleration
  float r; //starting angle
  float k;
  float j;
  PVector[] positions; //vertecies of the rocket
  float orgX, orgY; //original x, y positions
  int startingFrame; //frame that the rocket starts at
  boolean accelerating, alive, launched;
  int leftOrRight; //direction that the rocket is headed
  float size;
  PVector[] flameTemp, flame; //flame trail behind rocket
  color col;
  Rocket(float a0, float r, PVector pos, int leftOrRight, float size, color col) {
    this.p = 8.1;
    this.q = this.p;
    this.a0 = a0;
    this.r = r;
    this.k = a0 * sin(r);
    this.j = a0 * cos(r);
    this.positions = new PVector[6];
    this.positions[0] = pos;
    this.orgX = pos.x;
    this.orgY = pos.y;
    this.startingFrame = 0;
    this.leftOrRight = leftOrRight;
    this.flameTemp = new PVector[5];
    this.flame = new PVector[5];
    this.accelerating = true;
    this.alive = true;
    this.size = size;
    this.col = col;
    this.launched = false;
  }
  
  void drawObj() {

    //draws body of rocket
    beginShape();
    fill(125);
    vertex(this.positions[0].x + orgX, this.positions[0].y - (height - orgY)); //top right (origin)
    vertex(this.positions[1].x + orgX, this.positions[1].y - (height - orgY)); //bottom right
    vertex(this.positions[3].x + orgX, this.positions[3].y - (height - orgY)); //bottom left
    vertex(this.positions[2].x + orgX, this.positions[2].y - (height - orgY)); //top left
    endShape();

    //draws head of rocket
    beginShape();
    fill(col);
    vertex(this.positions[4].x + orgX, this.positions[4].y - (height - orgY)); //head
    vertex(this.positions[0].x + orgX, this.positions[0].y - (height - orgY)); //top right (origin)
    vertex(this.positions[2].x + orgX, this.positions[2].y - (height - orgY)); //top left
    endShape();

    //draws the stick attached to the rocket
    stroke(125);
    line(this.positions[1].x + orgX, this.positions[1].y - (height - orgY), this.positions[5].x + orgX, this.positions[5].y - (height - orgY)); //stick
    fill(125);
    circle(this.positions[5].x + orgX, this.positions[5].y - (height - orgY), this.size * 0.25);

    //draws the flame trail of the rocket
    if(this.accelerating) {
      noStroke();
      beginShape();
      fill(255, 0, 0);
      vertex(this.positions[3].x + orgX, this.positions[3].y - (height - orgY));
      for(int iter = 0; iter < 5; iter++) {
        PVector obj = this.flame[iter];
        vertex(obj.x + orgX, obj.y - (height - orgY));
      }
      vertex(this.positions[1].x + orgX, this.positions[1].y - (height - orgY));
      endShape();
    }
  }

  //"launches" the rocket, sets its starting frame and creates a flame trail
  void launch(int f) {
    this.startingFrame = f;
    for(int i = 1; i < 6; i++) {
      this.positions[i] = new PVector(0, 0);
    }
    for(int i = 0; i < 5; i++) {
      this.flameTemp[i] = new PVector(0, 0);
      this.flame[i] = new PVector(0, 0);
    }
  }
  
  //returns the position of the 'head' of the rocket
  PVector headPosition() {
    return new PVector(this.positions[4].x + orgX, this.positions[4].y - (height - orgY));
  }

  //calculates if a dot is inside the rocket
  //this function is later used to check if two rockets "overlap" or "collide"
  boolean overlap(float x, float y, float f) {
    if(!(max(max(this.positions[0].x + this.orgX, this.positions[1].x + this.orgX, this.positions[2].x + this.orgX), this.positions[3].x + this.orgX, this.positions[4].x + this.orgX) > x && min(min(this.positions[0].x + this.orgX, this.positions[1].x + this.orgX, this.positions[2].x + this.orgX), this.positions[3].x + this.orgX, this.positions[4].x + this.orgX)  < x)) {
      return false;
    }
    if(! (min(min(this.positions[0].y - (height - this.orgY), this.positions[1].y - (height - this.orgY), this.positions[2].y - (height - this.orgY)), this.positions[3].y - (height - this.orgY), this.positions[4].y - (height - this.orgY)) < y && y < max(max(this.positions[0].y - (height - this.orgY), this.positions[1].y - (height - this.orgY), this.positions[2].y - (height - this.orgY)), this.positions[3].y - (height - this.orgY), this.positions[4].y - (height - this.orgY)))) {
      return false;
    }
    float tempy1 = height - this.tangent(x, f/10.0);
    float tempy2 = this.tangent_general(x, f/10.0, this.positions[2].x, height - this.positions[2].y);
    if(y > min(tempy1, tempy2) && y < max(tempy1, tempy2)) {
      return true;
    }
    else {
      return false;
    }
  }

  //rocket explodes after it reaches its desired time, or after it collides with another rocket
  void explode() {
    this.alive = false;
  }

  //explodes both rockets in a collision
  void collide(Firework obj) {
    this.explode();
    obj.firework_rocket.explode();
  }

  //Necessary math to calculate the verticies of the rocket based on one point that is moving
  //https://www.desmos.com/calculator/hygac5grl6
  float temp_rocket_head;
  //updates the vertecies of the rockets
  void updatePositions(int f) {
    //stops accelerating once it has reached a specific time (81 frames from launch)
    if(f == 81) {
      this.accelerating = false;
    }
    //explodes after a certain time period
    if(f == int(this.size*15)) {
      this.explode();
    }

    this.positions[0].x = calcX(f);
    this.positions[0].y = height - calcY(f);

    this.positions[1].x = shift_horizontal(this.positions[0].x, f, -5*this.size);
    this.positions[1].y = height - tangent(this.positions[1].x, f/10.0);

    temp_rocket_head = shift_horizontal(this.positions[0].x, f, 3/2.0 * this.size);

    for(int iter = 0; iter < 5; iter++) {
      this.flameTemp[iter].x = shift_horizontal(this.positions[1].x, f, random(-2.5*this.size, -0.5*this.size));
      this.flameTemp[iter].y = height - tangent(this.flameTemp[iter].x, f/10.0);
    }
    
    if(v_y(f/10.0)/v_x(f/10.0) >= 0) {
      this.positions[2].x = shift_vertical(this.positions[0].x, f, 2*this.size);
      this.positions[3].x = shift_vertical(this.positions[1].x, f, 2*this.size);
      this.positions[4].x = shift_vertical(temp_rocket_head, f, this.size);

      for(int iter = 0; iter < 5; iter++) {
      this.flame[iter].x = shift_vertical(this.flameTemp[iter].x, f, random(2*this.size/5.0*(5-iter), 2*this.size/5.0*(6-iter)));
      this.flame[iter].y = height - inv_tangent_general(this.flame[iter].x, f/10.0, this.flameTemp[iter].x, tangent(this.flameTemp[iter].x, f/10.0));
      }
    }
    else {
      this.positions[2].x = shift_vertical(this.positions[0].x, f, -2*this.size);
      this.positions[3].x = shift_vertical(this.positions[1].x, f, -2*this.size);
      this.positions[4].x = shift_vertical(temp_rocket_head, f, -1*this.size);
      
      for(int iter = 0; iter < 5; iter++) {
      this.flame[iter].x = shift_vertical(this.flameTemp[iter].x, f, (-1)*random(2*this.size/5.0*(4-iter), 2*this.size/5.0*(5-iter)));
      this.flame[iter].y = height - inv_tangent_general(this.flame[iter].x, f/10.0, this.flameTemp[iter].x, tangent(this.flameTemp[iter].x, f/10.0));
      }
    }

    this.positions[2].y = height - inv_tangent(this.positions[2].x, f/10.0);
    this.positions[3].y = height - inv_tangent_general(this.positions[3].x, f/10.0, this.positions[1].x, (-1)*this.positions[1].y + height);
    this.positions[4].y = height - inv_tangent_general(this.positions[4].x, f/10.0, temp_rocket_head, tangent(temp_rocket_head, f/10.0));

    this.positions[5].x = shift_horizontal(this.positions[0].x, f, -10*this.size);
    this.positions[5].y = height - tangent(this.positions[5].x, f/10.0);
  }

  float shift_horizontal(float xStart, int f, float amt) {
    if(amt < 0) {
      return xStart - pow(pow(amt, 2) / (pow(v_y(f/10.0)/v_x(f/10.0), 2) + 1), 0.5)*this.leftOrRight;
    }
    else {
      return xStart + pow(pow(amt, 2) / (pow(v_y(f/10.0)/v_x(f/10.0), 2) + 1), 0.5)*this.leftOrRight;
    }
  }

  float shift_vertical(float xStart, int f, float amt) {
    if(amt > 0) {
      return xStart - pow(pow(amt, 2) / (pow(v_x(f/10.0)/v_y(f/10.0), 2) + 1), 0.5)*this.leftOrRight;
    }
    else {
      return xStart + pow(pow(amt, 2) / (pow(v_x(f/10.0)/v_y(f/10.0), 2) + 1), 0.5)*this.leftOrRight;
    }
  }

  //Necessary math to calculate a point on the rocket that has linear acceleration, and is also affected by gravity
  //https://www.desmos.com/calculator/hygac5grl6
  float calcX(float f) {
    f = f/10.0;
    if(f < this.p) {
      return (-1)*this.j/6.0 * pow(f, 3) + this.j*this.q/2.0 * pow(f, 2);
    }
    else {
      return (-1)*this.j/6.0 * pow(this.q, 3) + this.j*this.q/2.0 * pow(this.q, 2) + (f-this.q)*((-1)*this.j/2.0 * pow(this.q, 2) + this.j*pow(this.q, 2)); 
    }
  }
  
  float calcY(float f) {
    f = f/10.0;
    float yVal;
    if(f < this.p) {
      yVal = (-1)*this.k/6.0 * pow(f, 3) + (this.k*this.p - 9.8)/2.0 * pow(f, 2);
    }
    else {
      yVal = (-1)*this.k/6.0 * pow(this.p, 3) + (this.k*this.p - 9.8)/2.0 * pow(this.p, 2) + o(f) - o(this.p);
    }
    return yVal;
  }
  
  //anti-derivative of v_y
  float o(float x) {
    return (-1)*9.8/2.0 * pow(x, 2) + x*(9.8*this.p + (this.k*this.p - 9.8)*(this.p - 9.8/this.k)/2.0 + 9.8/this.k * (-9.8)/2.0); 
  }
  
  //derivative of calcX
  float v_x(float x) {
    if(x < this.q) {
      return (-1)*this.j/2.0 * pow(x, 2) + this.j * this.q*x;
    }
    else {
      return (-1)*this.j/2.0 * pow(this.q, 2) + this.j * pow(this.q, 2);
    }
  }
  
  //derivative of calcY
  float v_y(float x) {
    if(x < this.p) {
      return (-1)*this.k/2.0 * pow(x, 2) + (this.k * this.p - 9.8)*x;
    }
    else {
      return ((this.k * this.p - 9.8)*(this.p - 9.8/this.k))/2.0 + 9.8/this.k * (-9.8)/2.0 - 9.8*(x-this.p);
    }
  }
  
  //line tangent to point x on the trajectory of the rocket
  float tangent(float x, float f) {
    return (v_y(f)/v_x(f)) * (x - calcX(f*10)) + calcY(f*10);
  }

  //a more "generalized" version of the equation above
  float tangent_general(float x, float f, float org, float org2) {
    return (v_y(f)/v_x(f)) * (x - org) + org2;
  }

  //line perpendicular to the line tangent to point x on the trajectory of the rocket, that passes through point x
  float inv_tangent(float x, float f) {
    return (-1)*(v_x(f)/v_y(f)) * (x - calcX(f*10)) + calcY(f*10);
  }

  //a more "generalized" version of the equation above
  float inv_tangent_general(float x, float f, float org, float org2) {
    return (-1)*(v_x(f)/v_y(f)) * (x - org) + org2;
  }
}
