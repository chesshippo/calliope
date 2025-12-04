import pt.tumba.spell.SpellChecker;


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
  
  println("request received");
  println("highlighted text: " + highlightedText);
  println("user request: " + userRequest);
  
  //Reset feedback scroll position for new response
  feedbackScrollY = 0;
  
  //Get feedback from Gemini with full essay context
  geminiResponse = PromptGeminiForFeedback(essay, highlightedText, userRequest);
  
  //Calculate feedback content height and scroll bounds
  calculateFeedbackScrollBounds();
}

//get the text from the user's text file

void RefreshEssayText()
{
  println("refreshing started");
  String filePath = essayPathField.getText();
  println(filePath);
  
  String[] fullEssay = loadStrings(filePath);
  printArray(fullEssay);
  //make everything into one line so the program can handle it
  
  String newEssay = "";
  
  for (String essayFragment : fullEssay)
  {
    newEssay += " " + essayFragment;
  }
  
  essay = newEssay;
  PutEssayIntoWords();
  layoutWords();
  calculateScrollBounds();
  redraw();
}

void PutEssayIntoWords()
{
  //Puts essay into words (split by spaces to preserve punctuation)
  try
  {
    words.clear();
    String[] wordStrings = split(essay, " ");
    
    for (int i = 0; i < wordStrings.length; i++) {
      if (wordStrings[i].length() > 0) 
      { 
        words.add(new Word(wordStrings[i], i));
      }
    }
  }
  catch (NullPointerException e)
  {
    println("Error, double check your text file or replace it altogether");
  }
  
  for (Word w : words)
  {
    println(w.wordText);
  }
}

void SpellCheckEssay()
{
  for (Word w : words)
  {
    SpellChecker checker = new SpellChecker();
    checker.initialize();
    
    String correction = checker.spellCheckWord(w.wordText);
    
    println(correction);
  }
}
