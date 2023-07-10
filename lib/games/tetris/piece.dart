import 'package:flutter/material.dart';

import 'board.dart';
import 'values.dart';

class Piece {
  Piece({required this.type});
  final Tetromino type;
  List<int> positions = [];

  Color get color => type.color;

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        positions = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        positions = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        positions = [-4, -5, -6, -7];
        break;
      case Tetromino.O:
        positions = [-15, -16, -5, -6];
        break;
      case Tetromino.S:
        positions = [-15, -14, -6, -5];
        break;
      case Tetromino.Z:
        positions = [-26, -16, -6, -5];
        break;
      case Tetromino.T:
        positions = [-26, -16, -6, -15];
        break;
      default:
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.left:
        positions = positions.map((e) => e - 1).toList();
        break;
      case Direction.right:
        positions = positions.map((e) => e + 1).toList();
        break;
      case Direction.down:
        positions = positions.map((e) => e + rowLength).toList();
        break;
      default:
    }
  }

  int rotationState = 1;

  void rotatePiece() {
    var newPositions = <int>[];
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            newPositions = [
              positions[1] - rowLength,
              positions[1],
              positions[1] + rowLength,
              positions[1] + rowLength + 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPositions = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + rowLength - 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[1] + rowLength,
              positions[1],
              positions[1] - rowLength,
              positions[1] - rowLength - 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[1] - rowLength + 1,
              positions[1],
              positions[1] + 1,
              positions[1] - 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      case Tetromino.O:
        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPositions = [
              positions[1] - rowLength,
              positions[1],
              positions[1] + rowLength,
              positions[1] + rowLength - 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPositions = [
              positions[1] - 1,
              positions[1],
              positions[1] - 1,
              positions[1] + 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[1] + rowLength,
              positions[1],
              positions[1] - rowLength,
              positions[1] - rowLength + 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[1] + 1,
              positions[1],
              positions[1] - 1,
              positions[1] + rowLength + 1
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      case Tetromino.I:
        switch (rotationState) {
          case 0:
            newPositions = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + 2,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPositions = [
              positions[1] - rowLength,
              positions[1],
              positions[1] + rowLength,
              positions[1] + 2 * rowLength,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[1] + 1,
              positions[1],
              positions[1] - 1,
              positions[1] - 2,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[1] + rowLength,
              positions[1],
              positions[1] - rowLength,
              positions[1] - 2 * rowLength,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
        }
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            newPositions = [
              positions[1],
              positions[1] + 1,
              positions[1] + rowLength - 1,
              positions[1] + rowLength,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPositions = [
              positions[0] - rowLength,
              positions[0],
              positions[0] + 1,
              positions[0] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[1],
              positions[1] + 1,
              positions[1] + rowLength - 1,
              positions[1] + rowLength,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
              break;
            }
          case 3:
            newPositions = [
              positions[0] - rowLength,
              positions[0],
              positions[0] + 1,
              positions[0] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            newPositions = [
              positions[0] + rowLength - 2,
              positions[1],
              positions[2] - rowLength - 1,
              positions[3] + 1,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPositions = [
              positions[0] - rowLength + 2,
              positions[1],
              positions[2] - rowLength + 1,
              positions[3] - 1,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[0] + rowLength - 2,
              positions[1],
              positions[2] + rowLength - 1,
              positions[3] + 1,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[0] - rowLength + 2,
              positions[1],
              positions[2] - rowLength + 1,
              positions[3] - 1,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            newPositions = [
              positions[2] - rowLength,
              positions[2],
              positions[2] + 1,
              positions[2] + rowLength,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPositions = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + rowLength,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[1] - rowLength,
              positions[1] - 1,
              positions[1] + 1,
              positions[1] + rowLength,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[2] - rowLength,
              positions[2] - 1,
              positions[2],
              positions[2] + 1,
            ];
            if (piecePositionIsValid(newPositions)) {
              positions = newPositions;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

      default:
        break;
    }
  }
}

bool positionIsValid(int position) {
  final row = (position / rowLength).floor();
  final col = position % rowLength;
  if (row < 0 || col < 0 || board[row][col] != null) {
    return false;
  } else {
    return true;
  }
}

bool piecePositionIsValid(List<int> positions) {
  var firstColOccupied = false;
  var lastColOccupied = false;

  for (final pos in positions) {
    if (!positionIsValid(pos)) {
      return false;
    }
    final col = pos % rowLength;
    if (col == 0) {
      firstColOccupied = true;
    }
    if (col == rowLength - 1) {
      lastColOccupied = true;
    }
  }
  return !(firstColOccupied && lastColOccupied);
}
