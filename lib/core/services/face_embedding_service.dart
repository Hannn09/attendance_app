import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceEmbeddingService {
  static final FaceEmbeddingService _instance =
      FaceEmbeddingService._internal();

  factory FaceEmbeddingService() => _instance;

  FaceEmbeddingService._internal();

  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    if (_isModelLoaded) return;
    try {
      // Try loading with options for better compatibility
      final options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset(
        'model_cnn.tflite',
        options: options,
      );
      _isModelLoaded = true;
    } catch (e) {
      throw Exception('Failed to load model: $e');
    }
  }

  Future<List<double>> generateEmbedding(File imageFile) async {
    await loadModel();

    // Load and preprocess image
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) throw Exception('Failed to decode image');

    // Resize to model input size (adjust based on your model)
    final resized = img.copyResize(
      image,
      width: 160, // Adjust to your model's input size
      height: 160,
    );

    // Prepare input tensor - 4D array [batch][height][width][channels]
    final input = List.generate(
      1,
      (b) => List.generate(
        160,
        (h) => List.generate(
          160,
          (w) => List.generate(
            3,
            (c) {
              final pixel = resized.getPixel(w, h);
              // Normalize RGB values to 0-1
              switch (c) {
                case 0:
                  return pixel.r.toDouble() / 255.0;
                case 1:
                  return pixel.g.toDouble() / 255.0;
                case 2:
                  return pixel.b.toDouble() / 255.0;
                default:
                  return 0.0;
              }
            },
          ),
        ),
      ),
    );

    // Prepare output tensor - 2D array [batch][embedding_size]
    final output = List.generate(
      1,
      (b) => List.generate(128, (i) => 0.0),
    );

    // Run inference
    _interpreter!.run(input, output);

    // Return embedding (skip batch dimension)
    return output[0];
  }

  void dispose() {
    _interpreter?.close();
  }
}
