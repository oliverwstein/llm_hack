import 'package:flutter/material.dart';
import 'package:piecemeal/piecemeal.dart';
import 'src/engine/game.dart';
import 'src/engine/stage.dart';
import 'src/app.dart';
import 'src/components/render.dart';

void main() {
  runApp(RoguelikeApp());
}

class RoguelikeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LLM Hack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game game; // Instance of your Game class

  @override
  void initState() {
    super.initState();
    game = Game(); // Initialize the game
    game.initializeWorld(); // Setup the world or stage
    // Consider running game loop updates in an isolate or async function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LLM Hack'),
      ),
      body: Center(
        child: StageTextWidget(stage: game.stage), // Custom widget to render the game stage as text
      ),
    );
  }
}

class StageTextWidget extends StatelessWidget {
  final Stage stage;

  StageTextWidget({required this.stage});

  @override
  Widget build(BuildContext context) {
    // Convert the entire stage into a single string representation
    String stageRepresentation = '';
    for (int y = 0; y < stage.height; y++) {
      for (int x = 0; x < stage.width; x++) {
        final tile = stage.getTile(Vec(x, y));
        var renderComponent = tile.getComponent<RenderTile>();
        stageRepresentation += renderComponent!.appearance; // Assuming a method to get appearance
      }
      if (y < stage.height - 1) stageRepresentation += '\n'; // New line for each row except the last
    }

    // Using a monospaced font to ensure alignment
    return SingleChildScrollView(
      child: Text(
        stageRepresentation,
        style: TextStyle(
          fontFamily: 'Courier', // Consider a monospaced font
          fontSize: 14,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
