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
    // Calculate adjusted Y position based on scroll offset
    float adjustedY = yPosition + scrollOffset;
    
    //Draw background if highlighted
    if (isHighlighted) {
      textSize(16);
      float wordWidth = textWidth(wordText);
      float wordHeight = LINE_HEIGHT;
      
      fill(backgroundColor);
      noStroke();
      rect(xPosition, adjustedY - wordHeight + 5, wordWidth, wordHeight);
    }
    
    //Draw text
    fill(0);
    text(wordText, xPosition, adjustedY);
  }
  
  //Check if mouse click is within this word's bounds (adjusted for scroll)
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
