class Spark {
    float a0, r, p, q, k, j, orgX, orgY, fallSpeed;
    int startingFrame, lifetime, size;
    PVector position;
    boolean isAlive, continueAdding;
    ArrayList<PVector> trail;
    color col;
    Spark(float a0, float r, PVector pos, int startingFrame, int size, color col) {
        this.p = 6;
        this.q = this.p;
        this.a0 = a0;
        this.r = r;
        this.k = a0 * sin(r);
        this.j = a0 * cos(r);
        this.position = pos;
        this.orgX = pos.x;
        this.orgY = pos.y;
        this.startingFrame = startingFrame;
        this.isAlive = true;
        this.continueAdding = true;
        this.lifetime = this.size*2;
        this.fallSpeed = 2;
        this.col = col;
        this.trail = new ArrayList<PVector>();
        this.size = size;
    }
    void drawObj() {
        int count = 0;
        if(this.continueAdding) {
            //stores all points in an ArrayList, to make sure all desired points are displayed on screen
            this.trail.add(new PVector (this.position.x + orgX, this.position.y - (height - this.orgY)));
        }
        
        else {
            this.trail.add(new PVector (this.position.x + orgX, this.position.y - (height - this.orgY)));

            //slowly removes points when its time for them to disappear
            if(this.trail.size() > 3) {
                for(int rm = 0; rm < 3; rm++) {
                    this.trail.remove(0);
                }
            }
            else {
                for(int rm = 0; rm < this.trail.size(); rm++) {
                    this.trail.remove(0);
                }
                this.isAlive = false;
            }
        }

        //only display the trail if it is not completely gone
        if(this.isAlive) {
            for(PVector obj : this.trail) {
                fill(red(col) * (float(count)/this.trail.size()), green(col) * (float(count)/this.trail.size()), blue(col) * (float(count)/this.trail.size()));
                noStroke();
                circle(obj.x, obj.y, 3 * float(this.size + 5)/this.size * (float(count)/this.trail.size()));
                count += 1;
            }
        }
    }

    //updates position of the spark
    void updatePosition(float f) {
        this.position.x = calcX(f);
        this.position.y = height - calcY(f);
        if(f - this.startingFrame > lifetime) {
            this.continueAdding = false;
        }
    }

    //Necessary math to calculate the position of the spark at a given frame
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
    float gravity;
    float calcY(float f) {
        gravity = this.fallSpeed;
        f = f/10.0;
        float yVal;
        if(f < this.p) {
        yVal = (-1)*this.k/6.0 * pow(f, 3) + (this.k*this.p - gravity)/2.0 * pow(f, 2);
        }
        else {
        yVal = (-1)*this.k/6.0 * pow(this.p, 3) + (this.k*this.p - gravity)/2.0 * pow(this.p, 2) + o(f) - o(this.p);
        }
        return yVal;
    }
    
    float o(float x) {
        return (-1)*gravity/2.0 * pow(x, 2) + x*(gravity*this.p + (this.k*this.p - gravity)*(this.p - gravity/this.k)/2.0 + gravity/this.k * (-gravity)/2.0); 
    }
}