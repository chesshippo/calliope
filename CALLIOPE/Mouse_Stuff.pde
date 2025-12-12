void mouseWheel(MouseEvent event) { //when the user scrolls we set how much they scroll into scrollAmount and track that
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  float scrollAmount = event.getCount() * SCROLL_SPEED;
  
  boolean mouseOverFeedback = (mouseX >= FEEDBACK_PANEL_X && 
                                mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
                                mouseY >= FEEDBACK_PANEL_Y && 
                                mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT);
  
  if (mouseOverFeedback) {
    float newFeedbackScrollY = feedbackScrollY + scrollAmount;
    feedbackScrollY = constrain(newFeedbackScrollY, minFeedbackScrollY, maxFeedbackScrollY);
  } else {

    float newScrollY = scrollY + scrollAmount;
    scrollY = constrain(newScrollY, maxScrollY, minScrollY); //the maximum and minimum the words can be moved up by is controlled heree, makes it so they don't just keep scrolling forever off the screen
  }
}

void mousePressed() { //when we click the mouse, we wanna get word it clicked on to highlight
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  //check both panels to see where it was clicked
  if (mouseX >= 0 && mouseX <= UNHIGHLIGHT_BUTTON_SIZE &&
      mouseY >= 0 && mouseY <= UNHIGHLIGHT_BUTTON_SIZE) {
    unhighlightUser();
    firstSelectedWordIndex = null;
    return;
  }
  
  //unhighlight if you click ouside
  if (mouseX >= FEEDBACK_PANEL_X && mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
      mouseY >= FEEDBACK_PANEL_Y && mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT) {
    unhighlightUser();
    firstSelectedWordIndex = null;
    return;
  }
  
  int clickedWordIndex = getWordAtMousePosition(); //set the clicked word to this index variable. with the firstSelectedWordIndex, we have 2 indexes and a range to highlight
  
  if (clickedWordIndex != -1) {
    if (firstSelectedWordIndex == null) {
      firstSelectedWordIndex = clickedWordIndex;//first index is set if it was null already
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
    unhighlightUser();
    firstSelectedWordIndex = null;
  }
}
