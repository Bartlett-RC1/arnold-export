

class MeshVertex {


  Mesh parent;
  Vec3D loc;

  Vec3D initialLoc;

  int index;


  Vec3D normal;

  ArrayList arrayOfConnectedTriangles = new ArrayList();


  //----------------------------------------------------------------------
  MeshVertex(Mesh _parent, Vec3D _loc) {

    parent = _parent;
    loc = _loc;

    initialLoc = loc.copy();

    normal = new Vec3D(0, 1, 0);

    index = parent.arrayOfMeshVertices.size();
  }

  //----------------------------------------------------------------------
  void run() {
    //display();
  }


  //----------------------------------------------------------------------
  void updateNormal() {


    Vec3D sum = new Vec3D();
    int numTriangles = 0;


    for (int i=0; i<arrayOfConnectedTriangles.size (); i++) {
      MeshTriangle t = (MeshTriangle) arrayOfConnectedTriangles.get(i);

      numTriangles++;
      sum.addSelf(t.normal);
    }

    normal = sum.scale(1f/numTriangles);


  }

  //----------------------------------------------------------------------
  void displayNormal() {
    Vec3D target = loc.add(normal.scale(5));

    stroke(255);
    strokeWeight(1);
    line(loc.x, loc.y, loc.z, target.x, target.y, target.z);
  }

  //----------------------------------------------------------------------
  void display() {
    stroke(255,0,0);
    strokeWeight(3);
    point(loc.x, loc.y, loc.z);
  }

  //----------------------------------------------------------------------
}

