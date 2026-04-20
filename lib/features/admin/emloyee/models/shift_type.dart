import 'package:flutter/material.dart';

enum ShiftType { pagi, siang, malam, libur }

extension ShiftTypeExtension on ShiftType {
  String get displayName {
    switch (this) {
      case ShiftType.pagi:
        return 'Pagi';
      case ShiftType.siang:
        return 'Siang';
      case ShiftType.malam:
        return 'Malam';
      case ShiftType.libur:
        return 'Libur';
    }
  }

  String get timeRange {
    switch (this) {
      case ShiftType.pagi:
        return '08:00 - 17:00';
      case ShiftType.siang:
        return '14:00 - 23:00';
      case ShiftType.malam:
        return '22:00 - 07:00';
      case ShiftType.libur:
        return '-';
    }
  }

  String get startTime {
    switch (this) {
      case ShiftType.pagi:
        return '08:00';
      case ShiftType.siang:
        return '14:00';
      case ShiftType.malam:
        return '22:00';
      case ShiftType.libur:
        return '-';
    }
  }

  String get endTime {
    switch (this) {
      case ShiftType.pagi:
        return '17:00';
      case ShiftType.siang:
        return '23:00';
      case ShiftType.malam:
        return '07:00';
      case ShiftType.libur:
        return '-';
    }
  }

  IconData get icon {
    switch (this) {
      case ShiftType.pagi:
        return Icons.wb_sunny_outlined;
      case ShiftType.siang:
        return Icons.wb_twilight_outlined;
      case ShiftType.malam:
        return Icons.bedtime_outlined;
      case ShiftType.libur:
        return Icons.beach_access_outlined;
    }
  }

  String get emoji {
    switch (this) {
      case ShiftType.pagi:
        return '☀️';
      case ShiftType.siang:
        return '🌤️';
      case ShiftType.malam:
        return '🌙';
      case ShiftType.libur:
        return '🏖️';
    }
  }

  static ShiftType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pagi':
      case 'morning':
        return ShiftType.pagi;
      case 'siang':
      case 'afternoon':
        return ShiftType.siang;
      case 'malam':
      case 'night':
        return ShiftType.malam;
      case 'libur':
      case 'off':
        return ShiftType.libur;
      default:
        return ShiftType.pagi;
    }
  }
}
