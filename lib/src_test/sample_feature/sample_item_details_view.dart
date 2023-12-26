import 'package:flutter/material.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';

class SampleItemDetailsView extends StatefulWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  _SampleItemDetailsViewState createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  late final Ollama llm;
  final TextEditingController _promptController = TextEditingController();
  String generatedText = 'Enter a prompt and press enter to generate response.';

  @override
  void initState() {
    super.initState();
    llm = Ollama(
      defaultOptions: const OllamaOptions(
        model: 'llama2:latest',
      ),
    );
  }

  Future<void> _generateResponse(String prompt) async {
    final res = await llm.generate(prompt);
    setState(() {
      generatedText = res.generations.length > 0 ? res.generations.first.output : 'No output generated';
    });
  }

  @override
  void dispose() {
    llm.close();
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter your prompt',
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _generateResponse(value.trim());
                }
              },
            ),
            const SizedBox(height: 20),
            Text(generatedText),
          ],
        ),
      ),
    );
  }
}
