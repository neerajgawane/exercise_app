import 'package:flutter/material.dart';
import 'package:exercise_app/timer_page.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final String exerciseName;

  const ExerciseDetailsPage({required this.exerciseName, super.key});

  @override
  Widget build(BuildContext context) {
    // Map to store exercise instructions
    Map<String, String> exerciseDetails = {
      'Push-ups':
          '1. Get into a plank position.\n2. Lower your body until your chest nearly touches the floor.\n3. Push yourself back to the starting position.',
      'Squats':
          '1. Stand with feet shoulder-width apart.\n2. Lower your body by bending your knees and hips.\n3. Return to the starting position.',
      'Lunges':
          '1. Step forward with one leg.\n2. Lower your body until both knees are bent at a 90-degree angle.\n3. Return to the starting position and repeat with the other leg.',
      'Planks':
          '1. Get into a push-up position and lower your body onto your forearms.\n2. Hold your body in a straight line from head to heels.\n3. Maintain the position for the desired time.',
      'Burpees':
          '1. Stand with feet shoulder-width apart.\n2. Bend your knees and place your hands on the floor.\n3. Jump your feet back into a push-up position.\n4. Perform a push-up, then jump your feet back to your hands.\n5. Stand up and jump into the air.',
      'Mountain Climbers':
          '1. Start in a push-up position.\n2. Bring one knee towards your chest, then quickly switch legs.\n3. Continue alternating legs at a fast pace.',
    };

    // Method to get the image path based on the exercise name
    String getImagePath() {
      return 'assets/images/${exerciseName.toLowerCase().replaceAll(' ', '_')}.png';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                getImagePath(),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Instructions:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ) ??
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              exerciseDetails[exerciseName] ?? 'No details available.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ) ??
                  TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            // Start Exercise button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerPage(exerciseName: exerciseName),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Start Exercise',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
