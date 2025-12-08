class Word {
  String wordText;
  int positionInEssay;
  int lineNumber;
  float xPosition;
  float yPosition;
  boolean isHighlighted;
  color backgroundColor;
  
  Word(String text, int pos) {
    wordText = text;
    positionInEssay = pos;
    lineNumber = 0; 
    xPosition = 0; 
    yPosition = 0;   
    isHighlighted = false;
<<<<<<< Updated upstream
    backgroundColor = color(255);  //Default white background
=======
    backgroundColor = color(255);
    
    
>>>>>>> Stashed changes
  }
  
  void display(float scrollOffset) {
    float adjustedY = yPosition + scrollOffset;
    
    if (isHighlighted) {
      textSize(16);
      float wordWidth = textWidth(wordText);
      float wordHeight = LINE_HEIGHT;
      
      fill(backgroundColor);
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
