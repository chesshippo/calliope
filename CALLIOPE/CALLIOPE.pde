import g4p_controls.*;

final int CANVAS_WIDTH = 1000;
final int CANVAS_HEIGHT = 650;
final int TEXT_POSITION_X = 50;
final int TEXT_POSITION_Y = 100;
final int TEXT_AREA_WIDTH = 600;
final int TEXT_AREA_HEIGHT = 400;
final int TEXT_MARGIN = 20;
final int LINE_HEIGHT = 30;
final int WORD_SPACING = 10;
final int SCROLL_SPEED = 5;
final int UNHIGHLIGHT_BUTTON_SIZE = 30;
final color HIGHLIGHT_COLOR = color(173, 216, 250, 100);
final color YELLOW_HIGHLIGHT = color(255, 255, 0);
final color GREEN_HIGHLIGHT = color(0, 255, 0);

ArrayList<String> dictionary = new ArrayList();
int FEEDBACK_PANEL_X = TEXT_POSITION_X + TEXT_AREA_WIDTH + 20;
int FEEDBACK_PANEL_Y = TEXT_POSITION_Y;
int FEEDBACK_PANEL_WIDTH = CANVAS_WIDTH - FEEDBACK_PANEL_X - TEXT_POSITION_X;
int FEEDBACK_PANEL_HEIGHT = TEXT_AREA_HEIGHT;
int FEEDBACK_MARGIN = 15;

ArrayList<Character> punctuation = new ArrayList();


String highlighted = "";
String geminiResponse = "";

String essay;

ArrayList<Word> words = new ArrayList();
float scrollY = 0;
float minScrollY = 0;
float maxScrollY = 1000;
float feedbackScrollY = 0;
float minFeedbackScrollY = 0;
float maxFeedbackScrollY = 0;
float feedbackContentHeight = 0;

Integer firstSelectedWordIndex = null;
String API_KEY;
WindowStage stage = WindowStage.Home;


void setup() {
  createGUI();
  size(1000, 650);
  
  API_KEY = loadStrings("api_key.txt")[0].trim();
  SetupSpellcheck();
  PutEssayIntoWords();
  
  layoutWords();
  
  calculateScrollBounds();
  
  
  controlsWindow.setVisible(false);
  backButton.setVisible(false);
  backButton.setVisible(false);
  startButton.setVisible(true);
  infoButton.setVisible(true);
  manualDownloadButton.setVisible(false);
  downloadLabel.setVisible(false);
  
  
  
  //characters to skip so it doesnt confuse things when comparing words in spellcheck and highglighting functions
  punctuation.add(':');
  punctuation.add('\"');
  punctuation.add('[');
  punctuation.add(']');
  punctuation.add('(');
  punctuation.add(')');
  punctuation.add('.');
  punctuation.add('?');
  punctuation.add(',');
  punctuation.add('\'');
  punctuation.add('!');
  punctuation.add(';');
  punctuation.add('@');
  punctuation.add('\\');
  punctuation.add('/');
  punctuation.add('’');
  punctuation.add('\'');
  punctuation.add('“');
  punctuation.add('”');
  punctuation.add('0');
  punctuation.add('1');
  punctuation.add('2');
  punctuation.add('3');
  punctuation.add('4');
  punctuation.add('5');
  punctuation.add('6');
  punctuation.add('7');
  punctuation.add('8');
  punctuation.add('9');
  punctuation.add(' ');
}

void draw()
{
  if (stage == WindowStage.EssayHelp)
  {
    drawEditingScreen();
  }
  else if (stage == WindowStage.Home)
  {
    DrawHomeScreen();
  }
  else if (stage == WindowStage.Info)
  {
    DrawInfoScreen();
  }
}

void DrawHomeScreen()
{
  background(0, 0, 50);
  textAlign(CENTER);
  textSize(100);
  fill(255);
  text("CALLIOPE", width / 2, 250);
}

