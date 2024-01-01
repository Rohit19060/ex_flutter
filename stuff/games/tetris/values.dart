import 'package:flutter/material.dart';

// enum Tetromino { L, J, I, O, S, Z, T }
enum Tetromino { L, J, I, O, S, Z, T }

enum Direction { left, right, down }

const rowLength = 10, columnLength = 15;

extension TetrominoExt on Tetromino {
  Color get color {
    switch (this) {
      case Tetromino.L:
        return Colors.orange;
      case Tetromino.J:
        return Colors.blue;
      case Tetromino.I:
        return Colors.cyan;
      case Tetromino.O:
        return Colors.yellow;
      case Tetromino.S:
        return Colors.green;
      case Tetromino.Z:
        return Colors.red;
      case Tetromino.T:
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
}
