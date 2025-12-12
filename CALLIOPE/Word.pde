//The following class represents a single word in the essay.
class Word {
  String wordText;
  int positionInEssay;
  int lineNumber;
  float xPosition;
  float yPosition;
  boolean isHighlighted;
  color userHighlightColour;
  color programHighlightColour;
  boolean isProgramHighlighted;
  
  //The following function creates a new Word object.
  Word(String text, int pos) {
    wordText = text;
    positionInEssay = pos;
    lineNumber = 0; 
    xPosition = 0; 
    yPosition = 0;   
    isHighlighted = false;
    userHighlightColour = HIGHLIGHT_COLOR;
    
    
  }
  
  //The following function displays the word on the screen with its highlight if it has one.
  void display(float scrollOffset) {
    float adjustedY = yPosition + scrollOffset;
    
    //The following draws the program highlight background if the word is program highlighted.
    if (isProgramHighlighted) {
      textSize(16);
      float wordWidth = textWidth(wordText);
      float wordHeight = LINE_HEIGHT;
      
      fill(programHighlightColour);
      noStroke();
      rect(xPosition, adjustedY - wordHeight + 5, wordWidth, wordHeight);
    }
    //The following draws the user highlight background if the word is user highlighted.
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
  
  //The following function checks if the mouse is over this word.
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
