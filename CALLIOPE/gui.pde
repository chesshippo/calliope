public void OnInfoClicked(GButton source, GEvent event) {
  println("infoButton - GButton >> GEvent." + event + " @ " + millis());
}

public void OnStartClicked(GButton source, GEvent event) {

  EnterEssayEditor();
  
}

public void OnBackClicked(GButton source, GEvent event) {
  Back();
}

synchronized public void win_draw1(PApplet appc, GWinData data) {
  appc.background(230);
}

public void OnAskGemini(GButton source, GEvent event) {
  AskGemini();
}

public void OnTypeInAskAwayField(GTextArea source, GEvent event) {
  println("askAwayField - GTextArea >> GEvent." + event + " @ " + millis());
}

<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
=======
>>>>>>> Stashed changes
public void OnTypedInEssayPathField(GTextField source, GEvent event) {
  println("essayPathField - GTextField >> GEvent." + event + " @ " + millis());
}

public void OnRefreshEssay(GButton source, GEvent event) {
  RefreshEssayText();
}

public void OnSpellcheckButtonClicked(GButton source, GEvent event) {
  SpellCheckEssay();
}
<<<<<<< Updated upstream

>>>>>>> Stashed changes


=======



>>>>>>> Stashed changes
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  infoButton = new GButton(this, 415, 530, 170, 70);
  infoButton.setText("INFO");
  infoButton.addEventHandler(this, "OnInfoClicked");
  startButton = new GButton(this, 415, 451, 170, 70);
  startButton.setText("START");
  startButton.addEventHandler(this, "OnStartClicked");
  backButton = new GButton(this, 21, 26, 80, 30);
  backButton.setText("Back");
  backButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  backButton.addEventHandler(this, "OnBackClicked");
  controlsWindow = GWindow.getWindow(this, "Calliope Controls", 0, 0, 300, 600, JAVA2D);
  controlsWindow.noLoop();
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "win_draw1");
  askGeminiBbutton = new GButton(controlsWindow, 96, 251, 80, 30);
  askGeminiBbutton.setText("Ask away!");
  askGeminiBbutton.addEventHandler(this, "OnAskGemini");
  askAwayField = new GTextArea(controlsWindow, 76, 162, 120, 80, G4P.SCROLLBARS_VERTICAL_ONLY);
  askAwayField.setOpaque(true);
  askAwayField.addEventHandler(this, "OnTypeInAskAwayField");
  controlsWindow.loop();
}

GButton infoButton; 
GButton startButton; 
GButton backButton; 
GWindow controlsWindow;
GButton askGeminiBbutton; 
GTextArea askAwayField; 
