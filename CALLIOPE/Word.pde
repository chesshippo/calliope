class Word { //word class that powers the word objects that get displayed on the screen
  String wordText; //text the word contains
  int positionInEssay;
  int lineNumber;
  float xPosition;
  float yPosition;
  boolean isHighlighted; //true if its highlighted by the user
  final color userHighlightColour; //this is just set the the highlight color constant from before
  color programHighlightColour; //this depends on whats highlighting it
  boolean isProgramHighlighted; //tru when the program highlights is
  
  Word(String text, int pos) { //CONSTRUCTION ZONE
    wordText = text;
    positionInEssay = pos;
    lineNumber = 0; 
    xPosition = 0; 
    yPosition = 0;   
    isHighlighted = false;
    userHighlightColour = HIGHLIGHT_COLOR;
  }
  
  void display(float scrollOffset) { //disply the word on the screen, take how much the user has scroll as a parameter to display at the true y position, and get cut off by clip if its too far
    float adjustedY = yPosition + scrollOffset;
    
    if (isProgramHighlighted) {// program highlight first, then user highlight
      textSize(16);
      float wordWidth = textWidth(wordText);
      float wordHeight = LINE_HEIGHT;
      
      fill(programHighlightColour);
      noStroke();
      rect(xPosition, adjustedY - wordHeight + 5, wordWidth, wordHeight);
    }
    if (isHighlighted)//since user highlight is a bit transparent, theres a cool kind of effect where you can highlight sections that have already been highlighted by the program.
    {
      textSize(16);
      float wordWidth = textWidth(wordText);
      float wordHeight = LINE_HEIGHT;
      
      fill(userHighlightColour);
      noStroke();
      rect(xPosition, adjustedY - wordHeight + 5, wordWidth, wordHeight);
    }
    
    fill(0);
    text(wordText, xPosition, adjustedY);
  }
  
  boolean isMouseOver(float scrollOffset, float mouseX, float mouseY) { //checks if the mouse is above a certain word
    textSize(16);
    float wordWidth = textWidth(wordText);
    float wordHeight = LINE_HEIGHT;
    float adjustedY = yPosition + scrollOffset;
    
    return mouseX >= xPosition && 
           mouseX <= xPosition + wordWidth &&
           mouseY >= adjustedY - wordHeight + 5 && 
           mouseY <= adjustedY + 5;
  }
}