void DrawInfoScreen()
{
  
  background(0, 0, 50);
  
  //info screen
  textAlign(CENTER);
  
  textSize(60);
  text("INFO", 500, 100);
  
  textSize(20);
  text("Welcome to Calliope, the all-in-one essay helper!", 500, 200);
  text("To get started, click start and\nenter the filepath to your essay\nin the controls window, and hit refresh", 500, 250);
  text("For more details, see the user manual:", 500, 350);
  textSize(30);
  text("IMPORTANT NOTES:", 500, 400);
  
  textSize(20);
  text("- Do not spam buttons, as it can cause crashes", 500, 450);
  text("- Only text files may be used to load essays into the program", 500, 480);
  text("- Calliope can make mistakes. Double check important information.", 500, 510);
  
  
  
}

void drawEditingScreen() {
  background(0, 0, 50);
  
  fill(240);
  stroke(200);
  rect(TEXT_POSITION_X, TEXT_POSITION_Y, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);
  
  fill(250);
  stroke(200);
  rect(FEEDBACK_PANEL_X, FEEDBACK_PANEL_Y, FEEDBACK_PANEL_WIDTH, FEEDBACK_PANEL_HEIGHT);
  
  fill(50);
  textSize(18);
  textAlign(LEFT, TOP);
  text("Calliope's Thoughts", FEEDBACK_PANEL_X + FEEDBACK_MARGIN, FEEDBACK_PANEL_Y + FEEDBACK_MARGIN);
  
  if (geminiResponse.length() > 0) {
    pushMatrix();
    
    clip(FEEDBACK_PANEL_X, FEEDBACK_PANEL_Y, FEEDBACK_PANEL_WIDTH, FEEDBACK_PANEL_HEIGHT);
    
    fill(30);
    textSize(14);
    textAlign(LEFT, TOP);
    
    float textX = FEEDBACK_PANEL_X + FEEDBACK_MARGIN;
    float baseTextY = FEEDBACK_PANEL_Y + FEEDBACK_MARGIN + 30;
    float textY = baseTextY + feedbackScrollY;
    float textWidth = FEEDBACK_PANEL_WIDTH - (FEEDBACK_MARGIN * 2);
    
    String cleanResponse = geminiResponse;
    cleanResponse = cleanResponse.replace("\n", " ").replace("\r", " ").replace("\t", " ");
    String[] responseWords = split(cleanResponse, ' ');
    float currentX = textX;
    float currentY = textY;
    float lineHeight = 20;
    
    for (String word : responseWords) {
      if (word.length() == 0) continue;
      
      String wordWithSpace = word + " ";
      float wordWidth = textWidth(wordWithSpace);
      
      if (currentX + wordWidth > textX + textWidth && currentX > textX) {
        currentY += lineHeight;
        currentX = textX;
      }
      
      text(word + " ", currentX, currentY);
      currentX += wordWidth;
    }
    
    popMatrix();
  } else {
    fill(150);
    textSize(12);
    textAlign(LEFT, TOP);
    text("Highlight text and ask Calliope\nfor feedback...", 
         FEEDBACK_PANEL_X + FEEDBACK_MARGIN, 
         FEEDBACK_PANEL_Y + FEEDBACK_MARGIN + 30);
  }
  
  fill(0);
  textSize(16);
  textAlign(LEFT, BASELINE);
  
  pushMatrix();
  
  clip(TEXT_POSITION_X, TEXT_POSITION_Y, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);
  
  for (Word w : words) {
    w.display(scrollY);
  }
  
  popMatrix();
 
  noClip();
}

void layoutWords() {
  
  float currentX = TEXT_POSITION_X + TEXT_MARGIN;
  float currentY = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  int currentLine = 0;
  
  textSize(16);
  
  for (Word w : words) {
    float wordWidth = textWidth(w.wordText + " ");
    
    if (currentX + wordWidth > TEXT_POSITION_X + TEXT_AREA_WIDTH - TEXT_MARGIN) {
      currentLine++;
      currentY += LINE_HEIGHT;
      currentX = TEXT_POSITION_X + TEXT_MARGIN;
    }
    
    w.lineNumber = currentLine;
    w.xPosition = currentX;
    w.yPosition = currentY;
    
    currentX += wordWidth + WORD_SPACING;
  }
}

