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
  
  stage = WindowStage.EssayHelp;
}
