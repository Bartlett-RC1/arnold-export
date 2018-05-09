

class Mesh {

  ArrayList arrayOfMeshVertices = new ArrayList();
  ArrayList arrayOfMeshTriangles = new ArrayList();



  //----------------------------------------------------------------------
  Mesh(String fileName, Vec3D offset, float scale) {

    importObj(fileName);

    for (int i =0; i<arrayOfMeshVertices.size (); i++) {
      MeshVertex m = (MeshVertex) arrayOfMeshVertices.get(i);
      m.loc.addSelf(offset);

      m.loc.scaleSelf(scale);
    }
  }

  //----------------------------------------------------------------------

  void run() {
    runMeshTriangles();
    runMeshVertices();
  }
  //----------------------------------------------------------------------

  void importObj(String fileName) {

    String file [] = loadStrings(fileName);

    //import vertices
    for (int i=0; i<file.length; i++) {

      String line[] = split(file[i], " ");

      if (line[0].equals("v")) {

        float x = float(line[1]);
        float y = float(line[2]);
        float z = float(line[3]);

        Vec3D vec = new Vec3D(x, y, z);

        MeshVertex v = new MeshVertex(this, vec);
        arrayOfMeshVertices.add(v);
      }
    }

    //import faces
    for (int i=0; i<file.length; i++) {

      String line[] = split(file[i], " ");

      if (line[0].equals("f")) {

        int a = int(line[1])-1;
        int b = int(line[2])-1;
        int c = int(line[3])-1;

        MeshVertex v1 = (MeshVertex) arrayOfMeshVertices.get(a);
        MeshVertex v2 = (MeshVertex) arrayOfMeshVertices.get(b);
        MeshVertex v3 = (MeshVertex) arrayOfMeshVertices.get(c);


        MeshTriangle t = new MeshTriangle(this, v1, v2, v3);
        arrayOfMeshTriangles.add(t);

        v1.arrayOfConnectedTriangles.add(t);
        v2.arrayOfConnectedTriangles.add(t);
        v3.arrayOfConnectedTriangles.add(t);
      }
    }

    //update vertex normals
    for (int i=0; i<arrayOfMeshVertices.size (); i++) {
      MeshVertex v = (MeshVertex) arrayOfMeshVertices.get(i);
      v.updateNormal();
    }
    
    //update face normals
    for (int i=0; i<arrayOfMeshTriangles.size (); i++) {
      MeshTriangle f = (MeshTriangle) arrayOfMeshTriangles.get(i);
      f.updateNormal();
    }
  }

  //----------------------------------------------------------------------
  void runMeshVertices() {

    for (int i =0; i<arrayOfMeshVertices.size (); i++) {
      MeshVertex m = (MeshVertex) arrayOfMeshVertices.get(i);
      m.run();
    }
  }

  //----------------------------------------------------------------------
  void runMeshTriangles() {

    for (int i =0; i<arrayOfMeshTriangles.size (); i++) {
      MeshTriangle f = (MeshTriangle) arrayOfMeshTriangles.get(i);
      f.run();
    }
  }
  //----------------------------------------------------------------------
}

