import g4p_controls.*;

//constant values (can't be changed)
int CANVAS_WIDTH = 1000;
int CANVAS_HEIGHT = 650;
int TEXT_POSITION_X = 50;
int TEXT_POSITION_Y = 100;
int TEXT_AREA_WIDTH = 600;  //Width of the text display area
int TEXT_AREA_HEIGHT = 400; //Height of the text display area
int TEXT_MARGIN = 20;       //Margin around text within the display area
int LINE_HEIGHT = 30;       //Vertical spacing between lines
int WORD_SPACING = 10;      //Horizontal spacing between words
int SCROLL_SPEED = 5;       //Pixels to scroll per key press
int UNHIGHLIGHT_BUTTON_SIZE = 30;  //Size of unhighlight button
color HIGHLIGHT_COLOR = color(173, 216, 230);  //Light blue for highlighting

//Feedback panel constants
int FEEDBACK_PANEL_X = TEXT_POSITION_X + TEXT_AREA_WIDTH + 20;  //Right side of essay
int FEEDBACK_PANEL_Y = TEXT_POSITION_Y;  //Same Y as essay
int FEEDBACK_PANEL_WIDTH = CANVAS_WIDTH - FEEDBACK_PANEL_X - TEXT_POSITION_X;  //Remaining width
int FEEDBACK_PANEL_HEIGHT = TEXT_AREA_HEIGHT;  //Same height as essay
int FEEDBACK_MARGIN = 15;  //Margin inside feedback panel

String highlighted = "";  //Deprecated - use getHighlightedText() instead
String geminiResponse = "";  //Stores Gemini's response to display in feedback panel

//Text content
String essay = "In an increasingly interconnected world, the ability to communicate across cultures is more valuable than ever. One of the most effective ways to build this skill is by learning a second language. While some people view language study as just another school requirement, it actually offers far-reaching advantages that extend beyond the classroom. Learning a second language improves cognitive abilities, expands career opportunities, and deepens cultural understanding, making it a valuable investment in one’s personal and professional future. To begin with, learning a second language strengthens the brain. Research has shown that bilingual individuals often have better memory, problem-solving skills, and mental flexibility than monolingual speakers. When students switch between languages, they train their brains to focus, ignore distractions, and process information more efficiently. This constant mental exercise can even delay age-related cognitive decline later in life. In other words, studying another language is not only about vocabulary and grammar; it is also a workout for the mind that can improve overall academic performance and long-term brain health. In addition to cognitive benefits, being bilingual creates valuable career opportunities. In today’s globalized economy, many companies work with international clients and partners, making employees who speak multiple languages especially attractive. A job candidate who can communicate in more than one language may be able to negotiate deals, assist customers, or collaborate with colleagues in ways that others cannot. This skill can lead to higher salaries, more travel, and a wider range of job options in fields such as business, tourism, translation, diplomacy, and education. Thus, learning a second language is not just an academic achievement; it is a practical tool that can make a candidate stand out in a competitive job market. Moreover, learning another language helps individuals develop a deeper appreciation for other cultures. Language and culture are closely linked, and studying a language often involves learning about the traditions, values, and history of the people who speak it. This exposure can reduce stereotypes and encourage empathy by showing that there are many valid ways of living and thinking. For example, understanding cultural customs—such as greeting styles, holidays, or table manners—can make communication more respectful and meaningful. In a world where misunderstandings can quickly lead to conflict, the ability to see issues from multiple cultural perspectives is an important skill for building tolerance and cooperation. Of course, learning a second language can be challenging. It requires time, patience, and consistent practice. Some people may worry that they will never sound like a native speaker or that they will make embarrassing mistakes. However, these challenges are also opportunities for growth. Making mistakes is a natural part of the learning process, and each error helps learners understand the language more deeply. With modern resources—such as language apps, online courses, and conversation partners—it is easier than ever to practice regularly and improve steadily. In conclusion, the benefits of learning a second language are substantial and long-lasting. It sharpens the mind, opens doors to diverse career paths, and fosters greater cultural understanding. Although the process can be demanding, the rewards far outweigh the difficulties. In a world where communication and cooperation are essential, learning another language is not just an academic task but a powerful step toward becoming a more capable, open-minded, and globally aware individual.";


//Array to store all words
ArrayList<Word> words;
float scrollY = 0;  // Current scroll offset for essay
float minScrollY = 0;  // Minimum scroll position (top of essay)
float maxScrollY = 1000;  // Maximum scroll position (bottom of essay)

//Feedback panel scrolling
float feedbackScrollY = 0;  // Current scroll offset for feedback panel
float minFeedbackScrollY = 0;  // Minimum scroll position (top of feedback)
float maxFeedbackScrollY = 0;  // Maximum scroll position (bottom of feedback)
float feedbackContentHeight = 0;  // Total height of feedback content

//Highlighting variables

