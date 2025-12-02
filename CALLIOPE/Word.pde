x//Paramaters will be in capital for ease
int CANVAS_WIDTH = 1200;
int CANVAS_HEIGHT = 800;
int TEXT_AREA_WIDTH = 600;  //Width of the text display area
int TEXT_AREA_HEIGHT = 600; //Height of the text display area
int TEXT_MARGIN = 20;       //Margin around text within the display area
int LINE_HEIGHT = 30;       //Vertical spacing between lines
int WORD_SPACING = 10;      //Horizontal spacing between words
int SCROLL_SPEED = 5;       //Pixels to scroll per key press
int UNHIGHLIGHT_BUTTON_SIZE = 30;  //Size of unhighlight button
color HIGHLIGHT_COLOR = color(173, 216, 230);  //Light blue for highlighting
String highlighted = "";

//Text content
String essay = "In an increasingly interconnected world, the ability to communicate across cultures is more valuable than ever. One of the most effective ways to build this skill is by learning a second language. While some people view language study as just another school requirement, it actually offers far-reaching advantages that extend beyond the classroom. Learning a second language improves cognitive abilities, expands career opportunities, and deepens cultural understanding, making it a valuable investment in one’s personal and professional future. To begin with, learning a second language strengthens the brain. Research has shown that bilingual individuals often have better memory, problem-solving skills, and mental flexibility than monolingual speakers. When students switch between languages, they train their brains to focus, ignore distractions, and process information more efficiently. This constant mental exercise can even delay age-related cognitive decline later in life. In other words, studying another language is not only about vocabulary and grammar; it is also a workout for the mind that can improve overall academic performance and long-term brain health. In addition to cognitive benefits, being bilingual creates valuable career opportunities. In today’s globalized economy, many companies work with international clients and partners, making employees who speak multiple languages especially attractive. A job candidate who can communicate in more than one language may be able to negotiate deals, assist customers, or collaborate with colleagues in ways that others cannot. This skill can lead to higher salaries, more travel, and a wider range of job options in fields such as business, tourism, translation, diplomacy, and education. Thus, learning a second language is not just an academic achievement; it is a practical tool that can make a candidate stand out in a competitive job market. Moreover, learning another language helps individuals develop a deeper appreciation for other cultures. Language and culture are closely linked, and studying a language often involves learning about the traditions, values, and history of the people who speak it. This exposure can reduce stereotypes and encourage empathy by showing that there are many valid ways of living and thinking. For example, understanding cultural customs—such as greeting styles, holidays, or table manners—can make communication more respectful and meaningful. In a world where misunderstandings can quickly lead to conflict, the ability to see issues from multiple cultural perspectives is an important skill for building tolerance and cooperation. Of course, learning a second language can be challenging. It requires time, patience, and consistent practice. Some people may worry that they will never sound like a native speaker or that they will make embarrassing mistakes. However, these challenges are also opportunities for growth. Making mistakes is a natural part of the learning process, and each error helps learners understand the language more deeply. With modern resources—such as language apps, online courses, and conversation partners—it is easier than ever to practice regularly and improve steadily. In conclusion, the benefits of learning a second language are substantial and long-lasting. It sharpens the mind, opens doors to diverse career paths, and fosters greater cultural understanding. Although the process can be demanding, the rewards far outweigh the difficulties. In a world where communication and cooperation are essential, learning another language is not just an academic task but a powerful step toward becoming a more capable, open-minded, and globally aware individual.";


class Word {
  String wordText;
  int positionInEssay;  //Position in essay (0, 1, 2, 3...)
  int lineNumber;       //Which line this word appears on
  float xPosition;      //X position for display
  float yPosition;      //Y position for display (base position, will be adjusted for scrolling)
  boolean isHighlighted;  //Whether this word is highlighted
  color backgroundColor;  //Background color for highlighting
  
  Word(String text, int pos) {
    wordText = text;
    positionInEssay = pos;
    lineNumber = 0; 
    xPosition = 0; 
    yPosition = 0;   
    isHighlighted = false;
    backgroundColor = color(255);  //Default white background
  }
  
  //Display the word at its position (adjusted for scrolling)
  void display(float scrollOffset) {
    float displayY = yPosition + scrollOffset;
    
    //Draw background if highlighted
    if (isHighlighted) {
      textSize(16);
      float wordWidth = textWidth(wordText);
      float wordHeight = LINE_HEIGHT;
      
      fill(backgroundColor);
      noStroke();
      rect(xPosition, displayY - wordHeight + 5, wordWidth, wordHeight);
    }
    
    //Draw text
    fill(0);
    text(wordText, xPosition, displayY);
  }
  
