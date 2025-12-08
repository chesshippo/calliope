void mouseWheel(MouseEvent event) {
<<<<<<< Updated upstream
  //Only allow scrolling when in essay editing screen
=======
>>>>>>> Stashed changes
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  float scrollAmount = event.getCount() * SCROLL_SPEED;
  
<<<<<<< Updated upstream
  //Check if mouse is over feedback panel
=======
>>>>>>> Stashed changes
  boolean mouseOverFeedback = (mouseX >= FEEDBACK_PANEL_X && 
                                mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
                                mouseY >= FEEDBACK_PANEL_Y && 
                                mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT);
  
  if (mouseOverFeedback) {
    float newFeedbackScrollY = feedbackScrollY + scrollAmount;
<<<<<<< Updated upstream
    //Constrain is just a min max
=======
>>>>>>> Stashed changes
    feedbackScrollY = constrain(newFeedbackScrollY, minFeedbackScrollY, maxFeedbackScrollY);
  } else {

    float newScrollY = scrollY + scrollAmount;
    scrollY = constrain(newScrollY, maxScrollY, minScrollY);
  }
}

void mousePressed() {
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  if (mouseX >= 0 && mouseX <= UNHIGHLIGHT_BUTTON_SIZE &&
      mouseY >= 0 && mouseY <= UNHIGHLIGHT_BUTTON_SIZE) {
    unhighlightAll();
    firstSelectedWordIndex = null;
    return;
  }
  
  if (mouseX >= FEEDBACK_PANEL_X && mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
      mouseY >= FEEDBACK_PANEL_Y && mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT) {
<<<<<<< Updated upstream
    //Clicked in feedback panel, unhighlight everything
=======
>>>>>>> Stashed changes
    unhighlightAll();
    firstSelectedWordIndex = null;
    return;
  }
  
  int clickedWordIndex = getWordAtMousePosition();
  
  if (clickedWordIndex != -1) {
    if (firstSelectedWordIndex == null) {
<<<<<<< Updated upstream
      // First click, unhighlight any previous selection and select this word as start
      unhighlightAll();
      firstSelectedWordIndex = clickedWordIndex;
    } else {
      // Second click, highlight range between first and second word
=======
      firstSelectedWordIndex = clickedWordIndex;
    } else if (firstSelectedWordIndex == clickedWordIndex) {
      unhighlightAll();
      firstSelectedWordIndex = null;
    } else {
>>>>>>> Stashed changes
      int startIndex = min(firstSelectedWordIndex, clickedWordIndex);
      int endIndex = max(firstSelectedWordIndex, clickedWordIndex);
      
      highlightRange(startIndex, endIndex);
      firstSelectedWordIndex = null;
    }
  } else {
<<<<<<< Updated upstream
    //Clicked outside words, unhighlight everything and reset selection
=======
>>>>>>> Stashed changes
    unhighlightAll();
    firstSelectedWordIndex = null;
  }
}
