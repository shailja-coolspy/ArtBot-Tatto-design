import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final Uint8List? imageBytes;

  const CameraPage({Key? key, this.imageBytes}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );

        await _controller?.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error initializing camera: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Try On',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _error.isNotEmpty
          ? Center(child: Text(_error))
          : _isCameraInitialized
              ? Stack(
                  children: [
                    CameraPreview(_controller!),
                    Center(
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: EdgeInsets.all(20),
                        minScale: 0.001,
                        maxScale: 2.0,
                        child: Image.memory(
                          widget.imageBytes!,
                          scale: 1,
                          fit: BoxFit.contain,
                          color: Colors.white
                              .withOpacity(0.9), // Adjust the opacity
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                )),
    );
  }
}
