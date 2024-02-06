// import 'dart:io';

// import 'package:google_speech/google_speech.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/texttospeech/v1.dart';

// class GoogleTTS {
//   final _credentials = ServiceAccountCredentials.fromJson({});

//   Future<String?> synthesizeText(
//     String text,
//   ) async {
//     final client = await clientViaServiceAccount(
//         _credentials, [TexttospeechApi.cloudPlatformScope]);
//     final ttsApi = TexttospeechApi(client);

//     final synthesisInput = SynthesisInput(text: text);
//     final voiceSelectionParams = VoiceSelectionParams(
//         languageCode: "en-IN", name: "en-IN-Standard-B", ssmlGender: "MALE");
//     final audioConfig = AudioConfig(audioEncoding: 'MP3');

//     final request = SynthesizeSpeechRequest(
//       input: synthesisInput,
//       voice: voiceSelectionParams,
//       audioConfig: audioConfig,
//     );

//     final response = await ttsApi.text.synthesize(request);

//     final audioContent = response.audioContent;

//     return audioContent;
//   }

//   Future<String> getWhisper(String path) async {
//     final speechToText =
//         SpeechToText.viaServiceAccount(ServiceAccount.fromString(r'''{
//     "type": "service_account",
//     "project_id": "shaped-entropy-398411",
//     "private_key_id": "31b3b1024a3e65206554402e0107cb0f0352f432",
//     "private_key":
//         "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDSM6Zxln6vzA21\n+HFaLe1MwfEllhEacCvjeBUo2Aw25EY78UaP6OzzkG4de7K9v35g6rDCA9xSQ7RM\nYM7SXl9dtC+uyUXeC0bYeSNS6WkemYIhZgYFk+Ed0wa/TognNOCpmTacAnd+ZLqT\nHeZTrpQwouua7NVk0q5vIpZhuskQzIMS2kjo7K2OOvZfWJP6tqiea/HVOlzL/jKm\nYVieFt+fkk1Ziev09MNAmqu70Wpi0suycAk7Da5z0152eGljZH9AdkqfZoAJ1/y6\nl3qiNKDVfLB9SL+uGfxtSe+PxMNbfD8sY0H08ZCe8hF47VJ2vk0Fw8xz+bLPLSz8\nwlxhsXd3AgMBAAECggEABjnea7iL7xQUXI1Lz40oXWDUjjWdiGgbJ1qBXJuC8nCc\n00izENnS2ZIFGPLMLrTzKYFkvpJpCQy//zp81caoJ3k0p7DcKhaxFgIHNaemjpqj\nEUSELXpzArRN8QZX9RAADuCeuUyUvSspoD2UpWo4hx+ZlUCqP27Cw5Wa2QaJzxQE\nmIECU/1BQGDNswKtpZye22YkcFJ2uI/ShEXTCj8Fj4FmSihtaeKazhhKBPonWVr3\nWDqNABYnClBD6BPTUhM8KCUkUPtZh9A/qe8uzq9plOl2ZviJAfR6bTL5Qe1P0ngi\nMBE6zigSRuOnyzLKKREYzmdjP2DgL5SOcIPvB4FYBQKBgQDperGBn+oz5nJORxTa\nVfTErKqrt8BckJVty6iM4/wV2YD9xSue3Fqb83wAQSZ1pULaxHlqCi90zJ2pWzSy\nqMj0+0yYFpnSjZZ+tmkPeJsg3LG7BzXdUr2Ea/V2D+GXBRlfOw6/BPc5+qfPC5sY\nLgToRM5PM9GONNS5WiDwufWN6wKBgQDmeio1EzbBcjvG9QZhZmMYXSYd/Ak3YFRt\nXJ9CA3cmuSBwJW3aft9MmMjB3RIsszvt9WJnMKDL7xZ3ih9fWZS3vY0pXQmgV4M3\nFcN0WHQqL3kWEPPUVcIY9nDsHawJZXLEfDtnvcUiRNF6TBk6/ACabbepasgVEaR6\nQ4SqN9Q9pQKBgEvqHd803NTFQDNdf1VCj5SHQ/MTixNN25hYmNQ+qM996igZPQap\nRTjh4Va/2D52Xpd9PLES4L1MbpMLWcYhhT3Km+vzpU5FxUIsE1r5bw8vUwap4IS3\nC3IMHEKoBUSyXr6NGE1Z0vziGEAE2QfyppvTC3XLNn7ThLtDp+Q9wq7DAoGBAKa3\nC7zkryDzLsZWC019MIU5LA9Ydpo19hw9eX3Y3+GE3DADAxmf2IqhoeaJsVHgPKN+\ncrXN+SJLSeciZFsmg2r9lBStlf8EDohUF9Qa/7xcJqyNirK3bfV8nmZNeFo7pe73\nJkl+fhCx0w0x6rY9/3m1j7re4OhMoLtIB7jRNZd5AoGAM1830AcHiYTgST1FsdOX\n10Ot4C4Q+h4Pd7ScqkjJo0hj4HbeUtgLsZ7NWHpPDG+CVYXa3S6C6eME4aKOhDHQ\nJcjewa7PLWFA0r+JlPQqh1bEIQio9ludqL9q/BhRCNizMUwfgFB5x0EFlqHcvwpa\nqkmimdtp+M8I6MF7RuLW5Xk=\n-----END PRIVATE KEY-----\n",
//     "client_email":
//         "ai-education@shaped-entropy-398411.iam.gserviceaccount.com",
//     "client_id": "102993910185936320684",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://oauth2.googleapis.com/token",
//     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//     "client_x509_cert_url":
//         "https://www.googleapis.com/robot/v1/metadata/x509/ai-education%40shaped-entropy-398411.iam.gserviceaccount.com",
//     "universe_domain": "googleapis.com"
//   }'''));

//     final config = RecognitionConfig(
//         encoding: AudioEncoding.LINEAR16,
//         model: RecognitionModel.basic,
//         enableAutomaticPunctuation: true,
//         sampleRateHertz: 16000,
//         languageCode: 'en-US');

//     final audio = File(path).readAsBytesSync().toList();
//     final response = await speechToText.recognize(config, audio);
//     String result = "";
//     await speechToText.recognize(config, audio).then((value) {
//       result =
//           value.results.map((e) => e.alternatives.first.transcript).join('\n');
//     }).whenComplete(() {
//       print(result);
//     });
//     print(response);
//     return result;
//   }
// }
