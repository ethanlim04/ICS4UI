class Tree {
    int size, growthSpeed;
    Tree(int size, int growthSpeed) {
        this.size = size;
        this.growthSpeed = growthSpeed;
    }
}

class CellClass {
    Tree tree;
    String type;
    int x, y;
    boolean cutting = false;
    CellClass(String objType, int x, int y) {
        this.type = objType;
        this.x = x;
        this.y = y;
    }
    CellClass(String objType, int size, int growthSpeed, int x, int y) {
        this.type = objType;
        this.tree = new Tree(size, growthSpeed);
        this.x = x;
        this.y = y;
    }

    int getTreeNeighbors() {
        int count = 0;
        int edgeCase = 0;
        for(int i = this.y -1; i < this.y +2; i++) {
            for(int j = this.x -1; j < this.x +2; j++) {
                //println(i, j);
                try {
                    if(currentCells[i][j].type == "Tree") {
                        count += 1;
                    }
                    else {
                        continue;
                    }
                }
                //As the forest extends beyond the screen, some trees have neighbors that do not show in the frame
                catch (Exception e) {
                    edgeCase += 1;
                }
            }
        }
        if(this.type == "Tree") {
            return count-1+edgeCase;
        }
        else {
            return count;
        }
    }

    int getBuildingNeighbors() {
        int count = 0;
        int edgeCase = 0;
        for(int i = this.y -1; i < this.y +2; i++) {
            for(int j = this.x -1; j < this.x +2; j++) {
                try {
                    if(currentCells[i][j].type == "Building") {
                        count += 1;
                    }
                    else {
                        continue;
                    }
                }
                catch (Exception e) {
                    continue;
                }
            }
        }
        return count;
    }

    int cutDownProbability() {
        int treeNeighbors = this.getTreeNeighbors();
        int onEdge = 0;
        try {
            onEdge = 1;
            for(int t = 1; t < this.x; t++){
                if(currentCells[this.y][this.x - t].type == "Tree") {
                    onEdge = 0;
                }
            }
        }
        //If the forest spreads to the other side of the city
        catch (Exception e) {
            onEdge = 1;
        }

        if(this.getBuildingNeighbors() > 0) {
            onEdge = 1;
        }
        //max size = 300
        //max probability = 100
        //onEdge = 1;
        return (int(onEdge*(8-treeNeighbors)*(this.tree.size)/18));
    }

    void update() {
        if(this.tree.size < 300 && !cutting) {
            this.tree.size += this.tree.growthSpeed;
        }
        if(this.tree.size > 300 && !cutting) {
            this.tree.size = 300;
        }
        if(cutting && this.tree.size > 0){
            this.tree.size -= cutRate;
        }
        if(cutting && this.tree.size < 0){
            this.tree.size = 0;
        }
    }

    void startCutting() {
        cutting = true;
    }
}