void calculateScrollBounds() {
  if (words.size() == 0) {
    minScrollY = 0;
    maxScrollY = 0;
    return;
  }
  
 
  float topMargin = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  
  float bottomY = 0;
  for (Word w : words) {
    if (w.yPosition > bottomY) {
      bottomY = w.yPosition;
    }
  }
  
  float contentHeight = bottomY - topMargin + LINE_HEIGHT;
  float visibleHeight = TEXT_AREA_HEIGHT - (TEXT_MARGIN * 2);
  
  if (contentHeight <= visibleHeight) {
    minScrollY = 0;
    maxScrollY = 0;
  } else {
    minScrollY = 0;
    maxScrollY = visibleHeight - contentHeight;
  }
}


int getWordAtMousePosition() {

  
  if (mouseX < TEXT_POSITION_X || mouseX > TEXT_POSITION_X + TEXT_AREA_WIDTH ||
      mouseY < TEXT_POSITION_Y || mouseY > TEXT_POSITION_Y + TEXT_AREA_HEIGHT) {
    return -1;
  }
  
  for (int i = 0; i < words.size(); i++) {
    if (words.get(i).isMouseOver(scrollY, mouseX, mouseY)) {
      return i;
    }
  }
  
  return -1;
}

void highlightRange(int startIndex, int endIndex) {
  unhighlightUser();
  for (int i = startIndex; i <= endIndex && i < words.size(); i++) {
    words.get(i).isHighlighted = true;
    highlighted += words.get(i).wordText + " ";
  }
}

void unhighlightUser() {
  highlighted = "";
  for (Word w : words) {
    if (w.isHighlighted)
    {
      w.isHighlighted = false;
    }
  }
}

String getHighlightedText() {
  String highlightedText = "";
  for (Word w : words) {
    if (w.isHighlighted) {
      highlightedText += w.wordText + " ";
    }
  }
  return highlightedText.trim();
}

void calculateFeedbackScrollBounds() {
  if (geminiResponse.length() == 0) {
    feedbackContentHeight = 0;
    minFeedbackScrollY = 0;
    maxFeedbackScrollY = 0;
    return;
  }
  
  textSize(14);
  float textWidth = FEEDBACK_PANEL_WIDTH - (FEEDBACK_MARGIN * 2);
  String cleanResponse = geminiResponse;
  cleanResponse = cleanResponse.replace("\n", " ").replace("\r", " ").replace("\t", " ");
  String[] responseWords = split(cleanResponse, ' ');
  
  float currentX = 0;
  float lineHeight = 20;
  int lineCount = 1;
  
  for (String word : responseWords) {
    if (word.length() == 0) continue;
    String wordWithSpace = word + " ";
    float wordWidth = textWidth(wordWithSpace);
    
    if (currentX + wordWidth > textWidth && currentX > 0) {
      currentX = 0;
      lineCount++;
    }
    currentX += wordWidth;
  }
  
  feedbackContentHeight = lineCount * lineHeight;
  float visibleHeight = FEEDBACK_PANEL_HEIGHT - (FEEDBACK_MARGIN * 2) - 30;
  
  if (feedbackContentHeight > visibleHeight) {
    minFeedbackScrollY = visibleHeight - feedbackContentHeight;
    maxFeedbackScrollY = 0;
  } else {
    minFeedbackScrollY = 0;
    maxFeedbackScrollY = 0;
  }
  
  feedbackScrollY = constrain(feedbackScrollY, minFeedbackScrollY, maxFeedbackScrollY);
}

