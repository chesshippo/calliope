
void SetupSpellcheck()
{
  String[] dictionaryArray = loadStrings("words.txt");

  for (String s : dictionaryArray)
  {
    dictionary.add(s);
  }
  
  dictionaryArray = loadStrings("words_alpha.txt");
  
  for (String s : dictionaryArray)
  {
    dictionary.add(s);
  }
}
void EnterEssayEditor()
{
  startButton.setVisible(false);
  infoButton.setVisible(false);
  backButton.setVisible(true);
  controlsWindow.setVisible(true);

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

  feedbackScrollY = 0;

  geminiResponse = PromptGeminiForFeedback(essay, highlightedText, userRequest);

  calculateFeedbackScrollBounds();
}

void RefreshEssayText()
{
  String filePath = essayPathField.getText();

  if (filePath.contains("\""))
  {
    filePath = filePath.substring(1, filePath.length() - 1);
  }

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

  //characters to skip so it doesnt confuse spellcheck
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


    for (int j = 0; j < words.get(i).wordText.length(); j++)
    {

      if (!(punctuation.contains(words.get(i).wordText.charAt(j))))
      {
        newWord += words.get(i).wordText.charAt(j);

        if (words.get(i).wordText.charAt(j) == '\'')
        {
          println("apostrophe");
        }
        //println(words.get(i).wordText.charAt(j));
      } else
      {
        println("skipped punctuation");
      }
    }

    newWord = newWord.toLowerCase();

    if (!dictionary.contains(newWord))
    {
      words.get(i).isProgramHighlighted = true;
      words.get(i).programHighlightColour = color(255, 0, 0);
      println(newWord, words.get(i).wordText);
    }
  }
}

void unhighlightAll()
{
  for (Word w : words)
  {
    w.isHighlighted = false;
    w.isProgramHighlighted = false;
  }
}
