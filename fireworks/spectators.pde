class Person {
    PVector pos;
    float orgX, orgY;
    FireworkEvent event;
    boolean excited, disappointed;
    Person(FireworkEvent event) {
        this.pos = new PVector(random(12.5, width-12.5), random(height-100+50, height-50));
        this.event = event;
        this.orgX = this.pos.x;
        this.orgY = this.pos.y;
        this.excited = false;
        this.disappointed = false;
    }

    void display() {
        fill(230, 198, 183);
        stroke(0);
        arc(this.pos.x, this.pos.y, 25, 50, -PI, 0);
    }

    void update(int f) {
        if(event.totalScore > 400) {
            this.excited = true;
        }
        else if(event.totalScore < 200) {
            this.excited = false;
        }
        if(this.excited) {
            this.pos.y += random(-3*event.totalScore/300, 3*event.totalScore/300);
        }
        if(this.disappointed) {
            this.pos.x += random(50, 100);
        }
        this.display();
    }
}