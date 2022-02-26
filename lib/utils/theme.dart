import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 24.0;
double defaultRadius = 17.0;

Color kPrimaryColor = const Color(0xff16307D);
Color kBlackColor = const Color(0xff1F1449);
Color kWhiteColor = const Color(0xffFFFFFF);
Color kGreyColor = const Color(0xff9698A9);
Color kGreenColor = const Color(0xff0EC3AE);
Color kRedColor = const Color.fromARGB(255, 241, 10, 10);
Color kBackgroundColor = const Color(0xffFAFAFA);
Color kInactiveColor = const Color(0xffDBD7EC);
Color kTransparentColor = Colors.transparent;
Color kAvailableColor = const Color(0xffE0D9FF);
Color kUnavailableColor = const Color(0xffEBECF1);

TextStyle primaryTextStyle = GoogleFonts.lato(
  color: kPrimaryColor,
);
TextStyle blackTextStyle = GoogleFonts.lato(
  color: kBlackColor,
);
TextStyle whiteTextStyle = GoogleFonts.lato(
  color: kWhiteColor,
);
TextStyle greyTextStyle = GoogleFonts.lato(
  color: kGreyColor,
);
TextStyle greenTextStyle = GoogleFonts.lato(
  color: kGreenColor,
);
TextStyle redTextStyle = GoogleFonts.lato(
  color: kRedColor,
);
TextStyle purpleTextStyle = GoogleFonts.lato(
  color: kPrimaryColor,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
