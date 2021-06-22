import java.util.*;
class Robot {
  //Algorithm that the robot is using
  int algoType;
  //Position of the robot
  PVector pos;
  //Speed of the robot
  int speed;
  //Number of turns that the robot has made
  int turns;
  //Number of frames it took for the robot to locate the bridge
  int framesTook;
  //Spot that the robot is aiming to move to
  int targetSpot;
  //Total area that the robot searches
  int totalSearched;
  //Size of robot's step
  int stepSize;
  //If the robot has found the bridge, has reached its desired position, should be animated, or needs to restart
  boolean foundBridge, reachedPos, animate, needsRestart;
  //Markers at the spots where the robot makes a turn
  ArrayList<Integer> markers;
  //Width and height of the robot
  int w, h;
  //Bridge
  Bridge bridge;
  //Robot picture
  PImage img;
  Robot(PImage img, String algoTypeStr, PVector startingPos, int speed, int w, int h, Bridge bridge) {
    this.img = img;
    if (algoTypeStr == "CG") {
      this.algoType = 0;
    } else {
      this.algoType = 1;
    }
    this.pos = startingPos;
    this.speed = speed;
    this.turns = 0;
    this.targetSpot = startingPos.x;
    this.totalSearched = 0;
    this.foundBridge = false;
    this.reachedPos = false;
    this.needsRestart = false;
    this.markers = new ArrayList<Integer>();
    this.bridge = bridge;
    this.w = w;
    this.h = h;
    this.stepSize = 25;
    this.animate = true;
  }

  //Draw the robot and markers
  void drawBot() {
    fill(255);
    stroke(255);
    strokeWeight(1);
    image(this.img, this.pos.x - this.w/2.0, this.pos.y, this.w, this.h);

    //Draw the markers
    for (Float lineX : markers) {
      strokeWeight(2);
      fill(0);
      stroke(0);
      line(lineX, this.pos.y, lineX, this.pos.y + this.h);
    }
  }

  //Calculate robot's next desired position using the constant growth algorithm
  void constant_growth(float s) {
    if (this.turns%2 == 1) {
      this.targetSpot = this.pos.x + s*this.turns;
    } else {
      this.targetSpot = this.pos.x - s*this.turns;
    }
  }

  //Calculate robot's next desired position using the doubling algorithm
  void doubling(float s) {
    if (this.turns%2 == 1) {
      this.targetSpot = this.pos.x + s*pow(2, this.turns-1);
    } else {
      this.targetSpot = this.pos.x - s*pow(2, this.turns-1);
    }
  }

  //Update the position of the robot
  void update(int f) {
    if (this.animate && !this.needsRestart) {
      if (this.markers.size() == 0) {
        markers.add(this.pos.x);
      }
      if (!this.foundBridge) {
        //If the distance between the robot and its desired position is less than how much it moves per frame, set the robot's position to its desired spot
        if (abs(this.targetSpot - this.pos.x) <= this.speed) {
          this.totalSearched += abs(this.targetSpot - this.pos.x);
          this.pos.x = this.targetSpot;
        }

        //If the desired spot of the robot is to its right, move the robot to the right
        if (this.pos.x < this.targetSpot) {
          this.pos.x += this.speed;
          this.totalSearched += this.speed;
        }

        //If the desired spot of the robot is to its left, move the robot to the left
        else if (this.pos.x > this.targetSpot) {
          this.pos.x -= this.speed;
          this.totalSearched += this.speed;
        }

        //If the robot has reached its desired position
        else {
          this.reachedPos = true;
        }

        //Check if the robot has found the bridge
        this.foundBridge = checkBridge(f);

        //If the robot has reached its desired position and has not located the bridge, it makes a turn, then calculates its next desired position
        if (this.reachedPos && !this.foundBridge) {
          this.turns++;
          this.markers.add(this.pos.x);
          if (this.algoType == 0) {
            constant_growth(this.stepSize);
          } else {
            doubling(this.stepSize);
          }
          this.reachedPos = false;
        }
      }

      //If the robot has already found the bridge, move the robot to the center of the bridge
      else {
        if (this.pos.x != this.bridge.xPos) {
          if (abs(this.bridge.xPos - this.pos.x) <= this.speed) {
            this.pos.x = this.bridge.xPos;
          } else if (this.pos.x < this.bridge.xPos) {
            this.pos.x += this.speed;
          } else if (this.pos.x > this.bridge.xPos) {
            this.pos.x -= this.speed;
          }
        }
      }
    }
  }


  //Check if the robot has located the bridge
  boolean checkBridge(int f) {
    if (!this.foundBridge) {
      //If the center of the robot is in between the two edges of the bridge
      if ((this.pos.x >= this.bridge.xPos - this.bridge.bridgeWidth/2.0) && (this.pos.x <= this.bridge.xPos + this.bridge.bridgeWidth/2.0)) {
        this.framesTook = f;
        return true;
      }

      //Check for exceptions where the robot's speed is very large
      //If the robot is heading to the right, check if the bridge has already been passed
      if (this.turns % 2 == 1) {
        if ((Collections.min(this.markers) <= this.bridge.xPos - this.bridge.bridgeWidth/2.0) && (this.pos.x + this.w/2.0 >= this.bridge.xPos - this.bridge.bridgeWidth/2.0)) {
          this.framesTook = f;
          return true;
        }
      }
      //If the robot is heading to the left, check if the bridge has already been passed
      else {
        if ((Collections.max(this.markers) >= this.bridge.xPos + this.bridge.bridgeWidth/2.0) && (this.pos.x - this.w/2.0 <= this.bridge.xPos + this.bridge.bridgeWidth/2.0)) {
          this.framesTook = f;
          return true;
        }
      }
      return false;
    }
    return true;
  }

  //Change the step size of the robot and require it to restart
  void changeStep(float step) {
    this.stepSize = step;
    this.needsRestart = true;
  }

  //Restart the robot with values from the GUI
  void restart() {
    this.turns = 0;
    this.totalSearched = 0;
    this.foundBridge = false;
    this.reachedPos = false;
    this.needsRestart = false;
    this.markers = new ArrayList<Float>();
    this.stepSize = stepSlider.getValueF();
    this.pos.x = xSlider.getValueF();
    this.targetSpot = this.pos.x;
    this.animate = true;
    if (this.algoType == 0) {
      this.speed = bot1SpeedSlider.getValueF();
    } else {
      this.speed = bot2SpeedSlider.getValueF();
    }
  }

  //Change the starting position of the robot and require it to restart
  void changeX(float x) {
    this.pos.x = x;
    this.needsRestart = true;
  }

  //Change the speed of the robot and require it to restart
  void changeSpeed(float speed) {
    this.speed = speed;
    this.needsRestart = true;
  }

  //Pause or resume the movement of the robot
  void pausePlay() {
    if (this.animate) {
      this.animate = false;
    } else {
      this.animate = true;
    }
  }
}
