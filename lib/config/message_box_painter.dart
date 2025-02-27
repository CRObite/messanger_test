import 'package:flutter/material.dart';

import 'app_colors.dart';

class MessageBoxPainter extends CustomPainter {
  final bool isCurrentUser;

  MessageBoxPainter({required this.isCurrentUser});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isCurrentUser ? AppColors.myMessageGreen : AppColors.otherMessageGrey;

    final Path path = Path();
    final double radius = 23;
    final double leftOffset = 10;


    if(!isCurrentUser){
      path.moveTo(leftOffset, radius);
      path.arcToPoint(Offset(leftOffset + radius, 0), radius: Radius.circular(radius));
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius));
      path.lineTo(size.width, size.height - radius);
      path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius));
      path.lineTo(0, size.height);
      path.quadraticBezierTo(leftOffset, size.height - radius + 20, leftOffset, radius);
    }else{
      path.moveTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

      path.lineTo(size.width - leftOffset - radius, 0);
      path.arcToPoint(Offset(size.width - leftOffset, radius), radius: Radius.circular(radius));

      path.lineTo(size.width - leftOffset, size.height - radius);
      path.quadraticBezierTo(size.width - leftOffset, size.height - radius + 20, size.width + leftOffset/2, size.height);

      path.lineTo(radius, size.height);
      path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius));
    }


    path.close();
    canvas.drawPath(path, paint);
  }




  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}