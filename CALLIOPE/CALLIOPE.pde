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
  backButton.setVisible(true);
  startButton.setVisible(false);
  infoButton.setVisible(false);
  
  background(0, 0, 50);
  
  
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
  text("Calliope Feedback", FEEDBACK_PANEL_X + FEEDBACK_MARGIN, FEEDBACK_PANEL_Y + FEEDBACK_MARGIN);
  
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
    text("Highlight text and ask Gemini\nfor feedback...", 
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
  
  String lowerResponse = geminiResponse.toLowerCase();
  String[] sentences = split(geminiResponse, '.');
  
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
  
  int endIndex = remaining.length();
  String[] endMarkers = {".", ",", ";", " and", " or", " but"};
  for (String marker : endMarkers) {
    int markerIndex = remaining.indexOf(marker);
    if (markerIndex > 0 && markerIndex < endIndex) {
      endIndex = markerIndex;
    }
  }
  
  String result = remaining.substring(0, endIndex).trim();
  if (result.endsWith("\"") && result.length() > 1) {
    result = result.substring(0, result.length() - 1).trim();
  }
  if (result.endsWith("'") && result.length() > 1) {
    result = result.substring(0, result.length() - 1).trim();
  }
  
  return result;
}

void highlightTextInEssay(String textToFind, color highlightColor) {
  if (textToFind.length() == 0) return;
  
  String normalizedFind = normalizeText(textToFind);
  String[] findWords = split(normalizeText(textToFind), ' ');
  
  if (findWords.length == 0) return;
  
  boolean found = false;
  
  for (int i = 0; i < words.size(); i++) {
    boolean match = true;
    int matchEnd = i;
    
    for (int j = 0; j < findWords.length && (i + j) < words.size(); j++) {
      String wordText = normalizeText(words.get(i + j).wordText);
      if (!wordText.equals(findWords[j])) {
        match = false;
        break;
      }
      matchEnd = i + j;
    }
    
    if (match && findWords.length > 0) {
      for (int k = i; k <= matchEnd; k++) {
        words.get(k).isProgramHighlighted = true;
        words.get(k).programHighlightColour = highlightColor;
      }
      found = true;
    }
  }
  
  if (!found) {
    String fullEssayText = "";
    for (Word w : words) {
      fullEssayText += normalizeText(w.wordText) + " ";
    }
    
    int searchStart = 0;
    while (true) {
      int startPos = fullEssayText.indexOf(normalizedFind, searchStart);
      if (startPos == -1) break;
      
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

String normalizeText(String text) {
  String normalized = text.toLowerCase();
  normalized = normalized.replaceAll("[^a-z0-9\\s]", "");
  normalized = normalized.replaceAll("\\s+", " ");
  return normalized.trim();
}
