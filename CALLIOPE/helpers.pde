import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import static java.nio.file.StandardCopyOption.REPLACE_EXISTING; //import all this crap for the file download stuff.
//again since processing is just java under the hood, you can import java libraries and use them.

void SetupSpellcheck()//gets called right at the beginning of the program to set up spellcheck
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
  //it takes the existing one stored in the data folder and copies it to the downloads folder
  
  String home = System.getProperty("user.home"); //find home directory and then attatch downloads to get to downloads folder
  String downloads = home + File.separator + "Downloads" + File.separator; //File.seperator makes this code compatible with windows and mac
  String manualPath = dataPath("Calliope.pdf"); //data path gets the global path from a file in the data folder
  Path manual = Paths.get(manualPath);
  Path destination = Paths.get(downloads + "Calliope.pdf");
  
  try
  {
    Files.copy(manual, destination, REPLACE_EXISTING);
    downloadLabel.setText("Success! Check your downloads folder");// :)
  }
  catch (Exception e)
  {
    downloadLabel.setText("Something went wrong."); // :(
    println(e);
  }
}

//these 3 functions just control what gets set to visible and when, called for start, info, and back buttons and stuff
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


void AskGemini() //this is what gets called in the gui tab
{
  //it is called on a seperate thread so it runs on its own clock, which lets the stuatus text get updated instantly.
  //if its run normally, the line below wont appear to happen, the gui wont update by the time this function is done excecuting, and at that point the status
  //has already been set to an empty string, so from the user's perspective it looks like there is no status text at all
  promptStatusLabel.setText("Processing request. Please be patient.");
  String userRequest = askAwayField.getText().trim();
  String highlightedText = getHighlightedText();

  if (highlightedText.length() == 0) {
    //assume the user wants to talk about the essay in general if nothing is highlighted, the highlighted text is just the essay
    highlightedText = essay;
  }

  if (userRequest.length() == 0) {
    geminiResponse = "Please enter a question or request in the text field.";
    return;
  }
  
  feedbackScrollY = 0;

  //get gemini response and go through it and highlight it and stuff!!!!!
  geminiResponse = PromptGeminiForFeedback(essay, highlightedText, userRequest);
  
  parseAndHighlightGeminiResponse();
  
  calculateFeedbackScrollBounds();
  
  if (geminiResponse != "") //if its an empty string, we know the usage limit has been reached, so don't overide the already displayed message about that
  {
    promptStatusLabel.setText("");
  }
  
}

void RefreshEssayText()// for the refresh button. grabs the text file and converts it into word objects, then puts those on screen
{
  String filePath = essayPathField.getText();

  if (filePath.contains("\""))
  {
    filePath = filePath.substring(1, filePath.length() - 1);
  }

  String[] fullEssay = loadStrings(filePath);
  
  if (fullEssay == null)
  {
    filepathStatusLabel.setText("Invalid filepath. Ensure file exists and try again."); //tell the user if its invalid
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
  
  //reset the text area thing so new words are shown
  essay = newEssay;
  PutEssayIntoWords();
  layoutWords();
  calculateScrollBounds();
  redraw();
}

void PutEssayIntoWords() //puts the text file into word objects
{
  try
  {
    words.clear(); //get rid of current words and make new ones
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
    println("error", e);
  }
}

void SpellCheckEssay() //spellcheck literally just uses the contains method of the arraylist class
{
  for (int i = 0; i < words.size(); i++)
  {
    String newWord = "";
    
    
    

    //if the dictionary arraylist contains the word, it is spelled correctly, if not, then its wrong
    for (int j = 0; j < words.get(i).wordText.length(); j++)
    {

      if (!(punctuation.contains(words.get(i).wordText.charAt(j)))) //skip stuff in the puncuation arraylsit
      {
        newWord += words.get(i).wordText.charAt(j);
      } 
    }

    newWord = newWord.toLowerCase();

    if (!dictionary.contains(newWord))
    {
      words.get(i).isProgramHighlighted = true;
      words.get(i).programHighlightColour = color(255, 0, 0);
    }
  }
}

void unhighlightAll()//unhighlight everything INCLUDING program-highlighted stuff, for the dismiss highlight button
{
  for (Word w : words)
  {
    w.isHighlighted = false;
    w.isProgramHighlighted = false;
  }
}
