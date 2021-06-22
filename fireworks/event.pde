class FireworkEvent {
    color background;
    PImage bg;
    ArrayList<Firework> fireworks;
    ArrayList<Integer> startFrames;
    ArrayList<Firework> checkList;
    ArrayList<Person> people;
    int totalScore;
    FireworkEvent(color background) {
        this.background = background;
        this.fireworks = new ArrayList<Firework>();
        this.startFrames = new ArrayList<Integer>();
        this.people = new ArrayList<Person>();
    }
    FireworkEvent(PImage background) {
        this.bg = background;
        this.fireworks = new ArrayList<Firework>();
        this.startFrames = new ArrayList<Integer>();
        this.people = new ArrayList<Person>();
    }

    void addFirework(float starting_acceleration, float starting_angle, float starting_x, int size, int launchTime) {
        this.fireworks.add(new Firework(starting_acceleration, starting_angle, starting_x, size, this));
        this.startFrames.add(launchTime);
    }
    void addFirework(float starting_acceleration, float starting_angle, float starting_x, int size, int pattern, int launchTime) {
        this.fireworks.add(new Firework(starting_acceleration, starting_angle, starting_x, size, pattern, this));
        this.startFrames.add(launchTime);
    }
    void addFirework(float starting_acceleration, float starting_angle, float starting_x, int size, color col, int pattern, int launchTime) {
        this.fireworks.add(new Firework(starting_acceleration, starting_angle, starting_x, size, col, pattern, this));
        this.startFrames.add(launchTime);
    }
    void addFirework(float starting_acceleration, float starting_angle, float starting_x, int size, color col, color altCol, int pattern, int launchTime) {
        this.fireworks.add(new Firework(starting_acceleration, starting_angle, starting_x, size, col, altCol, pattern, this));
        this.startFrames.add(launchTime);
    }
    void addFirework(float starting_acceleration, float starting_angle, float starting_x, int size, color col, color altCol, int pattern, String name, int launchTime) {
        this.fireworks.add(new Firework(starting_acceleration, starting_angle, starting_x, size, col, altCol, pattern, name, this));
        this.startFrames.add(launchTime);
    }

    void update(int f) {
        if(this.totalScore > 1) {
            this.totalScore -= 1;
        }
        for(int iter = 0; iter < this.fireworks.size(); iter++) {
            if(f == this.startFrames.get(iter)) {
                this.fireworks.get(iter).firework_rocket.launch(f);
            }
            if(f == this.startFrames.get(iter) + 1) {
                this.fireworks.get(iter).firework_rocket.launched = true;
            }

            //updates positions for each firework in the event
            if(f > this.startFrames.get(iter)) {
                this.fireworks.get(iter).update(f);
                this.checkList = new ArrayList<Firework>();

                //list of fireworks to check for collisions
                for(Firework obj : fireworks) {
                    if(obj != this.fireworks.get(iter) && this.fireworks.get(iter).firework_rocket.alive) {
                        if(obj.firework_rocket.launched && obj.firework_rocket.alive) {
                            this.checkList.add(obj);
                        }
                    }
                }

                Firework current = this.fireworks.get(iter);
                //checks for collisions
                for(Firework obj : this.checkList) {
                    for(int i = 0; i < 6; i++) {
                        if(current.firework_rocket.overlap(obj.firework_rocket.positions[i].x + obj.firework_rocket.orgX, obj.firework_rocket.positions[i].y - (height - obj.firework_rocket.orgY), f) && current.firework_rocket.positions[0].y < height-50) {
                            current.firework_rocket.collide(obj);
                        }
                        if(obj.firework_rocket.overlap(current.firework_rocket.positions[i].x + current.firework_rocket.orgX, current.firework_rocket.positions[i].y - (height - current.firework_rocket.orgY), f) && obj.firework_rocket.positions[0].y < height-50) {
                            current.firework_rocket.collide(obj);
                        }
                    }
                }
            
            }



            //checks for completely dead fireworks and removes them from the event
            boolean deadSparks = false;
            if(!this.fireworks.get(iter).firework_rocket.alive && this.fireworks.get(iter).sparks_generated) {
                for(int i = 0; i < (this.fireworks.get(iter).size)*2; i++){
                    if(!this.fireworks.get(iter).sparks[i].isAlive) {
                        deadSparks = true;
                    }
                    else {
                        deadSparks = false;
                    }
                }
                if(deadSparks) {
                    this.fireworks.remove(iter);
                    this.startFrames.remove(iter);
                }
            }
        }
        

        //updates crowd
        if(people.size() > 0) {
            for(Person p : people) {
                p.update(f);
            }
        }

        if(this.totalScore > 300) {
            for(int k = 0; k < int(random(1, 2)); k ++) {
                people.add(new Person(this));
            }
        }

        if(this.totalScore < 100) {
            if(this.people.size() > 10) {
                for(int i = 0; i < random(1, 10); i++) {
                    if(this.people.get(i).pos.x > width) {
                        this.people.remove(i);
                    }
                    else {
                        this.people.get(i).disappointed = true;
                    }
                }
            }
            else {
                for(int i = 0; i < this.people.size(); i++) {
                    this.people.get(i).disappointed = true;
                }
            }

        }

    }
}