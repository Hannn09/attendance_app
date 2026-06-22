import 'package:attendance_cnn_app/core/services/camera_service.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';

class CameraCaptureScreen extends StatefulWidget {
  final String title;
  final String instruction;

  const CameraCaptureScreen({
    super.key,
    required this.title,
    required this.instruction,
  });

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  final CameraService _cameraService = CameraService();
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final success = await _cameraService.initializeCamera();
    if (mounted) {
      setState(() {
        _isInitialized = success;
        if (!success) {
          _errorMessage = 'Failed to initialize camera';
        }
      });
    }
  }

  Future<void> _capturePhoto() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final imageFile = await _cameraService.capturePicture();
      if (imageFile != null && mounted) {
        // Return the captured image file to the previous screen
        context.pop(imageFile);
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Failed to capture photo';
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 24,
                      color: whiteColor,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: boldTextStyle.copyWith(
                        fontSize: 18,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Camera preview
            Expanded(
              child: Stack(
                children: [
                  if (_isInitialized && _cameraService.controller != null)
                    Center(child: CameraPreview(_cameraService.controller!))
                  else if (_errorMessage != null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 64,
                            color: greyColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: regularTextStyle.copyWith(color: whiteColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),

                  // Face overlay guide
                  if (_isInitialized && _cameraService.controller != null)
                    Center(
                      child: Container(
                        width: 250,
                        height: 320,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(125),
                          border: Border.all(
                            color: whiteColor.withOpacity(0.7),
                            width: 3,
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(122),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Instruction and capture button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Text(
                    widget.instruction,
                    style: mediumTextStyle.copyWith(
                      fontSize: 16,
                      color: whiteColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Capture button
                      GestureDetector(
                        onTap: _isInitialized && !_isProcessing
                            ? _capturePhoto
                            : null,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: whiteColor, width: 4),
                          ),
                          child: _isProcessing
                              ? Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: whiteColor,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
