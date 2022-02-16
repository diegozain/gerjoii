
// create model parameters for gerjoii
//
// see gerjoii-figs.pdf for done examples.

/*
// --------------------------
// relative permitivitty [ ]
// --------------------------
String name = "eps-snow.png";
//int[] bg = {220,0,0};
// layers
int[] red_layer   = {30,50,45,25,18,20};
int[] green_layer = {0,0,0,0,0,0};
*/
//*
// -------------------
// conductivity [S/m]
// -------------------
String name = "sig-snow.png";
int[] bg = {0,250,0};
// layers
int[] red_layer = {0,0,0,0,0,0};
int[] green_layer = {30,50,45,25,18,20};
//*/

void setup() {
  size(1079, 360);
  // randomSeed(0);
  noStroke();
  noSmooth();
  
  // -----------------------------------
  // ground
  // -----------------------------------
  
  // bg
  //
  background(red_layer[0],green_layer[0],0);
  
  // layer 5
  //
  fill(red_layer[5],green_layer[5],0);
  beginShape();
  curveVertex(-1.5*width, 0.8*height);
  curveVertex(-1.5*width, -0.5*height);
  curveVertex(1.5*width, -0.5*height);
  curveVertex(1.5*width, 0.8*height);
  curveVertex(-1.5*width, 0.8*height);
  curveVertex(-1.5*width, 0.8*height);
  endShape();
  // layer 4
  //
  fill(red_layer[4],green_layer[4],0);
  beginShape();
  curveVertex(-1.5*width, 0.8*height);
  curveVertex(-1.5*width, -0.5*height);
  curveVertex(1.5*width, -0.5*height);
  curveVertex(1.5*width, 0.9*height);
  curveVertex(0.3*width, 0.7*height);
  curveVertex(-1.5*width, 0.8*height);
  curveVertex(-1.5*width, 0.8*height);
  endShape();
  // layer 3
  //
  fill(red_layer[3],green_layer[3],0);
  beginShape();
  curveVertex(-1.5*width, 0.6*height); //
  curveVertex(-1.5*width, -0.5*height);
  curveVertex(1.5*width, -0.5*height);
  curveVertex(1.5*width, 0.7*height);  //
  curveVertex(0.3*width, 0.5*height);  //
  curveVertex(-1.5*width, 0.6*height);
  curveVertex(-1.5*width, 0.6*height);
  endShape();
  // layer 2
  //
  fill(red_layer[2],green_layer[2],0);
  beginShape();
  curveVertex(-1.5*width, 0.2*height); //
  curveVertex(-1.5*width, -0.5*height);
  curveVertex(1.5*width, -0.5*height);
  curveVertex(1.5*width, 0.5*height);  //
  curveVertex(0.3*width, 0.3*height);  //
  curveVertex(-1.5*width, 0.2*height);
  curveVertex(-1.5*width, 0.2*height);
  endShape();
  // layer 1
  //
  fill(red_layer[1],green_layer[1],0);
  beginShape();
  curveVertex(-1.5*width, 0.1*height);
  curveVertex(-1.5*width, -0.5*height);
  curveVertex(1.5*width, -0.5*height);
  curveVertex(1.5*width, 0.2*height);
  curveVertex(0.3*width, 0.1*height);
  curveVertex(-1.5*width, 0.1*height);
  curveVertex(-1.5*width, 0.1*height);
  endShape();
  // -------------------------------------
  // save
  // -------------------------------------
  save(name);
}

void draw() {
}