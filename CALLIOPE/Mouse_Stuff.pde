void mouseWheel(MouseEvent event) {
  // Only allow scrolling when in essay editing screen
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  float scrollAmount = event.getCount() * SCROLL_SPEED;
  
  // Check if mouse is over feedback panel
  boolean mouseOverFeedback = (mouseX >= FEEDBACK_PANEL_X && 
                                mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
                                mouseY >= FEEDBACK_PANEL_Y && 
                                mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT);
  
  if (mouseOverFeedback) {
    float newFeedbackScrollY = feedbackScrollY + scrollAmount;
    //Constrain: minFeedbackScrollY (most negative, bottom) to maxFeedbackScrollY (0, top)
    feedbackScrollY = constrain(newFeedbackScrollY, minFeedbackScrollY, maxFeedbackScrollY);
  } else {

    float newScrollY = scrollY + scrollAmount;
    scrollY = constrain(newScrollY, maxScrollY, minScrollY);
  }
}

//Handle mouse clicks for highlighting
void mousePressed() {
  //Only handle highlighting when in essay editing screen
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  //Check if clicking on unhighlight button
  if (mouseX >= 0 && mouseX <= UNHIGHLIGHT_BUTTON_SIZE &&
      mouseY >= 0 && mouseY <= UNHIGHLIGHT_BUTTON_SIZE) {
    unhighlightAll();
    firstSelectedWordIndex = null;
    return;
  }
  
  //Don't handle clicks in feedback panel
  if (mouseX >= FEEDBACK_PANEL_X && mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
      mouseY >= FEEDBACK_PANEL_Y && mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT) {
    //Clicked in feedback panel - unhighlight everything
    unhighlightAll();
    firstSelectedWordIndex = null;
    return;
  }
  
  //Check if clicking on a word
  int clickedWordIndex = getWordAtMousePosition();
  
  if (clickedWordIndex != -1) {
    if (firstSelectedWordIndex == null) {
      // First click - unhighlight any previous selection and select this word as start
      unhighlightAll();
      firstSelectedWordIndex = clickedWordIndex;
    } else {
      // Second click - highlight range between first and second word
      int startIndex = min(firstSelectedWordIndex, clickedWordIndex);
      int endIndex = max(firstSelectedWordIndex, clickedWordIndex);
      
      highlightRange(startIndex, endIndex);
      firstSelectedWordIndex = null;  // Reset for next selection
    }
  } else {
    //Clicked outside words - unhighlight everything and reset selection
    unhighlightAll();
    firstSelectedWordIndex = null;
  }
}
