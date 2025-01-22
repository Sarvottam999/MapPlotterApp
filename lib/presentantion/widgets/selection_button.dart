// Create new file: lib/presentation/widgets/selection_button.dart

import 'package:flutter/material.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:provider/provider.dart';
 
class SelectionButton extends StatelessWidget {
  const SelectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.isSelectionMode;
        
        return IconButton(
          icon: Icon(Icons.near_me, color:isSelected? Colors.white: Colors.black,),
           style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: isSelected ?Colors.black: Colors.white ,
            // foregroundColor: Colors.white,
          ),
          onPressed: () => provider.toggleSelectionMode(),
        );
      },
    );
  }
}