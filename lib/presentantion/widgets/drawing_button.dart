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

  const DrawingButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.shapeType,
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
            color: isSelected ? Colors.indigo[50] : Colors.white,
            // col: Colors.white,
          ),
          child: IconButton(
            icon: Icon(icon, size: 20, color: Colors.indigo),
            onPressed: () {
              provider.setCurrentShape(isSelected ? ShapeType.none : shapeType);
            },
          ),
        );
      },
    );
  }
}
