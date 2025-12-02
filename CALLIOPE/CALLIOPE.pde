import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;
import g4p_controls.*;

String API_KEY;
WindowStage stage = WindowStage.Home;

void setup()
{
  createGUI();
    
  API_KEY = loadStrings("api_key.txt")[0];
  size(1000, 650);
  startButton.setVisible(true);
  infoButton.setVisible(true);
  backButton.setVisible(false);
  controlsWindow.setVisible(false);
  background(0, 0, 50);
}

void draw()
{
  background(0, 0, 50);
  if (stage == WindowStage.Home)
  {
    fill(255, 255, 255);
    textSize(100);
    textAlign(CENTER);
    text("CALLIOPE", width / 2, 200);
  }
  else if (stage == WindowStage.EssayHelp)
  {
    //get the base gui
    
    //essay viewing window
    
    

  }
  println(stage);
}
