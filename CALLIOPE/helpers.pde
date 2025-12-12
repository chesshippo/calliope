
//The following function loads the dictionary file and fills the dictionary array with words.
void SetupSpellcheck()
{
  String[] dictionaryArray = loadStrings("words_alpha.txt");
  
  for (String s : dictionaryArray)
  {
    dictionary.add(s);
  }
}
//The following function switches the program to the essay editing screen.
void EnterEssayEditor()
{
  startButton.setVisible(false);
  infoButton.setVisible(false);
  backButton.setVisible(true);
  controlsWindow.setVisible(true);

  stage = WindowStage.EssayHelp;
}

//The following function switches the program back to the home screen.
void Back()
{
  startButton.setVisible(true);
  infoButton.setVisible(true);
  backButton.setVisible(false);
  controlsWindow.setVisible(false);

  stage = WindowStage.Home;
}

//The following function sends the user's request and highlighted text to Gemini and gets feedback.
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

  feedbackScrollY = 0;

  geminiResponse = PromptGeminiForFeedback(essay, highlightedText, userRequest);

  parseAndHighlightGeminiResponse();
  
  calculateFeedbackScrollBounds();
}

//The following function loads a new essay from a file path and refreshes the display.
void RefreshEssayText()
{
  String filePath = essayPathField.getText();

  //The following removes quotes from the file path if they are present.
  if (filePath.contains("\""))
  {
    filePath = filePath.substring(1, filePath.length() - 1);
  }

  println(filePath);

  String[] fullEssay = loadStrings(filePath);
  printArray(fullEssay);

  //The following combines all lines of the essay into one string.
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

//The following function splits the essay string into individual words and creates Word objects.
void PutEssayIntoWords()
{
  try
  {
    words.clear();
    String[] wordStrings = split(essay, " ");

    //The following loops through each word string and creates a Word object if it is not empty.
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

//The following function checks each word in the essay against the dictionary and highlights misspelled words.
void SpellCheckEssay()
{
  for (int i = 0; i < words.size(); i++)
  {
    String newWord = "";
    ArrayList<Character> punctuation = new ArrayList();

    //The following adds characters to skip so it doesnt confuse spellcheck.
    punctuation.add(':');
    punctuation.add('\"');
    punctuation.add('[');
    punctuation.add(']');
    punctuation.add('(');
    punctuation.add(')');
    punctuation.add('.');
    punctuation.add('?');
    punctuation.add(',');
    punctuation.add('\'');
    punctuation.add('!');
    punctuation.add(';');
    punctuation.add('@');
    punctuation.add('\\');
    punctuation.add('/');
    punctuation.add('’');
    punctuation.add('\'');
    punctuation.add('“');
    punctuation.add('”');
    punctuation.add('0');
    punctuation.add('1');
    punctuation.add('2');
    punctuation.add('3');
    punctuation.add('4');
    punctuation.add('5');
    punctuation.add('6');
    punctuation.add('7');
    punctuation.add('8');
    punctuation.add('9');
    
    
    


    //The following removes punctuation from the word so it can be checked against the dictionary.
    //We go through each character in the word and only add it to newWord if it's not in the punctuation list.
    //This way "word," becomes "word" and "don't" becomes "dont" for dictionary checking.
    //We keep the original wordText intact for display, we just create a clean version for checking.
    for (int j = 0; j < words.get(i).wordText.length(); j++)
    {

      if (!(punctuation.contains(words.get(i).wordText.charAt(j))))
      {
        newWord += words.get(i).wordText.charAt(j);

        if (words.get(i).wordText.charAt(j) == '\'')
        {
          println("apostrophe");
        }
      } 
    }

    newWord = newWord.toLowerCase();

    //The following highlights the word in red if it is not found in the dictionary.
    //We use isProgramHighlighted instead of isHighlighted so it doesn't interfere with user highlights.
    if (!dictionary.contains(newWord))
    {
      words.get(i).isProgramHighlighted = true;
      words.get(i).programHighlightColour = color(255, 0, 0);
      println(newWord, words.get(i).wordText);
    }
  }
}

//The following function unhighlights all words, both user highlights and program highlights.
void unhighlightAll()
{
  for (Word w : words)
  {
    w.isHighlighted = false;
    w.isProgramHighlighted = false;
  }
}