//Integer to store null instead of just plain old int
Integer firstSelectedWordIndex = null;  // Index of first clicked word (null if none selected)
String API_KEY;
WindowStage stage = WindowStage.Home;

void setup() {
  createGUI();
  size(1000, 650);
  
  // Load API key
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
  background(0, 0, 50);
  textAlign(CENTER);
  textSize(100);
  text("CALLIOPE", width / 2, 250);
}

void drawEditingScreen() {
  background(0, 0, 50);
  
  //Draw the text display area (square/rectangle on left)
  fill(240);
  stroke(200);
  rect(TEXT_POSITION_X, TEXT_POSITION_Y, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);
  
  //Draw the feedback panel (on the right)
  fill(250);
  stroke(200);
  rect(FEEDBACK_PANEL_X, FEEDBACK_PANEL_Y, FEEDBACK_PANEL_WIDTH, FEEDBACK_PANEL_HEIGHT);
  
  //Draw feedback panel title
  fill(50);
  textSize(18);
  textAlign(LEFT, TOP);
  text("Gemini Feedback", FEEDBACK_PANEL_X + FEEDBACK_MARGIN, FEEDBACK_PANEL_Y + FEEDBACK_MARGIN);
  
  //Draw feedback text (with word wrapping and scrolling)
  if (geminiResponse.length() > 0) {
    pushMatrix();
    
    //Clip to feedback panel area
    clip(FEEDBACK_PANEL_X, FEEDBACK_PANEL_Y, FEEDBACK_PANEL_WIDTH, FEEDBACK_PANEL_HEIGHT);
    
    fill(30);
    textSize(14);
    textAlign(LEFT, TOP);
    
    //Word wrap the response text
    float textX = FEEDBACK_PANEL_X + FEEDBACK_MARGIN;
    float baseTextY = FEEDBACK_PANEL_Y + FEEDBACK_MARGIN + 30;
    float textY = baseTextY + feedbackScrollY;
    float textWidth = FEEDBACK_PANEL_WIDTH - (FEEDBACK_MARGIN * 2);
    
    //Clean and split response into words - handle punctuation better
    String cleanResponse = geminiResponse;
    //Replace newlines and tabs with spaces
    cleanResponse = cleanResponse.replace("\n", " ").replace("\r", " ").replace("\t", " ");
    //Split by spaces using Processing's split function
    String[] responseWords = split(cleanResponse, ' ');
    float currentX = textX;
    float currentY = textY;
    float lineHeight = 20;
    
    for (String word : responseWords) {
      if (word.length() == 0) continue;  //Skip empty words
      
      //Add space after word for measurement
      String wordWithSpace = word + " ";
      float wordWidth = textWidth(wordWithSpace);
      
      if (currentX + wordWidth > textX + textWidth && currentX > textX) {
        //Move to next line (only if we're not at the start of a line)
        currentY += lineHeight;
        currentX = textX;
      }
      
      //Draw the word
      text(word + " ", currentX, currentY);
      currentX += wordWidth;
    }
    
    popMatrix();
  } else {
    //Show placeholder text
    fill(150);
    textSize(12);
    textAlign(LEFT, TOP);
    text("Highlight text and ask Gemini\nfor feedback...", 
         FEEDBACK_PANEL_X + FEEDBACK_MARGIN, 
         FEEDBACK_PANEL_Y + FEEDBACK_MARGIN + 30);
  }
  
  //Set up text rendering for essay
  fill(0);
  textSize(16);
  textAlign(LEFT, BASELINE);
  
  pushMatrix();
  
  //clip makes it so all words not in the text area are hidden.
  //The only way this is undone is with push and pop matrix
  //Push matrix saves everything before the clip, and pop matrix restores it back.
  clip(TEXT_POSITION_X, TEXT_POSITION_Y, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);
  fill(0);
  
  //Display all words with scroll offset
  for (Word w : words) {
    w.display(scrollY);
  }
  
  popMatrix();
  
  //Clear any clipping so GUI buttons (like back button) can be drawn properly
  noClip();
 
}

//Calculate positions for all words
void layoutWords() {
  
  float currentX = TEXT_POSITION_X + TEXT_MARGIN;
  float currentY = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  int currentLine = 0;
  
  textSize(16);
  
  for (Word w : words) {
    float wordWidth = textWidth(w.wordText + " ");
    
    // check if word fits on current line
    if (currentX + wordWidth > TEXT_POSITION_X + TEXT_AREA_WIDTH - TEXT_MARGIN) {
      //Move to next line
      currentLine++;
      currentY += LINE_HEIGHT;
      currentX = TEXT_POSITION_X + TEXT_MARGIN;
    }
    
    //Set word properties
    w.lineNumber = currentLine;
    w.xPosition = currentX;
    w.yPosition = currentY;
    
    //Move x position for next word
    currentX += wordWidth + WORD_SPACING;
  }
}

