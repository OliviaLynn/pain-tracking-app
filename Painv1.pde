
int clickX, clickY, x0, y0, winCount;
boolean tbox;
PImage img;
PImage history;
color defaultPainColor, painColor, white1;
color[] currentPainColor = {#fea3aa, #f8b88b, #baed91, #b2cefe, #f2a2e8}; //color array

int painLevel = -1;
boolean startedDrawing, inDrawingMode;
ArrayList linesX = new ArrayList();
ArrayList linesY = new ArrayList();
boolean reset, redraw;

String [] painTerms = {"flickering", "quivering", "pulsing", "throbbing", "beating" };
String userMed;
String medTime;

int tBoxX, tBoxY, tBoxWidth, tBoxHeight;

int btnWidth, btnHeight, btnY; 

int okX = 10;
int okY = 10;
int okWidth = 150;
int okHeight = 150;

int cancelX = 10;
int cancelY = 170;
int cancelWidth = 150; //used to be 100x100
int cancelHeight = 150;

int ellsize = 40;
int ellinc = 1;

void setup() {
  
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
    size(800, 1200);
  
  frame.setTitle("Pain Apps");
  winCount = 0;
  img = loadImage("edit-figure.jpg");
  image(img, 0, 0);
 

  
  showTitleLabel(); //displays title
  showHistory(); //show history button
  showMed(); //show medication button
  
  defaultPainColor = color(230, 80, 0);
  painColor = defaultPainColor;
  white1 = color(255,240,255);
  startedDrawing = false;
  inDrawingMode = false;
  
  tbox = false;
  
  tBoxX = width/2 - 225;
  tBoxY = height/2 - 300;
  tBoxWidth = 450;
  tBoxHeight = 450;
  btnWidth = tBoxWidth/5;
  btnHeight = btnWidth;
  btnY = tBoxY + 200;  
  stroke(100);
  smooth();
}

void draw() {
  

    if (mousePressed) {
      if (!tbox && !onCancelButton() && !onOkButton()){
          //drawLines();
          noStroke();
          fill(painColor);
          ellipse(pmouseX, pmouseY, ellsize, ellsize);
          inDrawingMode = true;
        }
    }
    ellsize = ellsize + ellinc;
    if(ellsize > 60) {
      ellinc--;
    } else if (ellsize < 20) {
      ellinc++;
    }
  
  if (inDrawingMode) {
    showCancelButton();
    showOkButton();
    showHistory();
    showMed();
 
  }
  
}

void keyPressed() {
  if (key == 'q') {
    winCount = 1;
    tbox = true;
  }
}

void mousePressed() {
  println(winCount);
  if (onCancelButton()){
      showCancelButton();
      doCancel();
      doReset();
  } else if (onOkButton()){
    winCount = 1;  
    tbox = true;
    showTBox();
  } 
  
  else if(onMed())
  {
    winCount = 1;
    showMedBox();
  } else if (winCount == 1) {
    painLevel = getScaleButton();
    if (painLevel > -1) {
      winCount = 2;
      showTBox();
    }
  } else if (winCount == 2) {  
    doReset();
  }
}

int getScaleButton() {
  if (tBoxX < mouseX && mouseX < tBoxX + tBoxWidth) {
    return 1 + (mouseX - tBoxX)/(btnWidth);
  }
  return -1;
} 

color colorScale(int i) {
  return color(100 + i*40,100 + i*15,100);
}

void makeWindowOneButton(int i) {
   fill(currentPainColor[i]);
   rect(tBoxX + i*btnWidth, btnY, btnWidth, btnHeight);
   fill(0,0,0);
   textSize(36);
   text(i+1, tBoxX + (i + 0.5)*btnWidth, tBoxY + 200 + btnHeight/2);
}

void showWindowOne() {
  int offsetY;
  fill(100,100,150);
  noStroke();
  textSize(32);
  text("How bad is your pain?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 5; i++) {
    makeWindowOneButton(i);
  }
}
void makeWindowTwoButton(int i, String s) {
  
   //fill(colorScale(i));
   fill(currentPainColor[i]);
   rect(tBoxX + 40, tBoxY + i*50 + 150, tBoxWidth-80, 40); // Vertically positioned by incrementing start point
   fill(255,255,255);
   textSize(18);
   text(s, tBoxX + 230, tBoxY + i*50 + 170);
}

void showWindowTwo() {
  String [] typeA = new String [5]; // Array of responses to display in each button
  typeA[0] = "Hot";
  typeA[1] = "Sharp";
  typeA[2] = "Cramping";
  typeA[3] = "Tiring";
  typeA[4] = "Numb";
  
  //int offsetY;
  fill(100,100,150);
  textSize(32);
  text("What does it feel like?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 5; i++) {
    makeWindowTwoButton(i, painTerms[i]);
  }
}


void makeWindowThreeButton(int i, String ansQ3) {
   //fill(colorScale(i));
    noStroke();
   fill(color(100 + i*40,100 + i*15,100));
   rect(tBoxX + 40, tBoxY + i*50 + 150, tBoxWidth-80, 40);
   fill(255,255,255);
   textSize(20);
   text(painTerms[i], tBoxX + 225, tBoxY + i*50 + 170);
  }

void showTBox() { //displays popup window
  stroke(100,100,150);
  strokeWeight(3);
  fill(#ffffff);
  rect(tBoxX, tBoxY, tBoxWidth, tBoxHeight);
  if (winCount == 1) { //question 1
    showWindowOne();
  } else if (winCount == 2) { //question 2
    showWindowTwo();
  }
}


void showMedBox() { //displays popup window
  stroke(100,100,150);
  strokeWeight(3);
  fill(#ffffff);
  rect(tBoxX, tBoxY, tBoxWidth, tBoxHeight);
  
  int offsetY;
  fill(100,100,150);
  noStroke();
  textSize(22);
  text("MEDICATION HISTORY \n", tBoxX + tBoxWidth/2, tBoxY + 100);
  textSize(18);
  text("Acetominophen", tBoxX + tBoxWidth/2, tBoxY + 120);
  text("Aspirin", tBoxX + tBoxWidth/2, tBoxY + 150);
   text("Ibuprofen", tBoxX + tBoxWidth/2, tBoxY + 180);
  
  
}

void drawLines() {
  if (startedDrawing) {
    stroke(painColor);
    strokeWeight(15);
    line(pmouseX, pmouseY, mouseX, mouseY);
    linesX.add(mouseX);
    linesY.add(mouseY);
  }
  else {
    startedDrawing = true;
    inDrawingMode = true;
  }
}

void redrawPainArea() {
  if (linesX.size() == 0) { 
    print("none");
    return; 
  }
  stroke(painColor);
  strokeWeight(15);
  int x0, x1, y0, y1;
  x0 = (int)linesX.get(0);
  y0 = (int)linesY.get(0);
  for (int i = 1; i < linesX.size(); i++) {
    x1 = x0;
    y1 = y0;
    x0 = (int)linesX.get(i);
    y0 = (int)linesY.get(i);
    line(x0, y0, x1, y1);
  }
}

void doReset() {
    tbox = false;
    winCount = 0;
    image(img, 0, 0);
    showTitleLabel();
    painColor = colorScale(painLevel - 1);
    redrawPainArea();
}

void doCancel() {
    linesX = new ArrayList();
    linesY = new ArrayList();
    painColor = defaultPainColor;
}

void showCancelButton() {
  stroke(100,100,150);
  strokeWeight(3);
  //noStroke();
  fill(#f8b88b); //before: fill(100,100,100) (for gray color)
  rect(cancelX, cancelY, cancelWidth, cancelHeight);
  fill(255,255,255);
  //textSize(72);
  textSize(105);
  text("\u2718", cancelX+cancelWidth/2, cancelY+cancelHeight/2-8);
}

void showOkButton() {
  //noStroke();
  stroke(100,100,150);
  strokeWeight(3);
  fill(#fea3aa);
  rect(okX, okY, okWidth, okHeight);
  fill(255,255,255);
  textSize(136);
  text("\u2713", okX+okWidth/2, okY+okHeight/2-8);
}

//new method to display title
void showTitleLabel()
{
  //noStroke();
  //fill(255, 255, 255);
  //rect(okX+600, okY, okWidth, okHeight);
  fill(0,0,0);
  textSize(50);
  text("PAIN APPS", (okX+okWidth/2)+570, (okY+okHeight/2)-50);
  
}

void showHistory()
{
  stroke(100,100,150);
  strokeWeight(3);
  //noStroke();
  fill(#baed91);
  rect(okX+668, okY+65, okWidth/1.5, okHeight/1.5);
  
  fill(255,255,255);
  textSize(30);
  text("STATS", (okX+okWidth/2)+643, (okY+okHeight/2)+35);
}

void showMed()
{
  stroke(100,100,150);
  strokeWeight(3);
  //noStroke();
  fill(#b2cefe);
  rect(okX+668, okY+175, okWidth/1.5, okHeight/1.5);
  fill(255,255,255);
  textSize(35);
  text("MEDS", (okX+okWidth/2)+643, (okY+okHeight/2)+145);
}


boolean onOkButton() {
  if (inDrawingMode && okX < mouseX && mouseX < okX+okWidth && okY < mouseY && mouseY < okY+okHeight) {
    return true;
  }
  return false;
}

boolean onCancelButton() {
  if (inDrawingMode && cancelX < mouseX && mouseX < cancelX+cancelWidth && cancelY < mouseY && mouseY < cancelY+cancelHeight) {
    return true;
  }
  return false;
}

boolean onMed()
{
  if(inDrawingMode && okX+668 < mouseX && mouseX < (okX+668)+(okWidth/1.5) && okY+175 < mouseY && mouseY < (okY+175)+(okHeight/1.5))
  {
    return true;
  }
  return false;
}