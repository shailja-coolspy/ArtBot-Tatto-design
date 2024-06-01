import 'dart:io';
import 'dart:typed_data';

import 'package:ai_app/camera_page.dart';
import 'package:ai_app/consts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ResultPage extends StatefulWidget {
  final String? image;
  const ResultPage({super.key, this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future<Uint8List?> removeBackground(String imageUrl) async {
    final apiKey = bg_key;
    final url = Uri.parse('https://api.remove.bg/v1.0/removebg');

    try {
      // Download the image from the URL
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.png');
      await tempFile.writeAsBytes(response.bodyBytes);

      // Create the multipart request
      final request = http.MultipartRequest('POST', url)
        ..headers['X-Api-Key'] = apiKey
        ..files.add(
            await http.MultipartFile.fromPath('image_file', tempFile.path));

      // Send the request
      final apiResponse = await request.send();

      if (apiResponse.statusCode == 200) {
        final responseData = await apiResponse.stream.toBytes();
        return responseData;
      } else {
        print('Error: ${apiResponse.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 50), // Space for the status bar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  //const Spacer(),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: const Text(
                      'Result',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Tap to try on your self',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    InkWell(
                        onTap: () {
                          removeBackground(widget.image ?? "").then(
                            (value) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CameraPage(
                                  imageBytes: value,
                                ),
                              ));
                            },
                          );
                        },
                        child: buildImageTile(widget.image ?? "")),
                    // buildLockedTile(),
                    // buildLockedTile(),
                    // buildLockedTile(),
                  ],
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildImageTile(String imagePath) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(
      imagePath,
      fit: BoxFit.cover,
    ),
  );
}

Widget buildLockedTile() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Container(
      color: Colors.black54,
      child: Center(
        child: Text(
          'Update to Pro',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
