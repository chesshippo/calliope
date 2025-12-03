void EnterEssayEditor()
{
    startButton.setVisible(false);
    infoButton.setVisible(false);
    backButton.setVisible(true);
    controlsWindow.setVisible(true);
    
    //enter editing screen
    stage = WindowStage.EssayHelp;
}

void Back()
{
  startButton.setVisible(true);
  infoButton.setVisible(true);
  backButton.setVisible(false);
  controlsWindow.setVisible(false);
  
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
