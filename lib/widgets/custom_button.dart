import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key,required this.width, required this.onPressed, required this.btnTitle, required this.bgColor, required this.fgColor, required this.height});
  final VoidCallback onPressed;
  final String btnTitle;
  final Color bgColor;
  final Color fgColor;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(onPressed: onPressed, 
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        foregroundColor: fgColor,

       
        backgroundColor: bgColor
      ),
      child: Text(btnTitle,
      
      style: const TextStyle(
        fontFamily: "poppins",
        fontSize: 17,
        fontWeight: FontWeight.bold
        
      ),
      ),),
    );
  }
}