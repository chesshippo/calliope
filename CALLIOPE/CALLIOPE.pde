import g4p_controls.*;

//Any variables in CONSTANT_CASE are Paramaters/Constant.
int CANVAS_WIDTH = 1000;
int CANVAS_HEIGHT = 650;
int TEXT_POSITION_X = 50;
int TEXT_POSITION_Y = 100;
int TEXT_AREA_WIDTH = 600;
int TEXT_AREA_HEIGHT = 400;
int TEXT_MARGIN = 20;
int LINE_HEIGHT = 30;
int WORD_SPACING = 10;
int SCROLL_SPEED = 5;
int UNHIGHLIGHT_BUTTON_SIZE = 30;

color HIGHLIGHT_COLOR = color(173, 216, 250, 100);
color YELLOW_HIGHLIGHT = color(255, 255, 0);
color GREEN_HIGHLIGHT = color(0, 255, 0);

//The Array dictionary is the list of words that are in the english dictionary.
//It can be used for spellcheck.

ArrayList<String> dictionary = new ArrayList();

//The following are the constants for the feedback panel position and size
int FEEDBACK_PANEL_X = TEXT_POSITION_X + TEXT_AREA_WIDTH + 20;
int FEEDBACK_PANEL_Y = TEXT_POSITION_Y;
int FEEDBACK_PANEL_WIDTH = CANVAS_WIDTH - FEEDBACK_PANEL_X - TEXT_POSITION_X;
int FEEDBACK_PANEL_HEIGHT = TEXT_AREA_HEIGHT;
int FEEDBACK_MARGIN = 15;

//The string highlighted is used to turn the user's highlighted text into a string
String highlighted = "";

//The following string stores the response from Gemini
String geminiResponse = "";

//essay is the variable that the user's essay is loaded on to.
String essay;

//Each word in the essay is contained in an array "words" as a Word class.
ArrayList<Word> words = new ArrayList();

//scrollY tells us how much the user has scrolled up and down on the essay presentation screen.
float scrollY = 0;

//The maximum is a placeholders until we calculate how long the essay is.
float minScrollY = 0;
float maxScrollY = 1000;

//The feedback panel can also scroll, so the same process occurs their.
float feedbackScrollY = 0;
float minFeedbackScrollY = 0;
float maxFeedbackScrollY = 0;
float feedbackContentHeight = 0;

//The following stores the index of the first word the user clicked when selecting a range
Integer firstSelectedWordIndex = null;

//The following string is where the API_KEY text will be loaded onto.
String API_KEY;

//stage tells the program on which screen the user is.
//At first the stage is set to "Home".
WindowStage stage = WindowStage.Home;


//The following function sets up the program when it first starts
void setup() {
  createGUI();
  size(1000, 650);
  
  //The following takes the api_key text and inputs it into a variable while removing all the empty space(with trim and [0])
  API_KEY = loadStrings("api_key.txt")[0].trim();
  
  //The following setups spellcheck. Specifically filling the dictionary with real english words
  SetupSpellcheck();
  PutEssayIntoWords();
  
  layoutWords();
  
  //The following calculates how long the user has to scroll before reaching the end, and sets the maxScrollY to that value.
  calculateScrollBounds();
  
  //The following hides the buttons that shouldn't be visible on the home screen.
  controlsWindow.setVisible(false);
  backButton.setVisible(false);
}

void draw()

  //Their are three functions that set certain buttons as visible, and let the user interact with the screen.
  //The function is called based on which stage the user is on(Home, Essay or Info).
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

//The following draws the home screen
void DrawHomeScreen()
{
  background(0, 0, 50);
  textAlign(CENTER);
  textSize(100);
  fill(255);
  text("CALLIOPE", width / 2, 250);
}

//The following draws the Info Screen
void DrawInfoScreen()
{
  backButton.setVisible(true);
  startButton.setVisible(false);
  infoButton.setVisible(false);
  
  background(0, 0, 50);
  
  
}

