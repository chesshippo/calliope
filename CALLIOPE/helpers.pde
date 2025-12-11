import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

void SetupSpellcheck()
{
  String[] dictionaryArray = loadStrings("words_alpha.txt");
  
  for (String s : dictionaryArray)
  {
    dictionary.add(s);
  }
}

void DownloadUserManual()
{
  //if the user needs more on how to use the program, they can easily download the user manual.
  
  String home = System.getProperty("user.home"); //find home directory and then attatch downloads to get to downloads folder
  String downloads = home + "\\Downloads\\";
  String manualPath = dataPath("manual.txt");
  Path manual = Paths.get(manualPath);
  Path destination = Paths.get(downloads + "manual.txt");
  
  try
  {
    Files.copy(manual, destination, REPLACE_EXISTING);
    downloadLabel.setText("Success! Check your downloads folder");
  }
  catch (Exception e)
  {
    downloadLabel.setText("Something went wrong.");
    println(e);
  }
}


void EnterEssayEditor()
{
  startButton.setVisible(false);
  infoButton.setVisible(false);
  backButton.setVisible(true);
  controlsWindow.setVisible(true);
  downloadLabel.setVisible(false);
  downloadLabel.setText("");
  manualDownloadButton.setVisible(false);

  stage = WindowStage.EssayHelp;
}

void Back()
{
  startButton.setVisible(true);
  infoButton.setVisible(true);
  backButton.setVisible(false);
  controlsWindow.setVisible(false);
  manualDownloadButton.setVisible(false);
  downloadLabel.setText("");
  downloadLabel.setVisible(false);

  stage = WindowStage.Home;
}

void EnterInfoScreen()
{
  backButton.setVisible(true);
  startButton.setVisible(false);
  infoButton.setVisible(false);
  manualDownloadButton.setVisible(true);
  downloadLabel.setVisible(true);
  downloadLabel.setText("");
  
  stage = WindowStage.Info;
}


void AskGemini()
{
  promptStatusLabel.setText("Processing request. Please be patient.");
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
  
  feedbackScrollY = 0;

  geminiResponse = PromptGeminiForFeedback(essay, highlightedText, userRequest);
  
  parseAndHighlightGeminiResponse();
  
  calculateFeedbackScrollBounds();
  
  if (geminiResponse != "") //if its an empty string, we know the usage limit has been reached, so don't overide the already displayed message about that
  {
    promptStatusLabel.setText("");
  }
  
}

void RefreshEssayText()
{
  String filePath = essayPathField.getText();

  if (filePath.contains("\""))
  {
    filePath = filePath.substring(1, filePath.length() - 1);
  }

  String[] fullEssay = loadStrings(filePath);
  
  if (fullEssay == null)
  {
    filepathStatusLabel.setText("Invalid filepath. Ensure file exists and try again.");
    return;
  }
  else
  {
    filepathStatusLabel.setText("");
  }
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
