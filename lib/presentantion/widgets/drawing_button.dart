import 'package:flutter/material.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
// import 'package:helloworld/core/enums/shape_type.dart';
// import 'package:helloworld/presentation/providers/drawing_provider.dart';
import 'package:provider/provider.dart';

class DrawingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ShapeType shapeType;
   final  Widget? image;

    DrawingButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.shapeType,
      this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.currentShape == shapeType;

        return Container(
          // width: 20,
          // height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            // border: Border.all(width: 2),
            // shape: BoxShape.circle,
            color: isSelected ? Color.fromARGB(255, 178, 176, 226) : Colors.white,
            // col: Colors.white,
          ),
          child: IconButton(
            icon: image ??   Icon(icon, size: 20, color: Colors.black),
            onPressed: () {
              provider.setCurrentShape(isSelected ? ShapeType.none : shapeType);
            },
          ),
        );
      },
    );
  }
}
