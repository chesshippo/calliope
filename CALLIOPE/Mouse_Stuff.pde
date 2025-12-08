void mouseWheel(MouseEvent event) {
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
  //Only allow scrolling when in essay editing screen
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
  //Only allow scrolling when in essay editing screen
>>>>>>> parent of 011f3b1 (SpellCheck+New)
  if (stage != WindowStage.EssayHelp) {
    return;
  }
  
  float scrollAmount = event.getCount() * SCROLL_SPEED;
  
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
  //Check if mouse is over feedback panel
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
  //Check if mouse is over feedback panel
>>>>>>> parent of 011f3b1 (SpellCheck+New)
  boolean mouseOverFeedback = (mouseX >= FEEDBACK_PANEL_X && 
                                mouseX <= FEEDBACK_PANEL_X + FEEDBACK_PANEL_WIDTH &&
                                mouseY >= FEEDBACK_PANEL_Y && 
                                mouseY <= FEEDBACK_PANEL_Y + FEEDBACK_PANEL_HEIGHT);
  
  if (mouseOverFeedback) {
    float newFeedbackScrollY = feedbackScrollY + scrollAmount;
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    //Constrain is just a min max
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
    //Constrain is just a min max
>>>>>>> parent of 011f3b1 (SpellCheck+New)
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
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    //Clicked in feedback panel, unhighlight everything
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
    //Clicked in feedback panel, unhighlight everything
>>>>>>> parent of 011f3b1 (SpellCheck+New)
    unhighlightAll();
    firstSelectedWordIndex = null;
    return;
  }
  
  //Check if clicking on a word
  int clickedWordIndex = getWordAtMousePosition();
  
  if (clickedWordIndex != -1) {
    if (firstSelectedWordIndex == null) {
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
>>>>>>> parent of 011f3b1 (SpellCheck+New)
      // First click, unhighlight any previous selection and select this word as start
      unhighlightAll();
      firstSelectedWordIndex = clickedWordIndex;
    } else {
      // Second click, highlight range between first and second word
<<<<<<< HEAD
=======
      firstSelectedWordIndex = clickedWordIndex;
    } else if (firstSelectedWordIndex == clickedWordIndex) {
      unhighlightAll();
      firstSelectedWordIndex = null;
    } else {
>>>>>>> Stashed changes
=======
      firstSelectedWordIndex = clickedWordIndex;
    } else if (firstSelectedWordIndex == clickedWordIndex) {
      unhighlightAll();
      firstSelectedWordIndex = null;
    } else {
>>>>>>> Stashed changes
=======
>>>>>>> parent of 011f3b1 (SpellCheck+New)
      int startIndex = min(firstSelectedWordIndex, clickedWordIndex);
      int endIndex = max(firstSelectedWordIndex, clickedWordIndex);
      
      highlightRange(startIndex, endIndex);
      firstSelectedWordIndex = null;  // Reset for next selection
    }
  } else {
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    //Clicked outside words, unhighlight everything and reset selection
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
    //Clicked outside words, unhighlight everything and reset selection
>>>>>>> parent of 011f3b1 (SpellCheck+New)
    unhighlightAll();
    firstSelectedWordIndex = null;
  }
}