  //Check if mouse click is within this word's bounds
  boolean isMouseOver(float scrollOffset, float mouseX, float mouseY) {
    float displayY = yPosition + scrollOffset;
    textSize(16);
    float wordWidth = textWidth(wordText);
    float wordHeight = LINE_HEIGHT;
    
    return mouseX >= xPosition && 
           mouseX <= xPosition + wordWidth &&
           mouseY >= displayY - wordHeight + 5 && 
           mouseY <= displayY + 5;
  }
}

//Array to store all words
ArrayList<Word> words;
float scrollY = 0;  // Current scroll offset
float minScrollY = 0;  // Minimum scroll position (top of essay)
float maxScrollY = 0;  // Maximum scroll position (bottom of essay)

//Highlighting variables

//Integer is like int except it can store null.
Integer firstSelectedWordIndex = null;  // Index of first clicked word (null if none selected)

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

//Calculate positions for all words
void layoutWords() {
  float textAreaX = (CANVAS_WIDTH - TEXT_AREA_WIDTH) / 2;
  float textAreaY = (CANVAS_HEIGHT - TEXT_AREA_HEIGHT) / 2;
  
  float currentX = textAreaX + TEXT_MARGIN;
  float currentY = textAreaY + TEXT_MARGIN + LINE_HEIGHT;
  int currentLine = 0;
  
  textSize(16);
  
  for (Word w : words) {
    float wordWidth = textWidth(w.wordText + " ");
    
    // heck if word fits on current line
    if (currentX + wordWidth > textAreaX + TEXT_AREA_WIDTH - TEXT_MARGIN) {
      //Move to next line
      currentLine++;
      currentY += LINE_HEIGHT;
      currentX = textAreaX + TEXT_MARGIN;
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
  
  float textAreaY = (CANVAS_HEIGHT - TEXT_AREA_HEIGHT) / 2;
  float topMargin = textAreaY + TEXT_MARGIN + LINE_HEIGHT;
  
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


//Handle scrolling with mouse wheel
void mouseWheel(MouseEvent event) {
  float scrollAmount = event.getCount() * SCROLL_SPEED;
  scrollY += scrollAmount;
  
  scrollY = constrain(scrollY, maxScrollY, minScrollY);
}

//Handle mouse clicks for highlighting
void mousePressed() {
  //Check if clicking on unhighlight button
  if (mouseX >= 0 && mouseX <= UNHIGHLIGHT_BUTTON_SIZE &&
      mouseY >= 0 && mouseY <= UNHIGHLIGHT_BUTTON_SIZE) {
    unhighlightAll();
    firstSelectedWordIndex = null;
    return;
  }
  
  //Check if clicking on a word
  int clickedWordIndex = getWordAtMousePosition();
  
  if (clickedWordIndex != -1) {
    if (firstSelectedWordIndex == null) {
      // First click - select this word
      firstSelectedWordIndex = clickedWordIndex;
      unhighlightAll();
    } else {
      // Second click - highlight range between first and second word
      int startIndex = min(firstSelectedWordIndex, clickedWordIndex);
      int endIndex = max(firstSelectedWordIndex, clickedWordIndex);
      
      highlightRange(startIndex, endIndex);
      firstSelectedWordIndex = null;  // Reset for next selection
    }
  } else {
    //Clicked outside words - reset selection
    unhighlightAll();
    firstSelectedWordIndex = null;
  }
}

//Find which word (if any) is at the current mouse position
int getWordAtMousePosition() {
  float textAreaX = (CANVAS_WIDTH - TEXT_AREA_WIDTH) / 2;
  float textAreaY = (CANVAS_HEIGHT - TEXT_AREA_HEIGHT) / 2;
  
  // Check if mouse is within text area
  if (mouseX < textAreaX || mouseX > textAreaX + TEXT_AREA_WIDTH ||
      mouseY < textAreaY || mouseY > textAreaY + TEXT_AREA_HEIGHT) {
    return -1;
  }
  
  //Check each word to see if mouse is over it
  for (int i = 0; i < words.size(); i++) {
    if (words.get(i).isMouseOver(scrollY, mouseX, mouseY)) {
      return i;
    }
  }
  
  return -1;
}

//Highlight a range of words from startIndex to endIndex (inclusive)
void highlightRange(int startIndex, int endIndex) {
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

//Draw the unhighlight button in the top left corner
void drawUnhighlightButton() {
  fill(200);
  stroke(150);
  rect(0, 0, UNHIGHLIGHT_BUTTON_SIZE, UNHIGHLIGHT_BUTTON_SIZE);
  
  fill(100);
  textSize(12);
  textAlign(CENTER, CENTER);
  text("X", UNHIGHLIGHT_BUTTON_SIZE / 2, UNHIGHLIGHT_BUTTON_SIZE / 2);
  
  //Reset text alignment
  textAlign(LEFT, BASELINE);
}
