import 'package:flutter/material.dart';
import 'package:piecemeal/piecemeal.dart';
import 'src/engine/game.dart';
import 'src/engine/stage.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/components/render.dart';

void main()  async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(MyApp(settingsController: settingsController));
  runApp(const RoguelikeApp());
}

class RoguelikeApp extends StatelessWidget {
  const RoguelikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LLM Hack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game game; // Instance of your Game class

  @override
  void initState() {
    super.initState();
    game = Game(); // Initialize the game
    game.run();
    // Consider running game loop updates in an isolate or async function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LLM Hack'),
      ),
      body: Center(
        child: StageTextWidget(stage: game.stage), // Custom widget to render the game stage as text
      ),
    );
  }
}

class StageTextWidget extends StatelessWidget {
  final Stage stage;

  const StageTextWidget({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    double tileSize = 12; // Size of each tile square

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
      shrinkWrap: true, // Fit the content in the visible area
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: stage.width, // Number of tiles across the stage width
        childAspectRatio: 1, // Aspect ratio for each item is 1 (square)
      ),
      itemCount: stage.width * stage.height, // Total number of tiles
      itemBuilder: (context, index) {
        final x = index % stage.width;
        final y = index ~/ stage.width;
        final tile = stage.getTile(Vec(x, y));
        var renderComponent = tile.getComponent<RenderTile>();

        return Container(
          width: tileSize,
          height: tileSize,
          alignment: Alignment.center,
          child: Text(
            renderComponent!.appearance,
            style: TextStyle(fontFamily: 'Courier', fontSize: tileSize),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
