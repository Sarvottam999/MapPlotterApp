// // Create new file: lib/presentation/widgets/floating_toolbar.dart

// import 'package:flutter/material.dart';
// import 'package:myapp/presentantion/providers/drawing_provider.dart';
// import 'package:provider/provider.dart';
 
// class FloatingToolbar extends StatelessWidget {
//   const FloatingToolbar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DrawingProvider>(
//       builder: (context, provider, _) {
//         if (!provider.isSelectionMode || provider.selectedShape == null) {
//           return const SizedBox.shrink();
//         }

//         return Card(
//           elevation: 8.0,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   tooltip: 'Delete Shape',
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Delete Shape'),
//                         content: const Text('Are you sure you want to delete this shape?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               provider.deleteSelectedShape();
//                               Navigator.pop(context);
//                             },
//                             child: const Text('Delete'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
               
//                 const SizedBox(width: 8),
//                IconButton(
//                   icon: Icon(provider.isEditMode ? Icons.check : Icons.edit),
//                   tooltip: provider.isEditMode ? 'Save Changes' : 'Edit Shape',
//                   color: provider.isEditMode ? Colors.green : null,
//                   onPressed: () {
//                     if (provider.isEditMode) {
//                       provider.stopEditing();
//                     } else {
//                       provider.startEditing();
//                     }
//                   },
//                 ),
//                  // Only show cancel when editing
//                 if (provider.isEditMode)
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     tooltip: 'Cancel Edit',
//                     onPressed: () => provider.stopEditing(),
//                   ),
//                 // Deselect button
//                 if (!provider.isEditMode) ...[
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     tooltip: 'Deselect',
//                     onPressed: () => provider.selectShape(null),
//                   ),
//                 ]
//               ]
//             )
//           ),
//         );
//       },
//     );
//   }
// }