import java.net.*;
import java.io.*;

import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

public void PromptGemini(String prompt)
{
    Client client = Client.builder().apiKey(API_KEY).build();
    
    GenerateContentResponse response = client.models.generateContent(
        "gemini-2.5-flash",
        prompt,
        null
    );

    println(response.text());

    client.close();
}