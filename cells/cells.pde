//User control
int cellNums = 100; //Number of cells on one side of the grid
int cutRate = 10; //rate that an individual tree is being cut down in
int buildingNums = 15; //Number of buildings on the grid (the more buildings, the more people cutting down trees) (note: max amount of buildings = cellNums^2 / 2)
int treeGrowthProbability = 100; //The chance of a new tree growing next to another existing tree
int animationSpeed = 100; //Speed of the animation

//Do not change
int cellSize;
int treeLoggingProbability = 5*buildingNums;
PFont myFont;
int pollutionLevel;
int totalTrees = 0;
int totalCut = 0;
int currentTotalTrees;
boolean paused = false;
int treeSum;

CellClass[][] currentCells = new CellClass[cellNums][cellNums];
CellClass[][] nextCells = new CellClass[cellNums][cellNums];


void setup() {
    frameRate(animationSpeed);
    cellSize = int((width-300)/cellNums);
    size(1100, 800);
    myFont = createFont("Arial", 24);
    textFont( myFont );
    for(int i = 0; i < currentCells.length; i++) {
        int y = cellSize*i;
        for(int j = 0; j < currentCells.length; j++) {
            int x = cellSize*j;
            if(j > int((currentCells.length)/2) - 1) {
                currentCells[i][j] = new CellClass("Land", j, i);
                currentCells[i][j] = new CellClass("Tree", int(random(1, 300)), int(random(1, 5)), j, i);
                totalTrees += 1;
            }
            else {
                currentCells[i][j] = new CellClass("Land", j, i);
            }
        }
    }

    int k = 0;
    int tx, ty;
    while(k < buildingNums) {
        tx = int(random(0, int(currentCells.length/2)));
        ty = int(random(0, currentCells.length));
        if(currentCells[ty][tx].type == "Land") {
            currentCells[ty][tx] = new CellClass("Building", ty, tx);
            k += 1;
        }
    }
    currentToNext();
}
void nextGen() {
    nextToCurrent();
    drawCells();
    printinfo();
    landGrowthCheck();
    checkToCutTrees();
    checkDeadTrees();
}

int frames = 0;
void draw() {
    background(0);
    nextGen();
}


void printinfo() {
    fill(255);
    text("Frames: " + str(frames), width - 250, height/10);
    text("Current Trees: " + str(currentTotalTrees), width - 250, 2*height/10);
    text("Total Trees: " + str(totalTrees), width - 250, 3*height/10);
    text("Total Cut: " + str(totalCut), width - 250, 4*height/10);
    if(treeSum != 0) {
        //pollutionLevel = int((1500*buildingNums)/currentTotalTrees);
        pollutionLevel = int((15*buildingNums*buildingNums)/(treeSum/300.0));
        //println(treeSum/300.0);
        if(pollutionLevel < 50) {
            fill(0, 255, 0);
            text("Air Pollution Level", width-250, 5*height/10);
            text(pollutionLevel + ": Good", width-250, 5.5*height/10);
        }
        else if(pollutionLevel < 100) {
            fill(255, 255, 0);
            text("Air Pollution Level", width-250, 5*height/10);
            text(pollutionLevel + ": Moderate", width-250, 5.5*height/10);
        }
        else if(pollutionLevel < 150) {
            fill(255, 165, 0);
            text("Air Pollution Level", width-250, 5*height/10);
            text(pollutionLevel + ": Slightly Unhealthy", width-250, 5.5*height/10);
        }
        else if(pollutionLevel < 200) {
            fill(255, 0, 0);
            text("Air Pollution Level", width-250, 5*height/10);
            text(pollutionLevel + ": Unhealthy", width-250, 5.5*height/10);
        }
        else if(pollutionLevel < 300) {
            fill(128, 0, 128);
            text("Air Pollution Level", width-250, 5*height/10);
            text(pollutionLevel + ": Very Unhealthy", width-250, 5.5*height/10);
        }
        else if(pollutionLevel < 500) {
            fill(128, 0, 0);
            text("Air Pollution Level", width-250, 5*height/10);
            text(pollutionLevel + ": Hazerdous", width-250, 5.5*height/10);
        }
        else {
            fill(128, 0, 0);
            text("Air Pollution Level", width-250, 5*height/10);
            text("UNMEASURABLE", width-250, 5.5*height/10);
        }
    }
    else {
        fill(128, 0, 0);
        text("Air Pollution Level", width-250, 5*height/10);
        text("UNMEASURABLE", width-250, 5.5*height/10);
    }

    fill(255, 255, 255);
    text("Press space to\npause/play", width-250, 8*height/10);

    frames += 1;
}

