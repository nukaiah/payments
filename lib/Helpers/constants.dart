import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const Color txtClr = Colors.black;
const Color bgClr = Colors.white;
const Color fieldClr = Colors.grey;
const Color btnColor = Color(0xFF5551F1);

class TxtStls{
  static TextStyle titlestl  = GoogleFonts.montserrat(color: txtClr, fontSize: 17, fontWeight: FontWeight.w300);
  static TextStyle titlestl1 = GoogleFonts.montserrat(color: bgClr,  fontSize: 17, fontWeight: FontWeight.w300);
  static TextStyle headlistl = GoogleFonts.montserrat(color: txtClr, fontSize: 15, fontWeight: FontWeight.w300);
  static TextStyle headlistl1= GoogleFonts.montserrat(color: bgClr,  fontSize: 15, fontWeight: FontWeight.w300);
  static TextStyle txtStl    = GoogleFonts.montserrat(color: txtClr, fontSize: 12, fontWeight: FontWeight.w300);
  static TextStyle txtStl2   = GoogleFonts.montserrat(color: bgClr,  fontSize: 12, fontWeight: FontWeight.w300);
  static TextStyle rtxtStl   = GoogleFonts.montserrat(color:btnColor,fontSize: 12, fontWeight: FontWeight.w300);
}

const  deco = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  color:  bgClr,
);