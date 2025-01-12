import 'package:flutter/material.dart';
import 'exercise_details_page.dart';

class ExerciseSelectionPage extends StatelessWidget {
  const ExerciseSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> exercises = [
      'Push-ups',
      'Squats',
      'Lunges',
      'Planks',
      'Burpees',
      'Mountain Climbers',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercises'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  exercises[index],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailsPage(
                        exerciseName: exercises[index],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
