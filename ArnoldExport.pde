
import toxi.geom.*;
import peasy.*;

PeasyCam cam;

Mesh dude;

ArrayList arrayOfPoints = new ArrayList();
ArrayList arrayOfLines = new ArrayList();

//---------------------------------------------------------------------------------------------------

void setup() {
  size(1024, 768, P3D);
  perspective(1, float(width)/float(height), 0.001, 10000);
  cam = new PeasyCam(this, 100);
  dude = new Mesh("data/dude.obj", new Vec3D(), 50);
  createPoints();
  createLines();
}

//---------------------------------------------------------------------------------------------------

void draw() {
  background(0);
  dude.run();
  runPoints();
  runLines();
}

//---------------------------------------------------------------------------------------------------

void createPoints() {
  for (int i=0; i<5000; i++) {
    Vec3D v = new Vec3D(random(-100, 100), random(-100, 100), random(-100, 100));
    Point p = new Point(v);
    arrayOfPoints.add(p);
  }
}

//---------------------------------------------------------------------------------------------------

void runPoints() {

  for (int i =0; i<arrayOfPoints.size (); i++) {
    Point p = (Point) arrayOfPoints.get(i);
    p.run();
  }
}

//---------------------------------------------------------------------------------------------------

void createLines() {
  for (int i=0; i<1000; i++) {
    Vec3D a = new Vec3D (random(-100, 100), random(-100, 100), random(-100, 100));
    Vec3D b = new Vec3D (random(-100, 100), random(-100, 100), random(-100, 100));

    Line l = new Line(a, b);
    arrayOfLines.add(l);
  }
}

//---------------------------------------------------------------------------------------------------

void runLines() {

  for (int i=0; i<arrayOfLines.size (); i++) {
    Line l = (Line) arrayOfLines.get(i);
    l.run();
  }
}

//---------------------------------------------------------------------------------------------------

void exportArnoldPoints() {


  float pointRadius = 1.5;

  String imageOutput = "c:/users/daghan/desktop/arnoldPoints." + frameCount + ".tif";
  PrintWriter output = createWriter("data/arnoldPoints." + frameCount + ".ass");

  output.println("options { AA_samples 4 xres 1920 yres 1080 GI_diffuse_samples 3 GI_diffuse_depth 1 shader_gamma 2.2 light_gamma 2.2 texture_gamma 2.2 camera persp outputs \"RGBA RGBA filter testrender\"}");
  output.println("points { name particles points " + arrayOfPoints.size() + " 1 POINT");
  for (int i=0; i<arrayOfPoints.size (); i++) {
    Point a =(Point) arrayOfPoints.get(i);
    output.println(a.loc.x+" "+a.loc.y+" "+a.loc.z);
  }
  output.println("radius " + pointRadius + " mode \"sphere\" shader \"aiAmbientOcclusion1\" opaque on }");



  output.println("ambient_occlusion { name aiAmbientOcclusion1 samples 3 spread 1 falloff 0 black 0 0 0 white 1 1 1 invert_normals off opacity 1 1 1 }"); 
  output.println("gaussian_filter { name filter width 2 }"); 
  output.println("driver_tiff { name testrender filename " + imageOutput + " gamma 2.2 }"); 
  output.println("persp_camera { name persp position 0 -400 260 look_at 0 0 0 up 0 1 0 fov 45 }"); 



  output.flush();
  output.close();

  println("ARNOLD POINTS EXPORTED!");
}


//---------------------------------------------------------------------------------------------------

void exportArnoldPointsCustom() { 

  //exports with different color and radius for each point

  float pointRadius = 1.5;

  String imageOutput = "c:/users/daghan/desktop/arnoldPointsCustom." + frameCount + ".tif";
  PrintWriter output = createWriter("data/arnoldPointsCustom." + frameCount + ".ass");

  output.println("options { AA_samples 4 xres 1920 yres 1080 GI_diffuse_samples 3 GI_diffuse_depth 1 shader_gamma 2.2 light_gamma 2.2 texture_gamma 2.2 camera persp outputs \"RGBA RGBA filter testrender\"}");
  
  for (int i=0; i<arrayOfPoints.size (); i++) {
    output.println("points { name point" + i + " points 1 1 POINT");
    Point a =(Point) arrayOfPoints.get(i);
    output.println(a.loc.x+" "+a.loc.y+" "+a.loc.z);
    output.println("radius " + a.radius + " mode \"sphere\" shader \"aiAmbientOcclusion" + i + "\" opaque on }");
  }



  for (int i=0; i<arrayOfPoints.size (); i++) {
    Point a =(Point) arrayOfPoints.get(i);

    float colR = a.colR/255.0;
    float colG = a.colG/255.0;
    float colB = a.colB/255.0;

    output.println("ambient_occlusion { name aiAmbientOcclusion" + i + " samples 3 spread 1 falloff 0 black 0 0 0 white " + colR + " " + colG + " " + colB + " invert_normals off opacity 1 1 1 }");
  }



  output.println("gaussian_filter { name filter width 2 }"); 
  output.println("driver_tiff { name testrender filename " + imageOutput + " gamma 2.2 }"); 
  output.println("persp_camera { name persp position 0 -400 260 look_at 0 0 0 up 0 1 0 fov 45 }"); 



  output.flush();
  output.close();

  println("ARNOLD POINTS CUSTOM EXPORTED!");
}


