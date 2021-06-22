class Firework {
    Rocket firework_rocket;
    Spark[] sparks;
    float starting_acceleration, starting_angle, starting_x;
    int leftOrRight = 1;
    int size, pattern, score;
    boolean sparks_generated;
    color col, altCol;
    String name;
    FireworkEvent parentEvent;

    Firework(float starting_acceleration, float starting_angle, float starting_x, int size, FireworkEvent parentEvent) {
        this.starting_acceleration = starting_acceleration;
        this.starting_angle = starting_angle;
        if(starting_angle > PI/2.0) {
            leftOrRight = -1;
        }
        this.size = size;
        this.sparks_generated = false;
        this.sparks = new Spark[size*2];
        this.col = col;
        this.altCol = col;
        this.pattern = int(random(1, 3.99));
        this.col = color(random(0, 255), random(0, 255), random(0, 255));
        this.altCol = color(random(0, 255), random(0, 255), random(0, 255));
        this.firework_rocket = new Rocket(starting_acceleration, starting_angle, new PVector(starting_x + 5*((size-5)/4.0 + 5)*cos(starting_angle), 900-5*((size-5)/4.0 + 5)*sin(starting_angle)), leftOrRight, (size-5)/4.0 + 5, col);
        this.name = "";
        this.score = this.pattern * this.size;
        this.parentEvent = parentEvent;
    }
    Firework(float starting_acceleration, float starting_angle, float starting_x, int size, int pattern, FireworkEvent parentEvent) {
        this.starting_acceleration = starting_acceleration;
        this.starting_angle = starting_angle;
        if(starting_angle > PI/2.0) {
            leftOrRight = -1;
        }
        this.firework_rocket = new Rocket(starting_acceleration, starting_angle, new PVector(starting_x + 5*((size-5)/4.0 + 5)*cos(starting_angle), 900-5*((size-5)/4.0 + 5)*sin(starting_angle)), leftOrRight, (size-5)/4.0 + 5, col);
        this.size = size;
        this.sparks_generated = false;
        this.sparks = new Spark[size*2];
        this.col = color(random(0, 255), random(0, 255), random(0, 255));
        this.altCol = color(random(0, 255), random(0, 255), random(0, 255));
        this.pattern = pattern;
        this.name = "";
        this.score = this.pattern * this.size;
        this.parentEvent = parentEvent;
    }
    Firework(float starting_acceleration, float starting_angle, float starting_x, int size, color col, int pattern, FireworkEvent parentEvent) {
        this.starting_acceleration = starting_acceleration;
        this.starting_angle = starting_angle;
        if(starting_angle > PI/2.0) {
            leftOrRight = -1;
        }
        this.firework_rocket = new Rocket(starting_acceleration, starting_angle, new PVector(starting_x + 5*((size-5)/4.0 + 5)*cos(starting_angle), 900-5*((size-5)/4.0 + 5)*sin(starting_angle)), leftOrRight, (size-5)/4.0 + 5, col);
        this.size = size;
        this.sparks_generated = false;
        this.sparks = new Spark[size*2];
        this.col = col;
        this.altCol = col;
        this.pattern = pattern;
        this.name = "";
        this.score = this.pattern * this.size;
        this.parentEvent = parentEvent;
    }
    Firework(float starting_acceleration, float starting_angle, float starting_x, int size, color col, color altCol, int pattern, FireworkEvent parentEvent) {
        this.starting_acceleration = starting_acceleration;
        this.starting_angle = starting_angle;
        if(starting_angle > PI/2.0) {
            leftOrRight = -1;
        }
        this.firework_rocket = new Rocket(starting_acceleration, starting_angle, new PVector(starting_x + 5*((size-5)/4.0 + 5)*cos(starting_angle), 900-5*((size-5)/4.0 + 5)*sin(starting_angle)), leftOrRight, (size-5)/4.0 + 5, col);
        this.size = size;
        this.sparks_generated = false;
        this.sparks = new Spark[size*2];
        this.col = col;
        this.altCol = altCol;
        this.pattern = pattern;
        this.name = "";
        this.score = this.pattern * this.size;
        this.parentEvent = parentEvent;
    }
    
    Firework(float starting_acceleration, float starting_angle, float starting_x, int size, color col, color altCol, int pattern, String name, FireworkEvent parentEvent) {
        this.starting_acceleration = starting_acceleration;
        this.starting_angle = starting_angle;
        if(starting_angle > PI/2.0) {
            leftOrRight = -1;
        }
        this.firework_rocket = new Rocket(starting_acceleration, starting_angle, new PVector(starting_x + 5*((size-5)/4.0 + 5)*cos(starting_angle), 900-5*((size-5)/4.0 + 5)*sin(starting_angle)), leftOrRight, (size-5)/4.0 + 5, col);
        this.size = size;
        this.sparks_generated = false;
        this.sparks = new Spark[size*2];
        this.col = col;
        this.altCol = altCol;
        this.pattern = pattern;
        this.name = name;
        this.score = this.pattern * this.size;
        this.parentEvent = parentEvent;
    }
    
    //updates position of firework
    void update(int f) {
        if(this.firework_rocket.alive) {
            this.firework_rocket.updatePositions(f - this.firework_rocket.startingFrame);
            this.firework_rocket.drawObj();
        }
        else {
            //generates sparks if they have not already been generated
            if(!this.sparks_generated) {
                for(int iter = 0; iter < 2*size; iter++) {
                //generates sparks with different patterns
                    if(this.pattern == 1) {
                        if(iter%2 == 0)
                        this.sparks[iter] = new Spark(3, PI/this.size * iter + 0.0001, this.firework_rocket.headPosition(), f, this.size, this.altCol);
                        else
                        this.sparks[iter] = new Spark(3, 2*PI/this.size * iter + 0.0001, this.firework_rocket.headPosition(), f, this.size, this.col);
                    }
                    else if(this.pattern == 2) {
                        if(iter < 5) {
                            this.sparks[iter] = new Spark(this.size/50.0 * 2, 2*PI/5.0 * iter + 0.0001, this.firework_rocket.headPosition(), f, this.size, this.altCol);
                        }
                        else {
                            this.sparks[iter] = new Spark(this.size/10.0 * 1.5, 2*PI/(2.0*(this.size-5)) * iter, this.firework_rocket.headPosition(), f, this.size, this.col);
                        }
                    }
                    else if(this.pattern == 3) {
                        if(iter%2 == 0) {
                            this.sparks[iter] = new Spark(this.size/50.0 * 1.5, 2*PI/(this.size) * iter + 0.0001, this.firework_rocket.headPosition(), f, this.size, this.altCol);
                        }
                        else {
                            this.sparks[iter] = new Spark(this.size/10.0 * 1.0, 2*PI/(2.0*(this.size)) * iter, this.firework_rocket.headPosition(), f, this.size, this.col);
                        }
                    }
                    else if(this.pattern == 4) { //special pattern
                        if(iter%3 == 0) {
                            this.sparks[iter] = new Spark(this.size/50.0 * 1.5, 2*PI/(this.size) * iter + 0.0001, this.firework_rocket.headPosition(), f, this.size, this.altCol);
                        }
                        else if(iter%3 == 1){
                            this.sparks[iter] = new Spark(this.size/10.0 * 1.0, 2*PI/(2.0*(this.size)) * iter, this.firework_rocket.headPosition(), f, this.size, this.col);
                        }
                        else {
                            this.sparks[iter] = new Spark(this.size/10.0 * 1.0, 2*PI/(2.0*(this.size)) * iter, this.firework_rocket.headPosition(), f, this.size, color(255));
                        }
                    }
                }
                this.sparks_generated = true;
                this.parentEvent.totalScore += this.score;
            }
            else {
                for(Spark spark : this.sparks) {
                    spark.updatePosition((f - spark.startingFrame));
                    spark.drawObj();
                }
            }
        }
    }
}