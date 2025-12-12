//The following function handles mouse wheel scrolling for both the essay and feedback panel.
void mouseWheel(MouseEvent event) {
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  float scrollAmount = event.getCount() * SCROLL_SPEED;
  
  //The following checks if the mouse is over the feedback panel.
  boolean mouseOverFeedback = (mouseX >= FEEDBACK_PANEL_X && 
                                mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
                                mouseY >= FEEDBACK_PANEL_Y && 
                                mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT);
  
  if (mouseOverFeedback) {
    float newFeedbackScrollY = feedbackScrollY + scrollAmount;
    feedbackScrollY = constrain(newFeedbackScrollY, minFeedbackScrollY, maxFeedbackScrollY);
  } else {
    //The following scrolls the essay if the mouse is not over the feedback panel.
    float newScrollY = scrollY + scrollAmount;
    scrollY = constrain(newScrollY, maxScrollY, minScrollY);
  }
}

//The following function handles mouse clicks for highlighting text.
void mousePressed() {
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  //The following checks if the user clicked on the unhighlight button.
  if (mouseX >= 0 && mouseX <= UNHIGHLIGHT_BUTTON_SIZE &&
      mouseY >= 0 && mouseY <= UNHIGHLIGHT_BUTTON_SIZE) {
    unhighlightUser();
    firstSelectedWordIndex = null;
    return;
  }
  
  //The following unhighlights if the user clicked in the feedback panel.
  if (mouseX >= FEEDBACK_PANEL_X && mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
      mouseY >= FEEDBACK_PANEL_Y && mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT) {
    unhighlightUser();
    firstSelectedWordIndex = null;
    return;
  }
  
  int clickedWordIndex = getWordAtMousePosition();
  
  //The following handles clicking on words to highlight ranges.
  if (clickedWordIndex != -1) {
    if (firstSelectedWordIndex == null) {
      firstSelectedWordIndex = clickedWordIndex;
    } else if (firstSelectedWordIndex == clickedWordIndex) {
      unhighlightUser();
      firstSelectedWordIndex = null;
    } else {
      int startIndex = min(firstSelectedWordIndex, clickedWordIndex);
      int endIndex = max(firstSelectedWordIndex, clickedWordIndex);
      
      highlightRange(startIndex, endIndex);
      firstSelectedWordIndex = null;
    }
  } else {
    //The following unhighlights if the user clicked outside of any word.
    unhighlightUser();
    firstSelectedWordIndex = null;
  }
}