//---------------------------------------------------------------------------------------------------
void exportArnoldLines() {


  float pipeThickness = 0.1;

  String imageOutput = "c:/users/daghan/desktop/arnoldLines." + frameCount + ".tif";
  PrintWriter output = createWriter("data/arnoldLines." + frameCount + ".ass");


  output.println("options { AA_samples 4 xres 1920 yres 1080 GI_diffuse_samples 3 GI_diffuse_depth 1 shader_gamma 2.2 light_gamma 2.2 texture_gamma 2.2 camera persp outputs \"RGBA RGBA filter testrender\" }"); 


  //---- optional - creates a ground plane
  float groundX = 200;
  float groundY = 200;
  output.println("polymesh { name ground nsides 1 1 BYTE 4 vidxs 4 1 UINT 0 1 2 3 vlist 4 1 POINT 0 0 0 " + (groundX) + " 0 0 " + (groundX) + " " + (groundY) + " 0 0 " + (groundY) + " 0 shader \"aiAmbientOcclusion1\" }"); 
  //---- optional - ground plane ends


  for (int i=0; i<arrayOfLines.size (); i++) {
    Line l = (Line) arrayOfLines.get(i); 
    output.println("curves { name line" + i + " basis linear num_points 2 points 2 1 POINT"); 
    output.println(l.start.x + " " + l.start.y + " " + l.start.z); 
    output.println(l.end.x + " " + l.end.y + " " + l.end.z); 
    output.println("radius " + pipeThickness + " mode thick shader \"aiAmbientOcclusion1\" opaque on }");
  }

  output.println("ambient_occlusion { name aiAmbientOcclusion1 samples 3 spread 1 falloff 0 black 0 0 0 white 1 1 1 invert_normals off opacity 1 1 1 }"); 
  output.println("gaussian_filter { name filter width 2 }"); 
  output.println("driver_tiff { name testrender filename " + imageOutput + " gamma 2.2 }"); 
  output.println("persp_camera { name persp position 0 -400 260 look_at 0 0 0 up 0 1 0 fov 45 }"); 

  output.flush(); 
  output.close(); 

  println("ARNOLD LINES EXPORTED!");
}

//---------------------------------------------------------------------------------------------------
void exportArnoldTriangles() {


  String imageOutput = "c:/users/daghan/desktop/arnoldTriangles." + frameCount + ".tif";
  PrintWriter output = createWriter("data/arnoldTriangles." + frameCount + ".ass");


  output.println("options { AA_samples 4 xres 1920 yres 1080 GI_diffuse_samples 3 GI_diffuse_depth 1 shader_gamma 2.2 light_gamma 2.2 texture_gamma 2.2 camera persp outputs \"RGBA RGBA filter testrender\" }"); 


  for (int i=0; i<dude.arrayOfMeshTriangles.size (); i++) {
    MeshTriangle t = (MeshTriangle) dude.arrayOfMeshTriangles.get(i);
    output.println("polymesh { name triangle" + i + " nsides 1 1 BYTE 3 vidxs 3 1 UINT 0 1 2 vlist 3 1 POINT " + t.a.loc.x + " " + t.a.loc.y + " " + t.a.loc.z + " " + t.b.loc.x + " " + t.b.loc.y + " " + t.b.loc.z + " " + t.c.loc.x + " " + t.c.loc.y + " " + t.c.loc.z + " shader \"aiAmbientOcclusion1\" }");
  }

  output.println("ambient_occlusion { name aiAmbientOcclusion1 samples 3 spread 1 falloff 0 black 0 0 0 white 1 1 1 invert_normals off opacity 1 1 1 }"); 
  output.println("gaussian_filter { name filter width 2 }"); 
  output.println("driver_tiff { name testrender filename " + imageOutput + " gamma 2.2 }"); 
  output.println("persp_camera { name persp position 0 -400 260 look_at 0 0 0 up 0 1 0 fov 45 }"); 

  output.flush(); 
  output.close(); 

  println("ARNOLD TRIANGLES EXPORTED!");
}

//---------------------------------------------------------------------------------------------------


void keyPressed() {

  if (key == '1') {
    exportArnoldPoints();
  }
  if (key == '2') {
    exportArnoldLines();
  }
  if (key == '3') {
    exportArnoldTriangles();
  }
  if (key == '4') {
    exportArnoldPointsCustom();
  }
}

//---------------------------------------------------------------------------------------------------

