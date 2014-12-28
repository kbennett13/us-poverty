import controlP5.*; // Library located at http://www.sojamo.de/libraries/controlP5/

ControlP5 cp5;
PGraphics pg;
PShape usa;
RadioButton view;
Slider year;
String file = "est95-13US-xls.tsv";
Data states;
int numCategories = 6;

void setup() {
  // set window size
  size(1200, 740);

  // import data  
  states = new Data(file);
  
  // ControlP5 instance
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Arial",16,true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont);
   
  // load map
  usa = loadShape("Blank_US_Map.svg");
  
  // add buffer for picking
  pg = createGraphics(1200,740);
  
  // add option to view all ages or under 18
  view = cp5.addRadioButton("view").setPosition(width-width/6,width/12).setSize(height/32,height/32);
  view.setNoneSelectedAllowed(false).addItem("All", 0).addItem("Children", 1);
  view.activate(0);
     
  for(Toggle t : view.getItems()) {
    t.captionLabel().setFont(font);
    t.captionLabel().style().moveMargin(-7,0,0,0);
    t.captionLabel().style().movePadding(7,0,0,5);
    t.captionLabel().style().backgroundWidth = 45;
    t.captionLabel().style().backgroundHeight = 13;
  }
  
  // add slider for years
  year = cp5.addSlider("year");
  year.captionLabel().setColor(color(0)).setFont(font);
  year.getValueLabel().setColor(color(255)).setFont(font);
  year.setPosition(width/24,height-100).setSize(900,height/20).setRange(1995,2013);
  year.setNumberOfTickMarks(19).snapToTickMarks(true);
}

void draw() {
  background(125);
  
  // draw the full map
  usa.disableStyle();
  fill(150);
  shape(usa);
  
  // draw the legend
  fill(255);
  rect(width-width/5,height/3,width/6,height/3); // legend
  fill(0);
  textSize(20);
  text("Legend",width-width/5+15,height/3+40);
  textSize(16);
  int rectHeight = 70;
  int textHeight = 85;
  for (int i = 0; i < numCategories; i++)
  {
    fill((i+1)*42,0,0);
    rect(width-width/5+15,height/3+rectHeight+i*30,15,15); //
    fill(0);
    if (i < numCategories - 1)
    {
      text("Less Than " + 5*(i+1) + "%",width-width/5+45,height/3+textHeight+i*30);
    }
    else
    {
      text(5*i + "% or Greater",width-width/5+45,height/3+textHeight+i*30);
    }
  }
  
  pg.beginDraw();
  for (int s = 1; s < states.getRowCount(); s++) // don't read labels
  {
    // get row
    String[] state_data = states.data[s];
    
    // get shape
    String name = state_data[0];
    PShape state = usa.getChild(name);
    
    pg.fill(0,5*s,0);
    
    pg.shape(state);
  }
  pg.endDraw();
  
  // get column  
  int all = (view.getValue() == 1) ? 1 : 0; // all or children?
  int column = ((int)year.getValue() - 1995)*2 + 1 + all;
  
  // draw each state with the appropriate fill
  for (int s = 1; s < states.getRowCount(); s++) // don't read labels
  {
    // get row
    String[] state_data = states.data[s];
    
    // get shape
    String name = state_data[0];
    PShape state = usa.getChild(name);
    
    // get cell
    float percent = parseFloat(state_data[column]);
    
    // determine fill color - brighter color means higher percentage
    int category = 0;
    
    for (int i = 1; i <= numCategories - 1; i++) // up to 25%
    {
      if (percent < i*5)
      {
        category = i;
        break;
      }
    }
    
    if (category == 0) // more than 25%
    {
      category = 6;
    }
    
    // draw state
    fill(category*42,0,0);
    shape(state);
  }
  
  int index = (int)green(pg.get(mouseX,mouseY))/5;
  if (index > 0)
  {
    textSize(14);
    fill(255);
    text(states.data[index][0], mouseX + 10, mouseY - 10);
    text(states.data[index][column] + "%", mouseX + 10, mouseY + 5);
  }
}

// makes slider display int instead of float
void year(int theValue) {
}
