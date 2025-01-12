import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'exercise_result.dart';

class BackgroundMusicManager {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  /// Play music from a given URL.
  ///
  /// [audioUrl] The URL of the audio file.
  static Future<void> playMusic(String audioUrl) async {
    if (!_isPlaying) {
      try {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.setVolume(1.0);
        await _player.play(UrlSource(audioUrl));
        _isPlaying = true;
      } catch (e) {
        print("Error playing music: $e");
      }
    }
  }

  /// Stop the currently playing music.
  static Future<void> stopMusic() async {
    if (_isPlaying) {
      try {
        await _player.stop();
        _isPlaying = false;
      } catch (e) {
        print("Error stopping music: $e");
      }
    }
  }
}

class TimerPage extends StatefulWidget {
  final String exerciseName;

  const TimerPage({required this.exerciseName, super.key});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _start = 60; // Initial countdown time in seconds
  Timer? _timer;
  bool _musicEnabled = true;
  String _quote = "Fetching quote...";
  late ConfettiController _confettiController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _loadMusicPreference();
    _fetchQuote();
    _checkCompletionStatus();
    _startTimer();
  }

  /// Fetch a random motivational quote from an API.
  Future<void> _fetchQuote() async {
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/quotes'));
      if (response.statusCode == 200) {
        final data = response.body;
        final quotes = data.split('"quote":')[1].split('"')[1];
        final author = data.split('"author":')[1].split('"')[1];
        setState(() {
          _quote = '"$quotes" - $author';
        });
      } else {
        setState(() {
          _quote = "Failed to load quote.";
        });
      }
    } catch (e) {
      setState(() {
        _quote = "Error fetching quote.";
      });
    }
  }

  /// Start the countdown timer.
  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_start == 0) {
          timer.cancel();
          BackgroundMusicManager.stopMusic();
          _showTimeUpDialog();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );

    if (_musicEnabled) {
      BackgroundMusicManager.playMusic(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    }
  }

  /// Load music preference from shared preferences.
  Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _musicEnabled = prefs.getBool('music_enabled') ?? true;
    });
    if (_musicEnabled) {
      BackgroundMusicManager.playMusic(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    }
  }

  /// Toggle music on or off and save the preference.
  Future<void> _toggleMusic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _musicEnabled = value;
      prefs.setBool('music_enabled', value);
    });
    if (_musicEnabled) {
      BackgroundMusicManager.playMusic(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    } else {
      BackgroundMusicManager.stopMusic();
    }
  }

  /// Mark the exercise as completed in shared preferences.
  Future<void> _markExerciseAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.exerciseName}_completed', true);
  }

  /// Check if the exercise has been completed.
  Future<void> _checkCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCompleted = prefs.getBool('${widget.exerciseName}_completed') ?? false;
    });
  }

  /// Show a dialog indicating exercise completion.
  void _showCompletionDialog() {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have completed the exercise. Well done!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToResultsPage(); // Navigate to results page after completion
              },
            ),
          ],
        );
      },
    );
  }

  /// Show a dialog indicating that the exercise is already completed.
  void _showAlreadyCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exercise Completed'),
          content: const Text('You have already completed this exercise.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Show a dialog indicating that the time is up.
  void _showTimeUpDialog() {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oops! Time\'s Up!!'),
          content: const Text('The timer has ended. Please try again!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Navigate to the results page.
  void _navigateToResultsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExerciseResultPage(exerciseName: widget.exerciseName),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    BackgroundMusicManager.stopMusic();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.exerciseName} Timer'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(
              _musicEnabled ? Icons.music_note : Icons.music_off,
              color: Colors.white,
            ),
            onPressed: () {
              _toggleMusic(!_musicEnabled);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Displaying a motivational quote
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.teal),
              ),
              child: Text(
                _quote,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Timer display
            Text(
              'Time remaining: $_start seconds',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Complete Exercise button
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  if (!_isCompleted) {
                    _markExerciseAsCompleted();
                    _showCompletionDialog();
                  } else {
                    _showAlreadyCompletedDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Exercise',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            // Confetti animation for completion
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple
              ],
            ),
          ],
        ),
      ),
    );
  }
}