void parseAndHighlightGeminiResponse() {
  if (geminiResponse.length() == 0) return;
  
  //String lowerResponse = geminiResponse.toLowerCase();
  //String[] sentences = split(geminiResponse, '.');
  
  //for (String sentence : sentences) {
  //  String lowerSentence = sentence.toLowerCase();
    
  //  if (lowerSentence.contains("highlighted in yellow")) {
  //    String textToHighlight = extractHighlightedText(sentence, "yellow");
  //    if (textToHighlight.length() > 0) {
  //      highlightTextInEssay(textToHighlight, YELLOW_HIGHLIGHT);
  //    }
  //  }
    
  //  if (lowerSentence.contains("highlighted in green")) {
  //    String textToHighlight = extractHighlightedText(sentence, "green");
  //    if (textToHighlight.length() > 0) {
  //      highlightTextInEssay(textToHighlight, GREEN_HIGHLIGHT);
  //    }
  //  }
  //}
  
  //go through entire response and mark the places of the ^ character
  ArrayList<Integer> indices = new ArrayList<Integer>();
  
  for (int i = 0; i < geminiResponse.length(); i++)
  {
    if (geminiResponse.charAt(i) == '^')
    {
      indices.add(i);
    }
  }
  
  //take pairs of the indices and split them up
  for (int i = 0; i < indices.size(); i += 2)
  {
    String quote = geminiResponse.substring(indices.get(i) + 1, indices.get(i + 1));
    println(quote);
    //first word will always be the colour;
    String colour = split(quote, " ")[0]; //can either be (YELLOW) or (GREEN)
    println(colour);
    quote = quote.replace(colour, "").trim();
    quote = quote.replace("^", "");
    
    
    println(quote);
    
    if (colour.equals("(YELLOW)"))
    {
      highlightTextInEssay(quote, YELLOW_HIGHLIGHT);
    }
    else if (colour.equals("(GREEN)"))
    {
      highlightTextInEssay(quote, GREEN_HIGHLIGHT);
    }
    
  }
  
  geminiResponse = geminiResponse.replace("^", "\""); //get rid of the damn ^
  geminiResponse = geminiResponse.replace("(GREEN)", "").trim();
  geminiResponse = geminiResponse.replace("(YELLOW)", "").trim();
}

void highlightTextInEssay(String textToFind, color highlightColor) {
  
  
  //we have a string of text that we need to look for. we can make a mold of what words we need in what order, and move that mold across the essay until it fits somewhere, and thats where we find our quotation.
  
  //set up the list of words
  
  String[] wordsInQuote = split(textToFind, " ");
  int numWords = wordsInQuote.length;
  
  String startingWord = wordsInQuote[0].toLowerCase().trim();
  String endingWord = wordsInQuote[wordsInQuote.length - 1].toLowerCase().trim();
  //we have the words arraylist for all the word objects
  
  
  //check for matching starting and ending words
  for (int i = 0; i < words.size() - numWords + 1; i++)
  {
    

    
    
    println(startingWord, words.get(i).wordText.toLowerCase(), words.get(i).wordText.toLowerCase().equals(startingWord));
    println(endingWord, words.get(i + numWords - 1).wordText.toLowerCase(), words.get(i + numWords - 1).wordText.toLowerCase().equals(endingWord));
    
    if (normalizeText(words.get(i).wordText.toLowerCase()).equals(normalizeText(startingWord)) && normalizeText(words.get(i + numWords - 1).wordText.toLowerCase()).equals(normalizeText(endingWord)))
    {
      //highlightttt
      for (int j = i; j < i + numWords; j++)
      {
        words.get(j).isProgramHighlighted = true;
        words.get(j).programHighlightColour = highlightColor;
      }
      return;
    }
  }
  println("highlight not found :(");
}

String normalizeText(String text)
{
  String newWord = "";
  
    
  for (int i = 0; i < text.length(); i++)
  {
    if (!punctuation.contains(text.charAt(i)))
    {
      newWord += text.charAt(i);
    }
  }
  
  return newWord;
}
