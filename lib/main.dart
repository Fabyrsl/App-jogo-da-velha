import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 142, 27, 84),
        ),
        useMaterial3: true,
      ),
      home: const TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  const TicTacToeHomePage({super.key});

  @override
  State<TicTacToeHomePage> createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  List<String> board = List.filled(9, '');
  bool xTurn = true;
  String winner = '';
  bool vsComputer = false;

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      xTurn = true;
      winner = '';
    });
  }

  void handleTap(int index) {
    if (board[index] != '' || winner != '') {
      return;
    }

    setState(() {
      board[index] = xTurn ? 'X' : 'O';
      xTurn = !xTurn;
      winner = checkWinner();

      if (vsComputer && !xTurn && winner == '') {
        Future.delayed(const Duration(milliseconds: 500), computerMove); // Delay para simular o tempo de raciocínio do computador
      }
    });
  }

  void computerMove() {
    List<int> emptyCells = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        emptyCells.add(i);
      }
    }

    if (emptyCells.isNotEmpty) {
      Random rand = Random();
      int move = emptyCells[rand.nextInt(emptyCells.length)];
      setState(() {
        board[move] = 'O';
        xTurn = true;
        winner = checkWinner();
      });
    }
  }

  String checkWinner() {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var line in lines) {
      if (board[line[0]] != '' &&
          board[line[0]] == board[line[1]] &&
          board[line[0]] == board[line[2]]) {
        return board[line[0]];
      }
    }

    if (board.contains('')) {
      return '';
    } else {
      return 'Empate';
    }
  }

  Widget buildBoard() {
    return GridView.builder(
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => handleTap(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
            ),
            child: Center(
              child: Text(
                board[index],
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Jogo da Velha'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 320,
          height: 480,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SwitchListTile(
                title: const Text('Jogar contra o computador'),
                value: vsComputer,
                onChanged: (bool value) {
                  setState(() {
                    vsComputer = value;
                    resetGame();
                  });
                },
              ),
              Expanded(child: buildBoard()),
              if (winner.isNotEmpty)
                Text(
                  winner == 'Empate' ? 'Empate!' : 'Vencedor: $winner',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetGame,
                child: const Text('Reiniciar Jogo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
