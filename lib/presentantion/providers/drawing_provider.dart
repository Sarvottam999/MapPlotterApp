import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/circle_shape.dart';
import 'package:myapp/domain/entities/fishbone_shape.dart';
import 'package:myapp/domain/entities/line_shape.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:myapp/domain/entities/square_shape.dart';

class DrawingProvider with ChangeNotifier {
  ShapeType _currentShape = ShapeType.none;
  List<Shape> _shapes = [];
  List<LatLng> _currentPoints = [];
  LatLng? _currentCursor;
  FishboneType _currentFishboneType = FishboneType.normal;


  // Undo/Redo stacks
  final List<List<Shape>> _undoStack = [];
  final List<List<Shape>> _redoStack = [];

  ShapeType get currentShape => _currentShape;
  List<Shape> get shapes => _shapes;
  List<LatLng> get currentPoints => _currentPoints;
  LatLng? get currentCursor => _currentCursor;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  FishboneType get currentFishboneType => _currentFishboneType;
  void setFishboneType(FishboneType type) {
    _currentFishboneType = type;
    notifyListeners();
  }


  void setCurrentShape(ShapeType type) {
    _currentShape = type;
    _currentPoints = [];
    notifyListeners();
  }

  void addPoint(LatLng point) {
    _currentPoints.add(point);

    if (_currentPoints.length == 2) {
      Shape? newShape;

      switch (_currentShape) {
        case ShapeType.line:
          newShape = LineShape(points: List.from(_currentPoints));
          break;
        case ShapeType.square:
          newShape = SquareShape(points: List.from(_currentPoints));
          break;
        case ShapeType.circle:
          newShape = CircleShape(points: List.from(_currentPoints));
          break;
        // case ShapeType.fishbone:  // Add this case
        //   newShape = FishboneShape(points: List.from(_currentPoints));
        //   break;
        case ShapeType.fishbone:
          newShape = FishboneShape(
            points: List.from(_currentPoints),
            fishboneType: _currentFishboneType,
          );
          break;
        default:
          break;
      }

      if (newShape != null) {
        // Save current state to undo stack before adding new shape
        _undoStack.add(List.from(_shapes));
        _redoStack.clear(); // Clear redo stack when new action is performed

        _shapes.add(newShape);
        _currentPoints = [];
        _currentShape = ShapeType.none;
      }
    }

    notifyListeners();
  }

  void undo() {
    if (!canUndo) return;

    _redoStack.add(List.from(_shapes));
    _shapes = List.from(_undoStack.removeLast());
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;

    _undoStack.add(List.from(_shapes));
    _shapes = List.from(_redoStack.removeLast());
    notifyListeners();
  }

  void updateCursor(LatLng? point) {
    _currentCursor = point;
    notifyListeners();
  }

  Map<String, dynamic>? getCurrentShapeDetails() {
    if (_currentShape == ShapeType.none) return null;

    List<LatLng> points = List.from(_currentPoints);
    if (_currentCursor != null && _currentPoints.isNotEmpty) {
      points.add(_currentCursor!);
    }

    Shape tempShape;
    switch (_currentShape) {
      case ShapeType.line:
        tempShape = LineShape(points: points);
        break;
      case ShapeType.square:
        tempShape = SquareShape(points: points);
        break;
      case ShapeType.circle:
        tempShape = CircleShape(points: points);
        break;
      
      default:
        return null;
    }

    Map<String, dynamic> details = tempShape.getDetails();
    if (_currentCursor != null) {
      details['cursor'] =
          '${_currentCursor!.latitude.toStringAsFixed(6)}, ${_currentCursor!.longitude.toStringAsFixed(6)}';
    }

    return details;
  }
}