//The following draws the main screen the user will use(The essay editing screen.)
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
  text("Calliope Feedback", FEEDBACK_PANEL_X + FEEDBACK_MARGIN, FEEDBACK_PANEL_Y + FEEDBACK_MARGIN);
  
  
  //The following checks if gemini has responded.
  if (geminiResponse.length() > 0) {
    
    //There is a function in the code "clip", that makes it so anything in a certain area is not rendered on the screen.
    //pushMatrix reverses this function(it goes back to before the function was implemented.)
    pushMatrix();
    
    //Like previously mentioned this makes it so anything not present in the feedback panel won't be rendered.
    //This is useful as any words that are not in the boxes due to scrolling just won't be rendered.
    clip(FEEDBACK_PANEL_X, FEEDBACK_PANEL_Y, FEEDBACK_PANEL_WIDTH, FEEDBACK_PANEL_HEIGHT);
    
    fill(30);
    textSize(14);
    textAlign(LEFT, TOP);
    
    
    float textX = FEEDBACK_PANEL_X + FEEDBACK_MARGIN;
    float baseTextY = FEEDBACK_PANEL_Y + FEEDBACK_MARGIN + 30;
    float textY = baseTextY + feedbackScrollY;
    float textWidth = FEEDBACK_PANEL_WIDTH - (FEEDBACK_MARGIN * 2);
    
    //The following cleans the response by replacing newlines and tabs with spaces
    String cleanResponse = geminiResponse;
    cleanResponse = cleanResponse.replace("\n", " ").replace("\r", " ").replace("\t", " ");
    String[] responseWords = split(cleanResponse, ' ');
    float currentX = textX;
    float currentY = textY;
    float lineHeight = 20;
    
    //The following loops through each word and displays it with word wrapping
    //Word wrapping works by checking if adding the next word would exceed the text area width
    //If it would exceed, we move to the next line by increasing currentY and resetting currentX to the left margin
    //We add a space after each word when measuring width because words need spacing between them
    for (String word : responseWords) {
      if (word.length() == 0) continue;
      
      String wordWithSpace = word + " ";
      float wordWidth = textWidth(wordWithSpace);
      
      //This checks if the word would go past the right edge. The "currentX > textX" part prevents wrapping at the start of a line
      if (currentX + wordWidth > textX + textWidth && currentX > textX) {
        currentY += lineHeight;
        currentX = textX;
      }
      
      text(word + " ", currentX, currentY);
      currentX += wordWidth;
    }
    
    popMatrix();
  } else {
    //The following displays placeholder text when there is no feedback yet
    fill(150);
    textSize(12);
    textAlign(LEFT, TOP);
    text("Highlight text and ask Gemini\nfor feedback...", 
         FEEDBACK_PANEL_X + FEEDBACK_MARGIN, 
         FEEDBACK_PANEL_Y + FEEDBACK_MARGIN + 30);
  }
  
  //The following sets up text rendering for the essay words
  fill(0);
  textSize(16);
  textAlign(LEFT, BASELINE);
  
  pushMatrix();
  
  //The following clips the essay area so words outside the box are not rendered.
  clip(TEXT_POSITION_X, TEXT_POSITION_Y, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);
  
  for (Word w : words) {
    w.display(scrollY);
  }
  
  popMatrix();
 
  //Similar to pushMatrix, noClip() clears the clip allowing the text to be rendered.
  noClip();
}

//The following function calculates the position of each word in the essay
void layoutWords() {
  
  float currentX = TEXT_POSITION_X + TEXT_MARGIN;
  float currentY = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  int currentLine = 0;
  
  textSize(16);
  
  //The following loops through each word and positions it on the screen.
  for (Word w : words) {
    float wordWidth = textWidth(w.wordText + " ");
    
    //The following checks if the word fits on the current line, if not it moves to the next line.
    //We check if adding this word would push past the right margin (TEXT_AREA_WIDTH - TEXT_MARGIN)
    //If it would, we increment the line number, move down by LINE_HEIGHT, and reset X to the left margin.
    if (currentX + wordWidth > TEXT_POSITION_X + TEXT_AREA_WIDTH - TEXT_MARGIN) {
      currentLine++;
      currentY += LINE_HEIGHT;
      currentX = TEXT_POSITION_X + TEXT_MARGIN;
    }
    
    w.lineNumber = currentLine;
    w.xPosition = currentX;
    w.yPosition = currentY;
    
    //After placing the word, we move currentX forward by the word width plus spacing for the next word.
    currentX += wordWidth + WORD_SPACING;
  }
}

//The following function calculates how far the user can scroll based on the essay length.
void calculateScrollBounds() {
  if (words.size() == 0) {
    minScrollY = 0;
    maxScrollY = 0;
    return;
  }
  
 
  float topMargin = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  
  //The following finds the most bottom word in the essay
  float bottomY = 0;
  for (Word w : words) {
    if (w.yPosition > bottomY) {
      bottomY = w.yPosition;
    }
  }
  
  float contentHeight = bottomY - topMargin + LINE_HEIGHT;
  float visibleHeight = TEXT_AREA_HEIGHT - (TEXT_MARGIN * 2);
  
  //The following sets the scroll bounds based on whether the content fits on screen.
  //ScrollY is the offset applied to word positions. When scrollY is 0, content is at the top.
  //When scrollY is negative (like maxScrollY), content moves up, showing the bottom.
  //maxScrollY is negative because: if content is 500px tall and visible area is 400px, we need to scroll -100px to show the bottom.
  if (contentHeight <= visibleHeight) {
    minScrollY = 0;
    maxScrollY = 0;
  } else {
    minScrollY = 0;
    maxScrollY = visibleHeight - contentHeight;
  }
}


