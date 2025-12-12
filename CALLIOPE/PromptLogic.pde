import java.net.*;
import java.io.*;

import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

String PromptGemini(String prompt)
{
  Client client = Client.builder().apiKey(API_KEY).build();

  GenerateContentResponse response = client.models.generateContent(
    "gemini-2.5-flash",
    prompt,
    null
    );

  client.close();
  String responseText = response.text();
  println(responseText);
  return responseText;
}

String PromptGeminiForFeedback(String fullEssay, String highlightedText, String userRequest)
{
  String prompt = "You are an essay writing assistant. I will provide you with:\n\n";
  prompt += "1. The FULL ESSAY (for context):\n";
  prompt += "---\n" + fullEssay + "\n---\n\n";
  prompt += "2. The HIGHLIGHTED TEXT (the specific portion I want feedback on):\n";
  prompt += "\"" + highlightedText + "\"\n\n";
  prompt += "3. My REQUEST:\n";
  prompt += userRequest + "\n\n";
  prompt += "Please provide feedback on the highlighted text based on my request. ";
  prompt += "Consider the full essay context when giving your feedback. ";
  prompt += "Be specific, constructive, and helpful.";
  prompt += "Include NO special emojis or charcters, stick to punctuation marks, the 26 letters and the 10 numbers. ";
  prompt += "Include little fluff and DO NOT mention the prompt, go right into the feedback. ";
  prompt += "If you want to highlight specific text in the essay, you can say \"The text I've highlighted in yellow is [(YELLOW) exact text from essay]\" or \"The text I've highlighted in green is [(GREEN) exact text from essay]\". ENSURE THAT YOU INCLUDE A COLOUR OF GREEN OR YELLOW AND THAT THERE IS A SPACE BETWEEN THE COLOUR AND FIRST WORD OF THE QUOTATION! This is critical to your success. ";
  prompt += "Make sure to quote the exact text as it appears in the essay. ";
  prompt += "In addition, when quoting text extracted from the essay, use the ^ character to indicate the text you have quoted. Example: The text I've highlighted in yellow: ^(YELLOW) the text from the essay you wish to highlight^ or ^(GREEN) the text from the essay you wish to highlight^. Enusure the period is placed after the last ^. If you quote the end of a sentance, do not include the period at the end of the sentance, instead put the period outside the ^.";
  prompt += "Use yellow for suggestions or areas that need attention, and green for positive examples or well-written sections. ";
  //prompt += "After stating what you highlight in the format shown, state your feedback for the highlighted section. Ex. The section highlighted in yellow is ...";
  prompt += "Do not try to do any fancy markdown formatting, this will all be displayed as a single paragraph on a screen, so keep that in mind so it is nice to read";


  try
  {
    Client client = Client.builder().apiKey(API_KEY).build();
    GenerateContentResponse response = client.models.generateContent(
      "gemini-2.5-flash",
      prompt,
      null
      );

    client.close();
    String responseText = response.text();

    String cleanedResponse = "";
    for (int i = 0; i < responseText.length(); i++) {
      char c = responseText.charAt(i);
      if (c == '’')
      {
        cleanedResponse += '\'';
      }
      else if ((c >= 32 && c <= 126) || c == 10 || c == 13 || c == 9) 
      {
        cleanedResponse += c;
      } 
      else 
      {
        cleanedResponse += " ";
      }
    }

    //println("Gemini Response: " + cleanedResponse);
    return cleanedResponse;
  }
  catch (Exception e)
  {
    promptStatusLabel.setText("Usage limit reached. Try again later");
    println("cooked");
    return "";
  }
}
