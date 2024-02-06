// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiServices {
  static var client = http.Client();
  static List<Map<String, String>> conversationHistory = [];

  static Future<String> chatCompeletionResponse(String prompt,
      {addApiKey}) async {
    var url = Uri.https("api.openai.com", "/v1/chat/completions");
    log("prompt : $prompt");

    conversationHistory.add({"role": "user", "content": prompt});

    String apiKey = "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";
    if (addApiKey != null) {
      apiKey = addApiKey;
    } else {}

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
        "messages": conversationHistory
      }),
    );

    // Do something with the response
    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    log("RES $newresponse");

    if (response.statusCode == 200) {
      conversationHistory.add({
        "role": "assistant",
        "content": newresponse['choices'][0]['message']['content']
      });

      return response.statusCode == 200
          ? newresponse['choices'][0]['message']['content']
          : "";
    } else {
      return "";
    }
  }
}
// from flask import Flask, request, jsonify

// app = Flask(__name)

// @app.route('/v1/chat/completions', methods=['POST'])
// def post_data():
//     # Retrieve headers
//     request_headers = dict(request.headers)

//     //check if it contains the token
//     if request_headers['Authorization'] != 'Bearer $openAiToken':
//         return jsonify({'error': 'Invalid token'}), 401
    
//     # Retrieve JSON data from the request body
//     request_data = request.get_json()
    
//     return jsonify({'headers': request_headers, 'body': request_data}), 200

// if _name_ == '_main_':
//     app.run(debug=True)

//send data to model
//custom data