//The following function finds which word the mouse is over, or returns -1 if not over any word
int getWordAtMousePosition() {

  //The following checks if the mouse is within the text area
  if (mouseX < TEXT_POSITION_X || mouseX > TEXT_POSITION_X + TEXT_AREA_WIDTH ||
      mouseY < TEXT_POSITION_Y || mouseY > TEXT_POSITION_Y + TEXT_AREA_HEIGHT) {
    return -1;
  }
  
  //The following loops through each word to see if the mouse is over it
  for (int i = 0; i < words.size(); i++) {
    if (words.get(i).isMouseOver(scrollY, mouseX, mouseY)) {
      return i;
    }
  }
  
  return -1;
}

//Based on where the user clicks first, and clicks last. The program will highlight all words inbetween, using a start and end index.
void highlightRange(int startIndex, int endIndex) {
  unhighlightUser();
  for (int i = startIndex; i <= endIndex && i < words.size(); i++) {
    words.get(i).isHighlighted = true;
    highlighted += words.get(i).wordText + " ";
  }
}

//The following function unhighlights all words that the user has highlighted.
void unhighlightUser() {
  highlighted = "";
  for (Word w : words) {
    if (w.isHighlighted)
    {
      w.isHighlighted = false;
    }
  }
}

//The following function returns all the text that the user has highlighted as a string.
String getHighlightedText() {
  String highlightedText = "";
  for (Word w : words) {
    if (w.isHighlighted) {
      highlightedText += w.wordText + " ";
    }
  }
  return highlightedText.trim();
}

//The following function calculates how far the user can scroll in the feedback panel.
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
  
  //The following simulates word wrapping to count how many lines the feedback will take.
  //We don't actually draw the text here, we just measure it to calculate the total height.
  //This must match the drawing code exactly, or the scroll bounds will be wrong.
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
  
  //The following sets the scroll bounds based on whether the content fits on screen.
  //minFeedbackScrollY is negative when content is taller than visible area.
  if (feedbackContentHeight > visibleHeight) {
    minFeedbackScrollY = visibleHeight - feedbackContentHeight;
    maxFeedbackScrollY = 0;
  } else {
    minFeedbackScrollY = 0;
    maxFeedbackScrollY = 0;
  }
  
  feedbackScrollY = constrain(feedbackScrollY, minFeedbackScrollY, maxFeedbackScrollY);
}

//The following function parses the Gemini response to find text that should be highlighted.
void parseAndHighlightGeminiResponse() {
  if (geminiResponse.length() == 0) return;
  
  String lowerResponse = geminiResponse.toLowerCase();
  String[] sentences = split(geminiResponse, '.');
  
  //The following loops through each sentence to find highlight instructions.
  for (String sentence : sentences) {
    String lowerSentence = sentence.toLowerCase();
    
    if (lowerSentence.contains("highlighted in yellow")) {
      String textToHighlight = extractHighlightedText(sentence, "yellow");
      if (textToHighlight.length() > 0) {
        highlightTextInEssay(textToHighlight, YELLOW_HIGHLIGHT);
      }
    }
    
    if (lowerSentence.contains("highlighted in green")) {
      String textToHighlight = extractHighlightedText(sentence, "green");
      if (textToHighlight.length() > 0) {
        highlightTextInEssay(textToHighlight, GREEN_HIGHLIGHT);
      }
    }
  }
}

