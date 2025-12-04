  void EnterEssayEditor()
{
    startButton.setVisible(false);
    infoButton.setVisible(false);
    // Make sure back button is visible and enabled
    backButton.setEnabled(true);
    backButton.setVisible(true);
    backButton.setOpaque(true);
    controlsWindow.setVisible(true);
    
    //enter editing screen
    stage = WindowStage.EssayHelp;
    
    //Highlight the first word when entering the editor
    if (words.size() > 0) {
      unhighlightAll();
      firstSelectedWordIndex = null;
      words.get(0).isHighlighted = true;
      words.get(0).backgroundColor = HIGHLIGHT_COLOR;
    }
}

void Back()
{
  startButton.setVisible(true);
  infoButton.setVisible(true);
  backButton.setVisible(false);
  controlsWindow.setVisible(false);
  
  //Unhighlight all words when going back
  unhighlightAll();
  firstSelectedWordIndex = null;
  
  stage = WindowStage.Home;
}

void AskGemini()
{
  String userRequest = askAwayField.getText().trim();
  String highlightedText = getHighlightedText();
  
  if (highlightedText.length() == 0) {
    geminiResponse = "Please highlight some text first before asking for feedback.";
    return;
  }
  
  if (userRequest.length() == 0) {
    geminiResponse = "Please enter a question or request in the text field.";
    return;
  }
  
  println("Request received!");
  println("Highlighted text: " + highlightedText);
  println("User request: " + userRequest);
  
  //Reset feedback scroll position for new response
  feedbackScrollY = 0;
  
  //Get feedback from Gemini with full essay context
  geminiResponse = PromptGeminiForFeedback(essay, highlightedText, userRequest);
  
  //Calculate feedback content height and scroll bounds
  calculateFeedbackScrollBounds();
}
