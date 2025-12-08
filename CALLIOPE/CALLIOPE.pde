import g4p_controls.*;

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
color HIGHLIGHT_COLOR = color(173, 216, 230);

<<<<<<< Updated upstream
//Feedback panel constants
int FEEDBACK_PANEL_X = TEXT_POSITION_X + TEXT_AREA_WIDTH + 20;  //Right side of essay
int FEEDBACK_PANEL_Y = TEXT_POSITION_Y;  //Same Y as essay
int FEEDBACK_PANEL_WIDTH = CANVAS_WIDTH - FEEDBACK_PANEL_X - TEXT_POSITION_X;  //Remaining width
int FEEDBACK_PANEL_HEIGHT = TEXT_AREA_HEIGHT;  //Same height as essay
int FEEDBACK_MARGIN = 15;  //Margin inside feedback panel
=======
ArrayList<String> dictionary = new ArrayList();
int FEEDBACK_PANEL_X = TEXT_POSITION_X + TEXT_AREA_WIDTH + 20;
int FEEDBACK_PANEL_Y = TEXT_POSITION_Y;
int FEEDBACK_PANEL_WIDTH = CANVAS_WIDTH - FEEDBACK_PANEL_X - TEXT_POSITION_X;
int FEEDBACK_PANEL_HEIGHT = TEXT_AREA_HEIGHT;
int FEEDBACK_MARGIN = 15;
>>>>>>> Stashed changes

String highlighted = "";
String geminiResponse = "";

<<<<<<< Updated upstream
//Text content
String essay = "In an increasingly interconnected world, the ability to communicate across cultures is more valuable than ever. One of the most effective ways to build this skill is by learning a second language. While some people view language study as just another school requirement, it actually offers far-reaching advantages that extend beyond the classroom. Learning a second language improves cognitive abilities, expands career opportunities, and deepens cultural understanding, making it a valuable investment in one’s personal and professional future. To begin with, learning a second language strengthens the brain. Research has shown that bilingual individuals often have better memory, problem-solving skills, and mental flexibility than monolingual speakers. When students switch between languages, they train their brains to focus, ignore distractions, and process information more efficiently. This constant mental exercise can even delay age-related cognitive decline later in life. In other words, studying another language is not only about vocabulary and grammar; it is also a workout for the mind that can improve overall academic performance and long-term brain health. In addition to cognitive benefits, being bilingual creates valuable career opportunities. In today’s globalized economy, many companies work with international clients and partners, making employees who speak multiple languages especially attractive. A job candidate who can communicate in more than one language may be able to negotiate deals, assist customers, or collaborate with colleagues in ways that others cannot. This skill can lead to higher salaries, more travel, and a wider range of job options in fields such as business, tourism, translation, diplomacy, and education. Thus, learning a second language is not just an academic achievement; it is a practical tool that can make a candidate stand out in a competitive job market. Moreover, learning another language helps individuals develop a deeper appreciation for other cultures. Language and culture are closely linked, and studying a language often involves learning about the traditions, values, and history of the people who speak it. This exposure can reduce stereotypes and encourage empathy by showing that there are many valid ways of living and thinking. For example, understanding cultural customs—such as greeting styles, holidays, or table manners—can make communication more respectful and meaningful. In a world where misunderstandings can quickly lead to conflict, the ability to see issues from multiple cultural perspectives is an important skill for building tolerance and cooperation. Of course, learning a second language can be challenging. It requires time, patience, and consistent practice. Some people may worry that they will never sound like a native speaker or that they will make embarrassing mistakes. However, these challenges are also opportunities for growth. Making mistakes is a natural part of the learning process, and each error helps learners understand the language more deeply. With modern resources—such as language apps, online courses, and conversation partners—it is easier than ever to practice regularly and improve steadily. In conclusion, the benefits of learning a second language are substantial and long-lasting. It sharpens the mind, opens doors to diverse career paths, and fosters greater cultural understanding. Although the process can be demanding, the rewards far outweigh the difficulties. In a world where communication and cooperation are essential, learning another language is not just an academic task but a powerful step toward becoming a more capable, open-minded, and globally aware individual.";


//Array to store all words
ArrayList<Word> words;
float scrollY = 0;  // Current scroll offset for essay
float minScrollY = 0;  // Minimum scroll position (top of essay)
float maxScrollY = 1000;  // Maximum scroll position (bottom of essay)
=======
String essay;

ArrayList<Word> words = new ArrayList();
float scrollY = 0;
float minScrollY = 0;
float maxScrollY = 1000;
>>>>>>> Stashed changes

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
}

void DrawHomeScreen()
{
  noClip();
  
  background(0, 0, 50);
  fill(255);  //Reset fill to white for text
  textAlign(CENTER);
  textSize(100);
  text("CALLIOPE", width / 2, 250);
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
  text("Gemini Feedback", FEEDBACK_PANEL_X + FEEDBACK_MARGIN, FEEDBACK_PANEL_Y + FEEDBACK_MARGIN);
  
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
  fill(0);
  
  for (Word w : words) {
    w.display(scrollY);
  }
  
  popMatrix();
  
<<<<<<< Updated upstream
  //Clear any clipping so GUI buttons (like back button) can be drawn properly
  noClip();
 
=======
  noClip();
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
//Highlight a range of words from startIndex to endIndex (inclusive)
//Only one range can be highlighted at a time - unhighlights previous selection
void highlightRange(int startIndex, int endIndex) {
  //First, unhighlight all previous selections
  unhighlightAll();
  
  //Then highlight the new range
=======
void highlightRange(int startIndex, int endIndex) {
  unhighlightAll();
>>>>>>> Stashed changes
  for (int i = startIndex; i <= endIndex && i < words.size(); i++) {
    words.get(i).isHighlighted = true;
    highlighted += words.get(i).wordText + " ";
    words.get(i).backgroundColor = HIGHLIGHT_COLOR;
  }
}

void unhighlightAll() {
  highlighted = "";
  for (Word w : words) {
    w.isHighlighted = false;
    w.backgroundColor = color(255);
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