void keyPressed() {
    if(keyCode == 32) {
        if(paused) {
            loop();
        }
        else {
            noLoop();
        }
        paused = !paused;
    }
}


void drawCells() {
    CellClass currentObj;
    String currentType;
    currentTotalTrees = 0;
    treeSum = 0;
    for(int i = 0; i < currentCells.length; i++) {
        int y = cellSize*i;
        for(int j = 0; j < currentCells.length; j++) {
            int x = cellSize*j;
            currentObj = currentCells[i][j];
            currentType = currentObj.type;
            if(currentType == "Tree") {
                //largest tree would be (0, 51, 0)
                fill(0, int(255 - currentObj.tree.size*(0.68)), 0);
                treeSum += currentObj.tree.size;
                nextCells[i][j].update();
                currentTotalTrees += 1;
            }
            else if(currentType == "Building") {
                fill(0, 0, 255);
            }
            else {
                fill(255, 255, 0);
            }

            rect(x, y, cellSize, cellSize);
        }
    }
}

void landGrowthCheck() {
    for(int i = 0; i < currentCells.length; i++) {
        for(int j = 0; j < currentCells.length; j++) {
            if(currentCells[i][j].type == "Land") {
                int treeNeighbors = currentCells[i][j].getTreeNeighbors();
                boolean req1, req2, req3, req4;
                try {
                    req1 = (currentCells[i][j+1].type == "Tree");
                }
                catch(Exception e) {
                    req1 = true;
                }

                try {
                    req2 = (currentCells[i-1][j].type == "Tree");
                }
                catch(Exception e) {
                    req2 = true;
                }
                try {
                    req3 = (currentCells[i+1][j].type == "Tree");
                }
                catch(Exception e) {
                    req3 = true;
                }
                try {
                    req4 = (currentCells[i][j-1].type == "Tree");
                }
                catch(Exception e) {
                    req4 = true;
                }

                if(treeGrowthProbability == 0) {
                    continue;
                }
                else if(random(0, int(100/treeGrowthProbability * 4825 + 175)) < treeNeighbors*12.5 && (req1 || req2 || req3 || req4)) {
                        nextCells[i][j] = new CellClass("Tree", 1, int(random(1, 5)), j, i);
                        totalTrees += 1;
                }
                else {
                    continue;
                }
            }
        }
    }
}

void checkToCutTrees() {
    for(int i = 0; i < currentCells.length; i++) {
        for(int j = 0; j < currentCells.length; j++) {
            if(currentCells[i][j].type == "Tree") {
                int loggingPossibility = currentCells[i][j].cutDownProbability();
                if(treeLoggingProbability == 0) {
                    continue;
                }
                else if(random(1, int(100/treeLoggingProbability * 10000)) < loggingPossibility*10) {
                    nextCells[i][j].startCutting();
                }
                else {
                    continue;
                }
            }
        }
    }
}

void checkDeadTrees() {
    for(int i = 0; i < currentCells.length; i++) {
        for(int j = 0; j < currentCells.length; j++) {
            if(currentCells[i][j].type == "Tree") {
                if(currentCells[i][j].tree.size < 1) {
                    nextCells[i][j] = new CellClass("Land", j, i);
                    totalCut += 1;
                }
            }
        }
    }
}


void currentToNext() {
    for(int i = 0; i < currentCells.length; i++) {
        for(int j = 0; j < currentCells[i].length; j++) {
            nextCells[i][j] = currentCells[i][j]; 
        }
    }
}
void nextToCurrent() {
    for(int i = 0; i < currentCells.length; i++) {
        for(int j = 0; j < currentCells[i].length; j++) {
            currentCells[i][j] = nextCells[i][j]; 
        }
    }
}