import 'dart:io';
import 'dart:math';
import 'package:attendance_cnn_app/core/services/camera_service.dart';
import 'package:attendance_cnn_app/core/services/face_embedding_service.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_request.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/providers/attendance_providers.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/repositories/attendance_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum AttendanceStatus { initial, loading, success, error }

class AttendanceState {
  final AttendanceStatus status;
  final String? message;
  final String? checkInTime;
  final String? checkOutTime;
  final bool hasCheckedIn;

  const AttendanceState({
    this.status = AttendanceStatus.initial,
    this.message,
    this.checkInTime,
    this.checkOutTime,
    this.hasCheckedIn = false,
  });

  AttendanceState copyWith({
    AttendanceStatus? status,
    String? message,
    String? checkInTime,
    String? checkOutTime,
    bool? hasCheckedIn,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      message: message ?? this.message,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      hasCheckedIn: hasCheckedIn ?? this.hasCheckedIn,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendanceRepository repository;
  final CameraService cameraService;
  final FaceEmbeddingService faceService;
  final int userId;
  final List<double> userFaceEmbedding;

  AttendanceNotifier({
    required this.repository,
    required this.cameraService,
    required this.faceService,
    required this.userId,
    required this.userFaceEmbedding,
  }) : super(const AttendanceState());

  Future<bool> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.location.request();

    return cameraStatus.isGranted && locationStatus.isGranted;
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  double _calculateCosineSimilarity(
    List<double> embedding1,
    List<double> embedding2,
  ) {
    if (embedding1.length != embedding2.length) {
      return 0.0;
    }

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      norm1 += embedding1[i] * embedding1[i];
      norm2 += embedding2[i] * embedding2[i];
    }

    norm1 = sqrt(norm1);
    norm2 = sqrt(norm2);

    if (norm1 == 0 || norm2 == 0) {
      return 0.0;
    }

    return dotProduct / (norm1 * norm2);
  }

  Future<bool> _verifyFace(File imageFile) async {
    try {
      final capturedEmbedding = await faceService.generateEmbedding(imageFile);
      final similarity = _calculateCosineSimilarity(
        userFaceEmbedding,
        capturedEmbedding,
      );

      // Threshold for face recognition (adjust based on your model)
      const threshold = 0.8;
      return similarity >= threshold;
    } catch (e) {
      print('Error verifying face: $e');
      return false;
    }
  }

  Future<void> checkIn() async {
    state = state.copyWith(status: AttendanceStatus.loading);

    try {
      // Check permissions
      final hasPermissions = await _checkPermissions();
      if (!hasPermissions) {
        state = state.copyWith(
          status: AttendanceStatus.error,
          message: 'Camera and location permissions are required',
        );
        return;
      }

      // Get current position
      final position = await _getCurrentPosition();

      // Initialize camera
      final cameraInitialized = await cameraService.initializeCamera();
      if (!cameraInitialized) {
        state = state.copyWith(
          status: AttendanceStatus.error,
          message: 'Failed to initialize camera',
        );
        return;
      }

      // Camera will be handled by UI, waiting for image capture
    } catch (e) {
      state = state.copyWith(
        status: AttendanceStatus.error,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<void> processCheckIn(File imageFile) async {
    state = state.copyWith(status: AttendanceStatus.loading);

    try {
      // Verify face
      final isFaceVerified = await _verifyFace(imageFile);
      if (!isFaceVerified) {
        state = state.copyWith(
          status: AttendanceStatus.error,
          message: 'Face verification failed. Please try again.',
        );
        return;
      }
      debugPrint('face verified: $isFaceVerified');
      // final isFaceVerified = true; // Skip verification for now

      // Get current position
      final position = await _getCurrentPosition();

      // Create request with File directly (no base64 conversion)
      final request = AttendanceRequest(
        userId: userId,
        note: '',
        latitude: position?.latitude.toString() ?? '0',
        longitude: position?.longitude.toString() ?? '0',
        photoFile: imageFile,
      );

      // Call repository
      final result = await repository.checkIn(request);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: AttendanceStatus.error,
            message: failure.message,
          );
        },
        (_) {
          final now = DateTime.now();
          state = state.copyWith(
            status: AttendanceStatus.success,
            message: 'Check-in successful!',
            checkInTime:
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            hasCheckedIn: true,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AttendanceStatus.error,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<void> checkOut() async {
    state = state.copyWith(status: AttendanceStatus.loading);

    try {
      // Check permissions
      final hasPermissions = await _checkPermissions();
      if (!hasPermissions) {
        state = state.copyWith(
          status: AttendanceStatus.error,
          message: 'Camera and location permissions are required',
        );
        return;
      }

      // Initialize camera
      final cameraInitialized = await cameraService.initializeCamera();
      if (!cameraInitialized) {
        state = state.copyWith(
          status: AttendanceStatus.error,
          message: 'Failed to initialize camera',
        );
        return;
      }

      // Camera will be handled by UI, waiting for image capture
    } catch (e) {
      state = state.copyWith(
        status: AttendanceStatus.error,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<void> processCheckOut(File imageFile) async {
    state = state.copyWith(status: AttendanceStatus.loading);

    try {
      // Verify face
      final isFaceVerified = await _verifyFace(imageFile);
      if (!isFaceVerified) {
        state = state.copyWith(
          status: AttendanceStatus.error,
          message: 'Face verification failed. Please try again.',
        );
        return;
      }
      debugPrint('face verified: $isFaceVerified');
      // final isFaceVerified = true; // Skip verification for now

      // Get current position
      final position = await _getCurrentPosition();

      // Create request with File directly (no base64 conversion)
      final request = AttendanceRequest(
        userId: userId,
        note: '',
        latitude: position?.latitude.toString() ?? '0',
        longitude: position?.longitude.toString() ?? '0',
        photoFile: imageFile,
      );

      // Call repository
      final result = await repository.checkOut(request);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: AttendanceStatus.error,
            message: failure.message,
          );
        },
        (_) {
          final now = DateTime.now();
          state = state.copyWith(
            status: AttendanceStatus.success,
            message: 'Check-out successful!',
            checkOutTime:
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AttendanceStatus.error,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  void resetState() {
    state = AttendanceState(
      checkInTime: state.checkInTime,
      checkOutTime: state.checkOutTime,
      hasCheckedIn: state.hasCheckedIn,
    );
  }
}

// Providers
final cameraServiceProvider = Provider((ref) => CameraService());

final faceEmbeddingServiceProvider = Provider((ref) => FaceEmbeddingService());

// This will be provided with user data when needed
final attendanceNotifierProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
      throw UnimplementedError(
        'AttendanceNotifier must be overridden with user data',
      );
    });

// Family provider that can be created with user-specific data
final createAttendanceNotifierProvider =
    StateNotifierProvider.family<
      AttendanceNotifier,
      AttendanceState,
      AttendanceUserParams
    >((ref, params) {
      return AttendanceNotifier(
        repository: ref.watch(attendanceRepositoryProvider),
        cameraService: ref.watch(cameraServiceProvider),
        faceService: ref.watch(faceEmbeddingServiceProvider),
        userId: params.userId,
        userFaceEmbedding: params.faceEmbedding,
      );
    });

class AttendanceUserParams {
  final int userId;
  final List<double> faceEmbedding;

  AttendanceUserParams({required this.userId, required this.faceEmbedding});

  @override
  bool operator ==(Object other) =>
      other is AttendanceUserParams && other.userId == userId;

  @override
  int get hashCode => userId.hashCode;
}
