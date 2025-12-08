  void EnterEssayEditor()
{
    startButton.setVisible(false);
    infoButton.setVisible(false);
    backButton.setEnabled(true);
    backButton.setVisible(true);
    backButton.setOpaque(true);
    controlsWindow.setVisible(true);
    
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
  
  feedbackScrollY = 0;
  
  geminiResponse = PromptGeminiForFeedback(essay, highlightedText, userRequest);
  
  calculateFeedbackScrollBounds();
}
<<<<<<< Updated upstream
=======

void RefreshEssayText()
{
  println("refreshing started");
  String filePath = essayPathField.getText();
  println(filePath);
  
  String[] fullEssay = loadStrings(filePath);
  printArray(fullEssay);
  
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
  for (int i = 0; i < words.size(); i++)
  {
    String newWord = "";
    ArrayList<Character> punctuation = new ArrayList();
    
    punctuation.add(':');
    punctuation.add('.');
    punctuation.add('?');
    punctuation.add(',');
    punctuation.add('\'');
    punctuation.add('!');
    punctuation.add(';');
    punctuation.add('@');
    
    
    for (int j = 0; j < words.get(i).wordText.length(); j++)
    {
      
      if (!(punctuation.contains(words.get(i).wordText.charAt(j))))
      {
        newWord += words.get(i).wordText.charAt(j);
        
        println(words.get(i).wordText.charAt(j));
      }
      else
      {
        println("skipped punctuation");
      }
    }
    
    newWord = newWord.toLowerCase();
    
    if (!dictionary.contains(newWord))
    {
      words.get(i).isHighlighted = true;
      words.get(i).backgroundColor = color(255, 0, 0);
      println(newWord, words.get(i).wordText);
    }
  }
}
>>>>>>> Stashed changes
