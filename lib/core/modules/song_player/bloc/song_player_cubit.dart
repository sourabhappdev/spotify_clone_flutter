import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/core/modules/auth/Models/song_model.dart';
import 'package:spotify_clone/core/modules/song_player/bloc/song_player_state.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../../common/services/app_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late ConcatenatingAudioSource playlist;
  bool skipInitialEvent = true, emitOnce = true;

  Duration songDuration = Duration.zero;
  ValueNotifier<Duration> songPosition = ValueNotifier(Duration.zero);

  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition.value = position;
      if (emitOnce) emit(SongPlayerLoaded());
      emitOnce = false;
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration ?? Duration.zero;
    });

    audioPlayer.currentIndexStream.listen((index) {
      if (!skipInitialEvent && index != null) {
        AppState.instance.currentPlayingSongIndex.value = index;
      }
    });
  }

  Future<void> loadPlaylist(List<SongModel> songs) async {
    playlist = ConcatenatingAudioSource(
      children: songs.map((song) {
        return AudioSource.uri(
          Uri.parse(song.url),
          tag: MediaItem(
            id: song.id,
            title: song.name,
            artist: song.artists.first,
            album: song.name,
            artUri: Uri.parse(song.coverImage),
          ),
        );
      }).toList(),
    );

    try {
      await audioPlayer.setAudioSource(playlist);
      await audioPlayer.seek(
        Duration.zero,
        index: AppState.instance.currentPlayingSongIndex.value,
      );
      skipInitialEvent = false;
      await audioPlayer.play();
      emit(SongPlayerLoaded());
    } catch (e) {
      emit(SongPlayerFailure());
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }

  void seekTo(int value) {
    audioPlayer.seek(Duration(seconds: value));
    emit(SongPlayerLoaded());
  }

  Future<void> nextSong() async {
    if (audioPlayer.hasNext) {
      await audioPlayer.seekToNext();
    } else {
      await audioPlayer.seek(Duration.zero);
      audioPlayer.pause();
    }
    emit(SongPlayerLoaded());
  }

  Future<void> previousSong() async {
    if (audioPlayer.hasPrevious) {
      await audioPlayer.seekToPrevious();
    } else {
      await audioPlayer.seek(Duration.zero);
    }
    emit(SongPlayerLoaded());
  }

  @override
  Future<void> close() async {
    await audioPlayer.stop();
    audioPlayer.dispose();
    return super.close();
  }
}
