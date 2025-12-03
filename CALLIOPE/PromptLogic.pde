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

//Prompt Gemini for feedback on highlighted text, with full essay context
String PromptGeminiForFeedback(String fullEssay, String highlightedText, String userRequest)
{
    //Construct a comprehensive prompt that includes:
    //1. The full essay for context
    //2. The highlighted text to focus on
    //3. The user's specific request/question
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
    prompt += "Include NO special emojis or charcters, stick to punctuation marks, the 26 letters and the 10 numbers.";
    prompt += "Include little fluff and DO NOT mention the prompt, go right into the feedback.";
    
    Client client = Client.builder().apiKey(API_KEY).build();
    
    GenerateContentResponse response = client.models.generateContent(
        "gemini-2.5-flash",
        prompt,
        null
    );

    client.close();
    String responseText = response.text();
    
    //Clean the response text - remove any problematic characters
    //Keep only printable ASCII characters (32-126) plus newlines and tabs
    String cleanedResponse = "";
    for (int i = 0; i < responseText.length(); i++) {
      char c = responseText.charAt(i);
      //Allow printable ASCII (32-126), newline (10), carriage return (13), tab (9)
      if ((c >= 32 && c <= 126) || c == 10 || c == 13 || c == 9) {
        cleanedResponse += c;
      } else {
        //Replace other characters with space
        cleanedResponse += " ";
      }
    }
    
    println("Gemini Response: " + cleanedResponse);
    return cleanedResponse;
}
