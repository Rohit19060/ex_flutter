import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'piece.dart';
import 'pixel.dart';
import 'values.dart';

List<List<Tetromino?>> board =
    List.generate(columnLength, (i) => List.generate(rowLength, (j) => null));

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.L);

  int _currentScore = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    const frameRate = Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        clearLines();
        checkLanding();
        if (_isGameOver) {
          timer.cancel();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Game Over'),
              content: Text('Your score is $_currentScore'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isGameOver = false;
                    _currentScore = 0;
                    board = List.generate(columnLength,
                        (i) => List.generate(rowLength, (j) => null));
                    createNewPiece();
                    startGame();
                    setState(() {});
                  },
                  child: const Text('Play Again'),
                ),
              ],
            ),
          );
        }
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  bool checkCollision(Direction direction) {
    for (var i = 0; i < currentPiece.positions.length; i++) {
      var row = (currentPiece.positions[i] / rowLength).floor();
      var col = currentPiece.positions[i] % rowLength;
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }
      if (row >= columnLength || col < 0 || col >= rowLength) {
        return true;
      }
      if (row >= 0 && col >= 0) {
        if (board[row][col] != null) {
          return true;
        }
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (var i = 0; i < currentPiece.positions.length; i++) {
        final row = (currentPiece.positions[i] / rowLength).floor();
        final col = currentPiece.positions[i] % rowLength;
        if (row >= 0 && col >= 0) {
          board[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    currentPiece = Piece(
        type: Tetromino.values[Random().nextInt(Tetromino.values.length)]);
    currentPiece.initializePiece();
    if (isGameOver()) {
      _isGameOver = true;
    }
  }

  void clearLines() {
    for (var row = columnLength - 1; row >= 0; row--) {
      var rowIsFull = true;
      for (var col = 0; col < rowLength; col++) {
        if (board[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }
      if (rowIsFull) {
        for (var r = row; r > 0; r--) {
          board[r] = List.from(board[r - 1]);
        }
        board[0] = List.generate(row, (i) => null);
        _currentScore++;
      }
    }
  }

  bool isGameOver() {
    for (var col = 0; col < rowLength; col++) {
      if (board[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowLength * columnLength,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10),
                itemBuilder: (context, i) {
                  final row = (i / rowLength).floor();
                  final col = i % rowLength;
                  if (currentPiece.positions.contains(i)) {
                    return Pixel(color: currentPiece.color);
                  } else if (board[row][col] != null) {
                    return Pixel(
                      color: board[row][col]!.color,
                    );
                  } else {
                    return Pixel(color: Colors.grey.shade900);
                  }
                }),
          ),
          Text('Score : $_currentScore',
              style: const TextStyle(fontSize: 20, color: Colors.white)),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: moveLeft,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: rotatePiece,
                  icon: const Icon(Icons.rotate_right),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: moveRight,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('rowLength', rowLength));
    properties.add(IntProperty('columnLength', columnLength));
    properties.add(DiagnosticsProperty<Piece>('currentPiece', currentPiece));
  }
}
