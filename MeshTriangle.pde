

class MeshTriangle {


  Mesh parent;
  MeshVertex a, b, c;
  int index;

  Vec3D centroid;
  Vec3D normal;
  

  //----------------------------------------------------------------------
  MeshTriangle(Mesh _parent, MeshVertex _a, MeshVertex _b, MeshVertex _c) {
    parent = _parent;
    a = _a;
    b = _b;
    c = _c;

    centroid = a.loc.add(b.loc).add(c.loc).scale(1f/3);
    normal = new Vec3D (0, 1, 0);

    index = parent.arrayOfMeshTriangles.size();
  }

  //----------------------------------------------------------------------

  void run() {
    displaySolid();
    displayWireframe();
  }

  
  //----------------------------------------------------------------------
  void updateNormal() {

    normal = (b.loc.sub(a.loc)).cross(c.loc.sub(a.loc));
    normal.normalize();
  }

  //----------------------------------------------------------------------
  void displayCentroid() {

    stroke(255, 0, 150);
    strokeWeight(2);
    point(centroid.x, centroid.y, centroid.z);
  }

  //----------------------------------------------------------------------
  void displayNormal() {

    Vec3D target = centroid.add(normal.scale(5));

    stroke(255);
    strokeWeight(1);
    line(centroid.x, centroid.y, centroid.z, target.x, target.y, target.z);
  }

  //----------------------------------------------------------------------
  void displaySolid() {

    fill(255);
    noStroke();
    beginShape();
    vertex(a.loc.x, a.loc.y, a.loc.z);
    vertex(b.loc.x, b.loc.y, b.loc.z);
    vertex(c.loc.x, c.loc.y, c.loc.z);
    endShape(CLOSE);
  }

  //----------------------------------------------------------------------
  void displayWireframe() {

    noFill();
    stroke(0,50);
    strokeWeight(1);
    beginShape();
    vertex(a.loc.x, a.loc.y, a.loc.z);
    vertex(b.loc.x, b.loc.y, b.loc.z);
    vertex(c.loc.x, c.loc.y, c.loc.z);
    endShape(CLOSE);
  }

  //----------------------------------------------------------------------
}

