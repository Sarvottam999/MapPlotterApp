import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/map_screen.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';
import 'package:provider/provider.dart';

void main() {
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
          home:   DrawingScreen(),
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
          topRightBar(),
           Positioned(
              bottom: 16,
      left: 0,
      right: 0,
              child: _buildFishboneTypeSelector(context)),      




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
      left: 16,
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
            padding: const EdgeInsets.all(4),
            child: Column(
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
                  icon: Icons.living,
                  image: Image.asset("assets/images/1.png", height: 30, width: 30,),
                  label: 'Circle',
                  shapeType: ShapeType.fishbone,
                ), 
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

 

   Positioned topRightBar() {
    return Positioned(
      top: 5,
      right: 300,
      // bottom: 0,
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
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              
Consumer<DrawingProvider>(
                  builder: (context, provider, _) => IconButton(
                    icon: const Icon(Icons.redo),
                    onPressed: provider.canRedo ? provider.redo : null,
                    tooltip: 'Redo',
                  ),
                ),

                Consumer<DrawingProvider>(
                  builder: (context, provider, _) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.undo),
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
      ),
    );
  }

 
 Widget _buildFishboneTypeSelector(BuildContext context) {
  return Consumer<DrawingProvider>(
    builder: (context, provider, _) {
      if (provider.currentShape != ShapeType.fishbone) return SizedBox();

      return Container(
        width: 100,
         decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(2.5))
        ),
        child: Column(
          children: [
            Text('Fishbone Type:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...FishboneType.values.map(
              (type) => RadioListTile<FishboneType>(
                title: Text(type.name),
                value: type,
                groupValue: provider.currentFishboneType,
                onChanged: (FishboneType? value) {
                  if (value != null) {
                    provider.setFishboneType(value);
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


 

 
}


