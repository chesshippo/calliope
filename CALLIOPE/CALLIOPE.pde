import g4p_controls.*;

//constant values (can't be changed)
final int CANVAS_WIDTH = 1000;
final int CANVAS_HEIGHT = 650;
final int TEXT_POSITION_X = 50;
final int TEXT_POSITION_Y = 100;
final int TEXT_AREA_WIDTH = 600;  //Width of the text display area
final int TEXT_AREA_HEIGHT = 400; //Height of the text display area
final int TEXT_MARGIN = 20;       //Margin around text within the display area
final int LINE_HEIGHT = 30;       //Vertical spacing between lines
final int WORD_SPACING = 10;      //Horizontal spacing between words
final int SCROLL_SPEED = 5;       //Pixels to scroll per key press
final int UNHIGHLIGHT_BUTTON_SIZE = 30;  //Size of unhighlight button
final color HIGHLIGHT_COLOR = color(173, 216, 230);  //Light blue for highlighting
String highlighted = "";

//Text content
String essay = "super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay super long essay super long essay super long essay super long essay super long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essaysuper long essay";

//Array to store all words
ArrayList<Word> words;
float scrollY = 0;  // Current scroll offset
float minScrollY = 0;  // Minimum scroll position (top of essay)
float maxScrollY = 1000;  // Maximum scroll position (bottom of essay)

//Highlighting variables

//Integer to store null instead of just plain old int
Integer firstSelectedWordIndex = null;  // Index of first clicked word (null if none selected)
String API_KEY;
WindowStage stage = WindowStage.Home;

void setup() {
  createGUI();
  size(1000, 650);
  
  API_KEY = loadStrings("api_key.txt")[0];
  
  //Puts essay into words (split by spaces to preserve punctuation)
  words = new ArrayList<Word>();
  String[] wordStrings = split(essay, ' ');
  
  for (int i = 0; i < wordStrings.length; i++) {
    if (wordStrings[i].length() > 0) {  // Skip empty strings
      words.add(new Word(wordStrings[i], i));
    }
  }
  
  layoutWords();
  
  calculateScrollBounds();
  
  
  controlsWindow.setVisible(false);
  backButton.setVisible(false);
}

void draw()
{
  if (stage == WindowStage.EssayHelp)
  {
    drawEditingScreen();
  }
  else if (stage == WindowStage.Home)
  {
    DrawHomeScreen();
  }
}

void DrawHomeScreen()
{
  background(0, 0, 50);
  textAlign(CENTER);
  textSize(100);
  text("CALLIOPE", width / 2, 250);
}

void drawEditingScreen() {
  background(0, 0, 50);
  
  //Draw the text display area (square/rectangle in center)
  
  fill(240);
  stroke(200);
  rect(TEXT_POSITION_X, TEXT_POSITION_Y, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);
  
  //Set up text rendering
  fill(0);
  textSize(16);
  textAlign(LEFT, BASELINE);
  
  
  //pushMatrix();
  
  ////clip makes it so all words not in the text area are hidden.
  ////The only way this is undone is with push and pop matrix
  ////Push matrix saves everything before the clip, and pop matrix restores it back.
  //clip(TEXT_POSITION_X, TEXT_POSITION_Y, TEXT_AREA_WIDTH, TEXT_AREA_HEIGHT);
  
  ////Display all words with scroll offset
  //for (Word w : words) {
  //  w.display(scrollY);
  //}
  
  //popMatrix();
  
  for (Word w : words)
  {
    if (!(w.yPosition > TEXT_POSITION_Y + TEXT_AREA_HEIGHT))
    {
      if (!(w.yPosition < TEXT_POSITION_Y + 10))
      {
        w.display();
      }
    }
  }
}

//Calculate positions for all words
void layoutWords() {
  
  float currentX = TEXT_POSITION_X + TEXT_MARGIN;
  float currentY = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  int currentLine = 0;
  
  textSize(16);
  
  for (Word w : words) {
    float wordWidth = textWidth(w.wordText + " ");
    
    // check if word fits on current line
    if (currentX + wordWidth > TEXT_POSITION_X + TEXT_AREA_WIDTH - TEXT_MARGIN) {
      //Move to next line
      currentLine++;
      currentY += LINE_HEIGHT;
      currentX = TEXT_POSITION_X + TEXT_MARGIN;
    }
    
    //Set word properties
    w.lineNumber = currentLine;
    w.xPosition = currentX;
    w.yPosition = currentY;
    
    //Move x position for next word
    currentX += wordWidth + WORD_SPACING;
  }
}

//Calculate scroll bounds based on content height
void calculateScrollBounds() {
  if (words.size() == 0) {
    minScrollY = 0;
    maxScrollY = 0;
    return;
  }
  
 
  float topMargin = TEXT_POSITION_Y + TEXT_MARGIN + LINE_HEIGHT;
  
  //Find the bottommost word
  float bottomY = 0;
  for (Word w : words) {
    if (w.yPosition > bottomY) {
      bottomY = w.yPosition;
    }
  }
  
  //Calculate scroll limits
  //When scrolled all the way up, first word should be at top margin, and vice versa
  float contentHeight = bottomY - topMargin + LINE_HEIGHT;
  float visibleHeight = TEXT_AREA_HEIGHT - (TEXT_MARGIN * 2);
  
  if (contentHeight <= visibleHeight) {
    //Content fits in view, no scrolling needed
    minScrollY = 0;
    maxScrollY = 0;
  } else {
    // ontent is taller than view
    minScrollY = 0;  // Can't scroll above the top
    maxScrollY = visibleHeight - contentHeight;  // Scroll down until bottom is visible
  }
}


//Find which word (if any) is at the current mouse position
int getWordAtMousePosition() {

  
  // Check if mouse is within text area
  if (mouseX < TEXT_POSITION_X || mouseX > TEXT_POSITION_X + TEXT_AREA_WIDTH ||
      mouseY < TEXT_POSITION_Y || mouseY > TEXT_POSITION_Y + TEXT_AREA_HEIGHT) {
    return -1;
  }
  
  //Check each word to see if mouse is over it
  for (int i = 0; i < words.size(); i++) {
    if (words.get(i).isMouseOver(scrollY, mouseX, mouseY)) {
      return i;
    }
  }
  
  return -1;
}

//Highlight a range of words from startIndex to endIndex (inclusive)
void highlightRange(int startIndex, int endIndex) {
  for (int i = startIndex; i <= endIndex && i < words.size(); i++) {
    words.get(i).isHighlighted = true;
    highlighted += words.get(i).wordText + " ";
    words.get(i).backgroundColor = HIGHLIGHT_COLOR;
  }
}

//Unhighlight all words (reusable function)
void unhighlightAll() {
  highlighted = "";
  for (Word w : words) {
    w.isHighlighted = false;
    w.backgroundColor = color(255);
  }
}
