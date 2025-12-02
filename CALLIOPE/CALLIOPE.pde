import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;
import g4p_controls.*;

String API_KEY;
WindowStage stage = WindowStage.Home;

void setup()
{
  createGUI();
    
  API_KEY = loadStrings("api_key.txt")[0];
  size(1000, 650);
  startButton.setVisible(true);
  infoButton.setVisible(true);
  backButton.setVisible(false);
  controlsWindow.setVisible(false);
  background(0, 0, 50);
  
  //Puts essay into words (split by spaces to preserve punctuation)
  words = new ArrayList<Word>();
  String[] wordStrings = split(essay, ' ');

  for (int i = 0; i < wordStrings.length; i++) {
    if (wordStrings[i].length() > 0) {  // Skip empty strings
      words.add(new Word(wordStrings[i], i));
    }
  }

  layoutWords();

  calculateScrollBounds();
}

void draw()
{
  background(0, 0, 50);
  if (stage == WindowStage.Home)
  {
    fill(255, 255, 255);
    textSize(100);
    textAlign(CENTER);
    text("CALLIOPE", width / 2, 200);
  }
  else if (stage == WindowStage.EssayHelp)
  {
    //get the base gui
    
    //essay viewing window
  }
  //println(stage);
  
  //Button will be in the GUI in the real project
  drawUnhighlightButton();

  //Draw the text display area (square/rectangle in center)
  float textAreaX = (CANVAS_WIDTH - TEXT_AREA_WIDTH) / 2;
  float textAreaY = (CANVAS_HEIGHT - TEXT_AREA_HEIGHT) / 2;

  fill(240);
  stroke(200);
  rect(textAreaX, textAreaY, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);

  //Set up text rendering
  fill(0);
  textSize(16);
  textAlign(LEFT, BASELINE);


  pushMatrix();

  //clip makes it so all words not in the text area are hidden.
  //The only way this is undone is with push and pop matrix
  //Push matrix saves everything before the clip, and pop matrix restores it back.
  clip(textAreaX, textAreaY, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);

  //Display all words with scroll offset
  for (Word w : words) {
    w.display(scrollY);
  }

  popMatrix();
}

/*
void setup() {
  size(1200, 800);

  //Puts essay into words (split by spaces to preserve punctuation)
  words = new ArrayList<Word>();
  String[] wordStrings = split(essay, ' ');

  for (int i = 0; i < wordStrings.length; i++) {
    if (wordStrings[i].length() > 0) {  // Skip empty strings
      words.add(new Word(wordStrings[i], i));
    }
  }

  layoutWords();

  calculateScrollBounds();
}

void draw() {
  background(255);

  //Button will be in the GUI in the real project
  drawUnhighlightButton();

  //Draw the text display area (square/rectangle in center)
  float textAreaX = (CANVAS_WIDTH - TEXT_AREA_WIDTH) / 2;
  float textAreaY = (CANVAS_HEIGHT - TEXT_AREA_HEIGHT) / 2;

  fill(240);
  stroke(200);
  rect(textAreaX, textAreaY, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);

  //Set up text rendering
  fill(0);
  textSize(16);
  textAlign(LEFT, BASELINE);


  pushMatrix();

  //clip makes it so all words not in the text area are hidden.
  //The only way this is undone is with push and pop matrix
  //Push matrix saves everything before the clip, and pop matrix restores it back.
  clip(textAreaX, textAreaY, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);

  //Display all words with scroll offset
  for (Word w : words) {
    w.display(scrollY);
  }

  popMatrix();
}
*/