//The following function extracts the text that should be highlighted from a sentence.
String extractHighlightedText(String sentence, String colour) {
  String lowerSentence = sentence.toLowerCase();
  String lowerColor = colour.toLowerCase();
  
  int startIndex = -1;
  String[] patterns = {
    "highlighted in " + lowerColor + " is",
    "highlighted in " + lowerColor + ":",
    "highlighted in " + lowerColor + " -",
    "highlighted in " + lowerColor
  };
  
  //The following finds where the highlighted text starts in the sentence.
  //We try multiple patterns because Gemini might phrase it differently (with "is", ":", "-", or nothing).
  //Once we find a pattern, we get the position right after it. If there's a space, we skip it.
  for (String pattern : patterns) {
    if (lowerSentence.contains(pattern)) {
      startIndex = lowerSentence.indexOf(pattern) + pattern.length();
      if (startIndex < sentence.length() && sentence.charAt(startIndex) == ' ') {
        startIndex++;
      }
      break;
    }
  }
  
  if (startIndex == -1 || startIndex >= sentence.length()) return "";
  
  String remaining = sentence.substring(startIndex).trim();
  
  //The following checks if the text is in quotes and extracts it.
  //Quotes are the most reliable way to identify the exact text, so we check for them first.
  //We look for the closing quote starting from position 1 (after the opening quote).
  if (remaining.startsWith("\"") && remaining.length() > 1) {
    int endQuote = remaining.indexOf("\"", 1);
    if (endQuote > 0) {
      return remaining.substring(1, endQuote).trim();
    }
  }
  
  if (remaining.startsWith("'") && remaining.length() > 1) {
    int endQuote = remaining.indexOf("'", 1);
    if (endQuote > 0) {
      return remaining.substring(1, endQuote).trim();
    }
  }
  
  //The following finds where the text ends by looking for sentence markers
  //If there are no quotes, we look for punctuation that typically end the highlighted text.
  //We take the earliest marker found, as that's likely where the text ends
  int endIndex = remaining.length();
  String[] endMarkers = {".", ",", ";", " and", " or", " but"};
  for (String marker : endMarkers) {
    int markerIndex = remaining.indexOf(marker);
    if (markerIndex > 0 && markerIndex < endIndex) {
      endIndex = markerIndex;
    }
  }
  
  String result = remaining.substring(0, endIndex).trim();
  //Sometimes quotes might be at the end instead of the beginning, so we remove them here too.
  //We need to be careful as quotations could always mess with how strings work.
  if (result.endsWith("\"") && result.length() > 1) {
    result = result.substring(0, result.length() - 1).trim();
  }
  if (result.endsWith("'") && result.length() > 1) {
    result = result.substring(0, result.length() - 1).trim();
  }
  
  return result;
}

//The following function finds text in the essay and highlights it with the specified color.
void highlightTextInEssay(String textToFind, color highlightColor) {
  if (textToFind.length() == 0) return;
  
  String normalizedFind = normalizeText(textToFind);
  String[] findWords = split(normalizeText(textToFind), ' ');
  
  if (findWords.length == 0) return;
  
  boolean found = false;
  
  //The following tries to match the text word by word.
  //This is the preferred method because it handles punctuation correctly (e.g., "word," matches "word").
  //We start at each position in the essay and try to match all words in sequence.
  for (int i = 0; i < words.size(); i++) {
    boolean match = true;
    int matchEnd = i;
    
    //We compare each word in the search text with words in the essay, normalized to ignore case and punctuation.
    for (int j = 0; j < findWords.length && (i + j) < words.size(); j++) {
      String wordText = normalizeText(words.get(i + j).wordText);
      if (!wordText.equals(findWords[j])) {
        match = false;
        break;
      }
      matchEnd = i + j;
    }
    
    //If all words matched, we highlight from position i to matchEnd.
    if (match && findWords.length > 0) {
      for (int k = i; k <= matchEnd; k++) {
        words.get(k).isProgramHighlighted = true;
        words.get(k).programHighlightColour = highlightColor;
      }
      found = true;
    }
  }
  
  //The following tries a different method if word by word matching did not work.
  //This fallback method treats the entire essay as one string and searches for the normalized text.
  //It's less precise but can catch cases where word boundaries don't align perfectly.
  if (!found) {
    String fullEssayText = "";
    for (Word w : words) {
      fullEssayText += normalizeText(w.wordText) + " ";
    }
    
    //We search for all occurrences of the text (in case it appears multiple times)
    int searchStart = 0;
    while (true) {
      int startPos = fullEssayText.indexOf(normalizedFind, searchStart);
      if (startPos == -1) break;
      
      //To convert string position to word index, we count how many words come before the match.
      //We split the text before the match and count the words, then add the length of the search text.
      String beforeMatch = fullEssayText.substring(0, startPos);
      String[] beforeWords = split(beforeMatch, ' ');
      int wordStart = beforeWords.length;
      int wordEnd = wordStart + split(normalizedFind, ' ').length - 1;
      
      for (int k = wordStart; k <= wordEnd && k < words.size(); k++) {
        words.get(k).isProgramHighlighted = true;
        words.get(k).programHighlightColour = highlightColor;
      }
      
      searchStart = startPos + 1;
    }
  }
}

//The following function normalizes text by making it lowercase and removing punctuation for matching.
//This is necessary because the essay might have "word," but Gemini might say "word" without the comma.
//The regex "[^a-z0-9\\s]" means if anything isn't a letter, number or space it will be deleted.
//The regex "\\s+" means we replace mutliple spaces with one space
//This makes "word,  word" and "word word" both become "word word" for comparison
String normalizeText(String text) {
  String normalized = text.toLowerCase();
  normalized = normalized.replaceAll("[^a-z0-9\\s]", "");
  normalized = normalized.replaceAll("\\s+", " ");
  return normalized.trim();
}