//Calculate scroll bounds based on content height
void calculateScrollBounds() {
  if (words.size() == 0) {
    minScrollY = 0;
    maxScrollY = 0;
    return;
  }
  
 
  float topMargin = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  
  //Find the bottommost word
  float bottomY = 0;
  for (Word w : words) {
    if (w.yPosition > bottomY) {
      bottomY = w.yPosition;
    }
  }
  
  //Calculate scroll limits
  //When scrolled all the way up, first word should be at top margin, and vice versa
  float contentHeight = bottomY - topMargin + LINE_HEIGHT;
  float visibleHeight = TEXT_AREA_HEIGHT - (TEXT_MARGIN * 2);
  
  if (contentHeight <= visibleHeight) {
    //Content fits in view, no scrolling needed
    minScrollY = 0;
    maxScrollY = 0;
  } else {
    // ontent is taller than view
    minScrollY = 0;  // Can't scroll above the top
    maxScrollY = visibleHeight - contentHeight;  // Scroll down until bottom is visible
  }
}


//Find which word (if any) is at the current mouse position
int getWordAtMousePosition() {

  
  // Check if mouse is within text area
  if (mouseX < TEXT_POSITION_X || mouseX > TEXT_POSITION_X + TEXT_AREA_WIDTH ||
      mouseY < TEXT_POSITION_Y || mouseY > TEXT_POSITION_Y + TEXT_AREA_HEIGHT) {
    return -1;
  }
  
  //Check each word to see if mouse is over it (accounting for scroll offset)
  for (int i = 0; i < words.size(); i++) {
    if (words.get(i).isMouseOver(scrollY, mouseX, mouseY)) {
      return i;
    }
  }
  
  return -1;
}

//Highlight a range of words from startIndex to endIndex (inclusive)
//Only one range can be highlighted at a time - unhighlights previous selection
void highlightRange(int startIndex, int endIndex) {
  //First, unhighlight all previous selections
  unhighlightAll();
  
  //Then highlight the new range
  for (int i = startIndex; i <= endIndex && i < words.size(); i++) {
    words.get(i).isHighlighted = true;
    highlighted += words.get(i).wordText + " ";
    words.get(i).backgroundColor = HIGHLIGHT_COLOR;
  }
}

//Unhighlight all words (reusable function)
void unhighlightAll() {
  highlighted = "";
  for (Word w : words) {
    w.isHighlighted = false;
    w.backgroundColor = color(255);
  }
}

//Get the currently highlighted text as a string
String getHighlightedText() {
  String highlightedText = "";
  for (Word w : words) {
    if (w.isHighlighted) {
      highlightedText += w.wordText + " ";
    }
  }
  return highlightedText.trim();  //Remove trailing space
}

//Calculate feedback panel scroll bounds based on content
void calculateFeedbackScrollBounds() {
  if (geminiResponse.length() == 0) {
    feedbackContentHeight = 0;
    minFeedbackScrollY = 0;
    maxFeedbackScrollY = 0;
    return;
  }
  
  //Calculate content height by simulating word wrapping (must match drawing code exactly)
  textSize(14);
  float textWidth = FEEDBACK_PANEL_WIDTH - (FEEDBACK_MARGIN * 2);
  String cleanResponse = geminiResponse;
  cleanResponse = cleanResponse.replace("\n", " ").replace("\r", " ").replace("\t", " ");
  String[] responseWords = split(cleanResponse, ' ');
  
  float currentX = 0;
  float lineHeight = 20;
  int lineCount = 1;  // Start with first line
  
  for (String word : responseWords) {
    if (word.length() == 0) continue;
    String wordWithSpace = word + " ";
    float wordWidth = textWidth(wordWithSpace);
    
    // Check if word fits on current line
    if (currentX + wordWidth > textWidth && currentX > 0) {
      // Move to next line
      currentX = 0;
      lineCount++;
    }
    currentX += wordWidth;
  }
  
  // Calculate total content height
  feedbackContentHeight = lineCount * lineHeight;
  float visibleHeight = FEEDBACK_PANEL_HEIGHT - (FEEDBACK_MARGIN * 2) - 30; // Subtract title area
  
  // Calculate scroll bounds
  // minFeedbackScrollY: most negative (when scrolled to bottom, showing last content)
  // maxFeedbackScrollY: 0 (when at top, showing first content)
  if (feedbackContentHeight > visibleHeight) {
    // Content is taller than visible area - can scroll
    minFeedbackScrollY = visibleHeight - feedbackContentHeight;  // Negative value
    maxFeedbackScrollY = 0;  // At top
  } else {
    // Content fits - no scrolling needed
    minFeedbackScrollY = 0;
    maxFeedbackScrollY = 0;
  }
  
  // Ensure current scroll position is within bounds
  feedbackScrollY = constrain(feedbackScrollY, minFeedbackScrollY, maxFeedbackScrollY);
}
