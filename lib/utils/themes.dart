import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = Color(0xFF135BEC);
Color whiteColor = Color(0xFFFFFFFF);
Color blackColor = Color(0xFF1E1E1E);
Color greyColor = Color(0x801E1E1E);
Color lightGreyColor = Color(0x331E1E1E);
Color redColor = Color(0xFFE74C3C);
Color borderColor = Color(0xFFE2E8F0);
Color greenColor = Color(0xFF12C002);
Color orangeColor = Color(0xFFF89823);
Color dividerColor = Color(0xFFF1F1F1);

TextStyle boldTextStyle = GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.bold,
);
TextStyle semiBoldTextStyle = GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.w600,
);
TextStyle regularTextStyle = GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.w400,
);
TextStyle mediumTextStyle = GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.w500,
);
TextStyle errorTextStyle = GoogleFonts.plusJakartaSans(
  color: redColor,
  fontWeight: FontWeight.w500,
);
TextStyle hintTextStyle = GoogleFonts.plusJakartaSans(
  color: lightGreyColor,
  fontWeight: FontWeight.w500,
);

final textFieldDecoration = InputDecoration(
  filled: true,
  errorStyle: errorTextStyle,
  fillColor: whiteColor,
  prefixIconConstraints: BoxConstraints.tight(const Size(15, 60)),
  prefixIcon: Container(width: 0),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: primaryColor),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: redColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: borderColor),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: borderColor),
  ),
  contentPadding: EdgeInsets.zero,
);

final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  elevation: 0,
  shadowColor: Colors.transparent,
  overlayColor: Colors.transparent,
  textStyle: boldTextStyle.copyWith(color: whiteColor),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  padding: const EdgeInsets.symmetric(vertical: 15.0),
);
