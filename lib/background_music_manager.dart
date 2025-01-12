import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class BackgroundMusicManager {
  // Singleton AudioPlayer instance to manage audio playback
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> playMusic(String assetPath) async {
    // Check if music is already playing
    if (!_isPlaying) {
      try {
        final ByteData data = await rootBundle.load(assetPath);

        // Ensure the asset is not empty
        if (data.lengthInBytes > 0) {
          print("Asset file found: $assetPath");

          // Set the audio source to the asset file
          await _audioPlayer.setSource(AssetSource(assetPath));

          // Set the player to loop the music
          await _audioPlayer.setReleaseMode(ReleaseMode.loop);

          // Set volume to maximum
          await _audioPlayer.setVolume(1.0);

          // Start playing the music
          await _audioPlayer.resume();

          // Mark as playing
          _isPlaying = true;
        } else {
          print("Asset file does not exist or is empty: $assetPath");
        }
      } catch (e) {
        // Handle any errors that occur
        print("Error playing music: $e");
      }
    } else {
      // Inform that music is already playing
      print("Music is already playing.");
    }
  }

  /// Stop the currently playing music.
  static Future<void> stopMusic() async {
    // Check if music is currently playing
    if (_isPlaying) {
      try {
        // Pause the music
        await _audioPlayer.pause();

        // Mark as not playing
        _isPlaying = false;
      } catch (e) {
        // Handle any errors that occur
        print("Error stopping music: $e");
      }
    } else {
      // Inform that music is not currently playing
      print("Music is not currently playing.");
    }
  }
}
