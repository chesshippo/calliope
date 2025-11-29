import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

String API_KEY;

void setup()
{
    API_KEY = loadStrings("api_key.txt")[0];
    PromptGemini("how's it going?");
}

void draw()
{
  
}
