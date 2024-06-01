// import 'dart:convert';
// import 'dart:io';

// import 'package:ai_app/consts.dart';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:http/http.dart' as http;
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   String img = "";
//   late OpenAI openAI;
//   List<types.Message> _messages = [];
//   final _user = const types.User(
//     id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
//   );

//   final _bot = const types.User(id: 'bot-id', firstName: 'Bot');

//   @override
//   void initState() {
//     super.initState();

//     openAI = OpenAI.instance.build(
//         token: OPENAI_API_KEY,
//         baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
//         enableLog: true);

//     _loadMessages();
//   }

//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//       _generateImage(message as types.TextMessage);
//     });
//   }

//   void _generateImage(types.TextMessage message) async {
//     String prompt = message.text + " tattoo design";

//     final request = GenerateImage(prompt, 1,
//         model: DallE3(), size: ImageSize.size1024, responseFormat: Format.url);
//     final response = await openAI.generateImage(request);

//     if (response != null &&
//         response.data != null &&
//         response.data!.isNotEmpty) {
//       setState(() {
//         img = "${response.data?.last?.url}";
//         final imageMessage = types.ImageMessage(
//           author: _bot,
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: const Uuid().v4(),
//           name: 'Tattoo Design',
//           size: 0,
//           uri: img,
//         );
//         _messages.insert(0, imageMessage);
//       });
//     }
//   }

//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;

//       if (message.uri.startsWith('http')) {
//         try {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: true,
//           );

//           setState(() {
//             _messages[index] = updatedMessage;
//           });

//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';

//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: null,
//           );

//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//         }
//       }

//       await OpenFilex.open(localPath);
//     }
//   }

//   void _handlePreviewDataFetched(
//     types.TextMessage message,
//     types.PreviewData previewData,
//   ) {
//     final index = _messages.indexWhere((element) => element.id == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );

//     setState(() {
//       _messages[index] = updatedMessage;
//     });
//   }

//   void _handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );

//     _addMessage(textMessage);
//   }

//   void _loadMessages() async {
//     final response = await rootBundle.loadString('assets/messages.json');
//     final messages = (jsonDecode(response) as List)
//         .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//         .toList();

//     setState(() {
//       _messages = messages;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ArtBot"),
//       ),
//       body: Chat(
//         messages: _messages,
//         //onAttachmentPressed: _handleAttachmentPressed,
//         onMessageTap: _handleMessageTap,
//         onPreviewDataFetched: _handlePreviewDataFetched,
//         onSendPressed: _handleSendPressed,
//         showUserAvatars: true,
//         showUserNames: true,
//         user: _user,
//       ),
//     );
//   }
// }

import 'package:ai_app/consts.dart';
import 'package:ai_app/result_page.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController promptController = TextEditingController();
  String img = "";
  late OpenAI openAI;
  bool loading = false;
  bool success = false;
  @override
  void initState() {
    super.initState();

    openAI = OpenAI.instance.build(
        token: OPENAI_API_KEY,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
        enableLog: true);
  }

  Future<void> _generateImage(String message) async {
    String prompt = message + " tattoo design";

    final request = GenerateImage(prompt, 1,
        model: DallE3(), size: ImageSize.size1024, responseFormat: Format.url);

    try {
      final response = await openAI.generateImage(request);
      if (response != null &&
          response.data != null &&
          response.data!.isNotEmpty) {
        setState(() {
          img = "${response.data?.last?.url}";
          loading = false;
          success = true;
        });
      }
    } catch (e) {
      print("error encountere");
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(59, 165, 194, 20),
              Color.fromARGB(204, 32, 169, 228),
              Color.fromARGB(133, 15, 200, 43),
              Color.fromARGB(165, 236, 77, 202),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            //SizedBox(height: 50), // Space for the status bar
            AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
              title: const Text('AI ArtBot'),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Prompt',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: promptController,
                            cursorColor: Colors.white,
                            maxLines: 5,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText:
                                  'Type here a detailed description of what you want to see in your tatto design',
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         padding: EdgeInsets.all(16),
                    //         decoration: BoxDecoration(
                    //           color: Colors.grey[900],
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               'Style',
                    //               style: TextStyle(color: Colors.white),
                    //             ),
                    //             SizedBox(height: 4),
                    //             Text(
                    //               'Optional',
                    //               style: TextStyle(color: Colors.grey),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(width: 16),
                    //     // Expanded(
                    //     //   child: Container(
                    //     //     padding: EdgeInsets.all(16),
                    //     //     decoration: BoxDecoration(
                    //     //       color: Colors.grey[900],
                    //     //       borderRadius: BorderRadius.circular(8),
                    //     //     ),
                    //     //     child: Column(
                    //     //       children: [
                    //     //         Text(
                    //     //           'Stable',
                    //     //           style: TextStyle(color: Colors.white),
                    //     //         ),
                    //     //         SizedBox(height: 4),
                    //     //         Text(
                    //     //           'Model Selection',
                    //     //           style: TextStyle(color: Colors.grey),
                    //     //         ),
                    //     //       ],
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    // SizedBox(height: 16),
                    // Container(
                    //   padding: EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey[900],
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'Advance',
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       SizedBox(height: 4),
                    //       Text(
                    //         'Optional',
                    //         style: TextStyle(color: Colors.grey),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blue,
                            Color.fromARGB(128, 255, 255, 255),
                            Color.fromARGB(204, 86, 171, 240)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            await _generateImage(promptController.text);

                            if (success) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                      image: img,
                                    ),
                                  ));
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'CREATE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
