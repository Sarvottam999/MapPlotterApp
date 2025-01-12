import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/map_screen.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Map Drawing App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const DrawingScreen(),
      ),
    );
  }
}

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          MapScreen(),
          sideBaar(),
          bottomBar(),
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
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 10,
            //         offset: const Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   // color: Colors.white,
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            //     child: Row(
            //       children: [
            //         IconButton(
            //           icon: const Icon(Icons.remove, size: 16),
            //           onPressed: () {},
            //         ),
            //         const Text('93%', style: TextStyle(fontSize: 14)),
            //         IconButton(
            //           icon: const Icon(Icons.add, size: 16),
            //           onPressed: () {},
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 16),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 10,
            //         offset: const Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   // color: Colors.white,
            //   child: Row(
            //     children: [
            //       IconButton(
            //         icon: const Icon(Icons.chevron_left, size: 16),
            //         onPressed: () {},
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.chevron_right, size: 16),
            //         onPressed: () {},
            //       ),
            //     ],
            //   ),
            // ),
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
                _toolButton(Icons.open_with),
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
                // _toolButton(Icons.remove),
                // _selectedToolButton(Icons.edit),
                // _toolButton(Icons.text_fields),
                // _toolButton(Icons.image),
                // _toolButton(Icons.link),
                // _toolButton(Icons.group),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolButton(IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: () {},
    );
  }

  Widget _selectedToolButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.indigo),
        onPressed: () {},
      ),
    );
  }

  Widget _circleButton() {
    return IconButton(
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          shape: BoxShape.circle,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildColorPicker(List<Color> colors) {
    return Wrap(
      spacing: 8,
      children: colors.map((color) {
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: color == Colors.white
                ? Border.all(color: Colors.grey[300]!)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStrokeWidthPicker() {
    return Row(
      children: [
        _strokeWidthButton(1),
        const SizedBox(width: 8),
        _strokeWidthButton(2),
        const SizedBox(width: 8),
        _strokeWidthButton(3),
      ],
    );
  }

  Widget _strokeWidthButton(double height) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: 16,
          height: height,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildLayerControls() {
    return Row(
      children: [
        _layerButton(Icons.chevron_left),
        const SizedBox(width: 8),
        _layerButton(Icons.keyboard_arrow_up),
        const SizedBox(width: 8),
        _layerButton(Icons.keyboard_arrow_down),
        const SizedBox(width: 8),
        _layerButton(Icons.chevron_right),
      ],
    );
  }

  Widget _layerButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 16),
    );
  }
}
