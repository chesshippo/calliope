class Word {
  String wordText;
  int positionInEssay;
  int lineNumber;
  float xPosition;
  float yPosition;
  boolean isHighlighted;
  final color userHighlightColour;
  color programHighlightColour;
  boolean isProgramHighlighted;
  
  Word(String text, int pos) {
    wordText = text;
    positionInEssay = pos;
    lineNumber = 0; 
    xPosition = 0; 
    yPosition = 0;   
    isHighlighted = false;
    userHighlightColour = HIGHLIGHT_COLOR;
    
    
  }
  
  void display(float scrollOffset) {
    float adjustedY = yPosition + scrollOffset;
    
    if (isProgramHighlighted) {
      textSize(16);
      float wordWidth = textWidth(wordText);
      float wordHeight = LINE_HEIGHT;
      
      fill(programHighlightColour);
      noStroke();
      rect(xPosition, adjustedY - wordHeight + 5, wordWidth, wordHeight);
    }
    if (isHighlighted)
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
  
  boolean isMouseOver(float scrollOffset, float mouseX, float mouseY) {
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
