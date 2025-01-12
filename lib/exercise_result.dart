import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ExerciseResultPage extends StatefulWidget {
  final String exerciseName;

  const ExerciseResultPage({required this.exerciseName, super.key});

  @override
  _ExerciseResultPageState createState() => _ExerciseResultPageState();
}

class _ExerciseResultPageState extends State<ExerciseResultPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play(); // Start confetti animation
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define custom text styles
    const headlineStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    final bodyTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.grey[700],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.exerciseName} Result'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Congratulations!',
              style: headlineStyle,
            ),
            const SizedBox(height: 20),
            Text(
              'You have completed the exercise. Well done!',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality
                  .explosive, // Set the confetti blast direction
              shouldLoop: false, // Do not loop the confetti animation
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
