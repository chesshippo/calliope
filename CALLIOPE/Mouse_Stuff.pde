void mouseWheel(MouseEvent event) {
  float scrollAmount = event.getCount() * SCROLL_SPEED;
  scrollY += scrollAmount;
  scrollY = constrain(scrollY, maxScrollY, minScrollY); //implement after figuring out math for maxscrollY
  
  for (Word w : words)
  {
    if (scrollY >= maxScrollY || scrollY <= minScrollY)
    {
      w.yPosition += scrollAmount;      
    }
  }
}

//Handle mouse clicks for highlighting
void mousePressed() {
  //Check if clicking on unhighlight button
  if (mouseX >= 0 && mouseX <= UNHIGHLIGHT_BUTTON_SIZE &&
      mouseY >= 0 && mouseY <= UNHIGHLIGHT_BUTTON_SIZE) {
    unhighlightAll();
    firstSelectedWordIndex = null;
    return;
  }


  
  
  //Check if clicking on a word
  int clickedWordIndex = getWordAtMousePosition();
  
  if (clickedWordIndex != -1) {
    if (firstSelectedWordIndex == null) {
      // First click - select this word
      firstSelectedWordIndex = clickedWordIndex;
      unhighlightAll();
    } else {
      // Second click - highlight range between first and second word
      int startIndex = min(firstSelectedWordIndex, clickedWordIndex);
      int endIndex = max(firstSelectedWordIndex, clickedWordIndex);
      
      highlightRange(startIndex, endIndex);
      firstSelectedWordIndex = null;  // Reset for next selection
    }
  } else {
    //Clicked outside words - reset selection
    unhighlightAll();
    firstSelectedWordIndex = null;
  }
}
