import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/map_screen.dart';
import 'package:myapp/presentantion/widgets/build_fishbone_type_selector.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:myapp/presentantion/widgets/floating_toolbar.dart';
import 'package:myapp/presentantion/widgets/selection_button.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DrawingApp());
}

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrawingProvider()),
      ],
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Map Drawing App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: DrawingScreen(),
        ),
      ),
    );
  }
}

class DrawingScreen extends StatelessWidget {
  DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          MapScreen(),
          sideBaar(),
          bottomBar(),
          undoButtons(),
          FishboneTypeSelector(),

          // Positioned(
          //         top: 0,
          //         left: 80,
          //         bottom: 0,
          //         child: Center(child: const FloatingToolbar()),
          //       ),
        ],
      ),
    );
  }

  Positioned bottomBar() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<DrawingProvider>(
              builder: (context, provider, _) {
                final details = provider.getCurrentShapeDetails();
                print("details=============>${details}");
                if (details == null) return const SizedBox();

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    // border: Border.all(width: 2),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: details.entries
                        .map(
                          (e) => Text(
                            '${e.key}: ${e.value}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Positioned sideBaar() {
    return Positioned(
      top: 0,
      left: 10,
      bottom: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            child: Column(
              spacing: 2,
              mainAxisSize: MainAxisSize.min,
              children: [
                DrawingButton(
                  icon: Icons.square_outlined,
                  label: 'Square',
                  shapeType: ShapeType.square,
                ),
                DrawingButton(
                  icon: Icons.line_axis,
                  label: 'Line',
                  shapeType: ShapeType.line,
                ),
                DrawingButton(
                  icon: Icons.circle_outlined,
                  label: 'Circle',
                  shapeType: ShapeType.circle,
                ),

                DrawingButton(
                  icon: Icons.timeline_sharp,
                  // image: Image.asset(
                  //   "assets/images/1.png",
                  //   height: 20,
                  //   width: 20,
                  // ),
                  label: 'Circle',
                  shapeType: ShapeType.fishbone,
                ),

                const SelectionButton(), // Add this line

                //  DrawingButton(
                //   icon: Icons.living,
                //   image: Image.asset("assets/images/2.png", height: 30, width: 30,),
                //   label: 'Circle',
                //   shapeType: ShapeType.fishbone,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned undoButtons() {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<DrawingProvider>(
                builder: (context, provider, _) => IconButton(
                  icon: const Icon(
                    Icons.redo,
                    size: 18,
                  ),
                  onPressed: provider.canRedo ? provider.redo : null,
                  tooltip: 'Redo',
                ),
              ),
              Consumer<DrawingProvider>(
                builder: (context, provider, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.undo,
                        size: 18,
                      ),
                      onPressed: provider.canUndo ? provider.undo : null,
                      tooltip: 'Undo',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildFishboneTypeSelector(BuildContext context) {


  //   final screenSize = MediaQuery.of(context).size;

  //   return Positioned(
  //     bottom: 0,
  //     left: 60,
  //     // right: 0,
  //     top: 0,

  //     child: Consumer<DrawingProvider>(
  //       builder: (context, provider, _) {
  //         if (provider.currentShape != ShapeType.fishbone) return SizedBox();

  //         return Center(
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 10,  vertical: 8 ),
  //             decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
              

  //             ),
  //             // width: screenSize.width * 0.4,

  //             // elevation: 4,
  //             margin: const EdgeInsets.symmetric(horizontal: 16),
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8),
  //               child: IntrinsicHeight(
  //                 // This helps the card take minimum required width
  //                 child: Column(
  //                   mainAxisSize:
  //                       MainAxisSize.min, // This makes column wrap to content
  //                   children: [
  //                     const Padding(
  //                       padding: EdgeInsets.only(top: 0, bottom: 5),
  //                       child: Text(
  //                         'Fishbone Type:',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ),
  //                     IntrinsicWidth(
  //                       // Add a fixed width to ensure consistent sizing
  //                       // width: 500,  // or a specific width
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         mainAxisAlignment: MainAxisAlignment
  //                             .spaceEvenly, // Distributes space evenly
  //                         children: [
  //                           ...FishboneType.values.map(
  //                             (type) => Expanded(
  //                               // Use Expanded instead of Flexible
  //                               child: Padding(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     horizontal: 4), // Add some spacing
  //                                 child: DottedBorder(
  //                                   borderType: BorderType.RRect,
  //                                   radius: const Radius.circular(12),
  //                                   child: Container(
  //                                     // Add Container for consistent sizing
  //                                     height: 100, // Fixed height for all cells
  //                                     constraints: const BoxConstraints(
  //                                       minWidth:
  //                                           100, // Minimum width for each cell
  //                                     ),
  //                                     child: Column(
  //                                       mainAxisAlignment: MainAxisAlignment
  //                                           .center, // Center content vertically
  //                                       children: [
  //                                         Text(
  //                                           type.name,
  //                                           textAlign:
  //                                               TextAlign.center, // Center text
  //                                           style: const TextStyle(
  //                                             fontSize:
  //                                                 14, // Consistent font size
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                           height: 2,
  //                                         ),
  //                                         Image.asset(
  //                                           "assets/images/1.png",
  //                                           height: 15,
  //                                           width: 30,
  //                                         ),
  //                                         Radio(
  //                                           fillColor: WidgetStateProperty.all(Colors.black),
  //                                           value: type,
  //                                           groupValue:
  //                                               provider.currentFishboneType,
  //                                          onChanged: (FishboneType? value) {
  //                                     if (value != null) {
  //                                       provider.setFishboneType(value);
  //                                     }
  //                                   },
  //                                           focusNode: FocusNode(),
  //                                           autofocus: true,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                     // IntrinsicWidth(
  //                     //   child: Row(
  //                     //     spacing: 5,
  //                     //     mainAxisSize: MainAxisSize.min,
  //                     //     children: [
  //                     //       ...FishboneType.values.map(
  //                     //         (type) => Flexible(
  //                     //             child: DottedBorder(
  //                     //                           borderType: BorderType.RRect,
  //                     //                           radius: Radius.circular(12),
  //                     //           child: Column(
  //                     //             children: [
  //                     //               Text(type.name),
  //                     //               Radio(
  //                     //                 value: type,
  //                     //                 groupValue: provider.currentFishboneType,
  //                     //                 onChanged: (value) {
  //                     //                   // setState(() {
  //                     //                   //   selectedOption = value;
  //                     //                   // });
  //                     //                 },

  //                     //                 // semanticLabel: 'Option 1',
  //                     //                 focusNode: FocusNode(),
  //                     //                 autofocus:
  //                     //                     true, // Autofocus is optional, depending on the app's needs.
  //                     //               ),
  //                     //             ],
  //                     //           ),
  //                     //         )

  //                     //             // RadioListTile<FishboneType>(
  //                     //             //   dense: true,  // Makes the RadioListTile more compact
  //                     //             //   // title: Text(type.name),
  //                     //             //   value: type,
  //                     //             //   groupValue: provider.currentFishboneType,
  //                     //             //   onChanged: (FishboneType? value) {
  //                     //             //     if (value != null) {
  //                     //             //       provider.setFishboneType(value);
  //                     //             //     }
  //                     //             //   },
  //                     //             // ),

  //                     //             ),
  //                     //       ),
  //                     //     ],
  //                     //   ),
  //                     // )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }




}
