import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/material.dart';

/// A wrapper class to manage background audio playback using just_audio_background.
/// This implementation uses the newer just_audio_background package instead of
/// the older audio_service implementation.
class BackgroundAudioPlayer {
  final AudioPlayer _player;
  final _playlist = ConcatenatingAudioSource(children: []);
  
  BackgroundAudioPlayer() : _player = AudioPlayer() {
    _player.setAudioSource(_playlist);
  }

  /// Add a track to the playlist
  Future<void> addTrack({
    required String url,
    required String title,
    required String artist,
    String? artUri,
  }) async {
    final mediaItem = MediaItem(
      id: url,
      title: title,
      artist: artist,
      artUri: artUri != null ? Uri.parse(artUri) : null,
    );

    await _playlist.add(AudioSource.uri(
      Uri.parse(url),
      tag: mediaItem,
    ));
  }

  /// Clear the current playlist
  Future<void> clearPlaylist() async {
    await _playlist.clear();
  }

  /// Start playing from a specific index
  Future<void> play({int index = 0}) async {
    if (_playlist.length > index) {
      await _player.seek(Duration.zero, index: index);
      await _player.play();
    }
  }

  /// Pause playback
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _player.play();
  }

  /// Stop playback
  Future<void> stop() async {
    await _player.stop();
  }

  /// Skip to next track
  Future<void> next() async {
    await _player.seekToNext();
  }

  /// Skip to previous track
  Future<void> previous() async {
    await _player.seekToPrevious();
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Get the current playback position
  Stream<Duration> get positionStream => _player.positionStream;

  /// Get the total duration of the current track
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Get the current playback state
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Get the current track index
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  /// Clean up resources
  Future<void> dispose() async {
    await _player.dispose();
  }
}