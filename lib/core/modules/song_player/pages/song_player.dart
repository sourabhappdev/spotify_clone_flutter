import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/common/utils/toast_utils.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/modules/auth/Models/song_model.dart';
import 'package:spotify_clone/core/modules/profile/bloc/favorite_songs_cubit.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../configs/theme/app_colors.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';

class SongPlayerPage extends StatefulWidget {
  final List<SongModel> songEntityList;

  const SongPlayerPage({required this.songEntityList, super.key});

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final ValueNotifier<bool> isLikedSong = ValueNotifier(false);

  @override
  void initState() {
    enableWakelock();
    updateIsLikeVal();
    AppState.instance.currentPlayingSongIndex.addListener(indexValListener);
    loadPlayList();
    super.initState();
  }

  void loadPlayList() {
    context.read<SongPlayerCubit>().loadPlaylist(widget.songEntityList);
  }

  @override
  void dispose() {
    disableWakelock();
    AppState.instance.currentPlayingSongIndex.removeListener(indexValListener);
    isLikedSong.dispose();
    super.dispose();
  }

  void indexValListener() {
    updateIsLikeVal();
  }

  void updateIsLikeVal() {
    isLikedSong.value = AppState.instance.likedSongs.contains(widget
        .songEntityList[AppState.instance.currentPlayingSongIndex.value].id);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await context.read<SongPlayerCubit>().audioPlayer.stop();
        if (context.mounted) context.pop();
      },
      child: BlocListener<FavoriteSongsCubit, FavoriteSongsState>(
        listener: (context, state) {
          if (state is AddToFavoriteSongsLoading ||
              state is RemoveFavoriteSongsLoading) {
            CustomLoader.showLoader(context);
          } else if (state is AddToFavoriteSongsSuccess ||
              state is RemoveFavoriteSongsSuccess) {
            updateIsLikeVal();
            CustomLoader.hideLoader(context);
          } else if (state is AddToFavoriteSongsFailure) {
            CustomLoader.hideLoader(context);
            ToastUtils.showFailed(message: state.error);
          } else if (state is RemoveFavoriteSongsFailure) {
            CustomLoader.hideLoader(context);
            ToastUtils.showFailed(message: state.error);
          }
        },
        child: Scaffold(
          appBar: BasicAppbar(
            title: const Text(
              'Now playing',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              ValueListenableBuilder(
                valueListenable: isLikedSong,
                builder: (context, isLikedVal, child) => IconButton(
                  onPressed: () {
                    showMenu(
                      color: context.isDarkMode
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      context: context,
                      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                      items: [
                        PopupMenuItem(
                          value: 'like',
                          onTap: () {
                            isLikedVal
                                ? context
                                    .read<FavoriteSongsCubit>()
                                    .removeSongFromFavorites(
                                        userId: AppState.instance.userId,
                                        songId: widget
                                            .songEntityList[AppState.instance
                                                .currentPlayingSongIndex.value]
                                            .id)
                                : context
                                    .read<FavoriteSongsCubit>()
                                    .addSongToFavorites(
                                        userId: AppState.instance.userId,
                                        songId: widget
                                            .songEntityList[AppState.instance
                                                .currentPlayingSongIndex.value]
                                            .id);
                          },
                          child: ListTile(
                            leading: Icon(isLikedVal
                                ? Icons.thumb_up_alt
                                : Icons.thumb_up_alt_outlined),
                            title: Text(isLikedVal
                                ? 'Remove from liked songs'
                                : 'Add to liked songs'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'exit',
                          onTap: () {
                            context.pop();
                          },
                          child: const ListTile(
                            leading: Icon(Icons.exit_to_app),
                            title: Text('Exit'),
                          ),
                        ),
                      ],
                    );
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Builder(builder: (context) {
              return Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: AppState.instance.currentPlayingSongIndex,
                    builder: (context, value, child) => SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: widget.songEntityList[value].coverImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: SpotifyLoader()),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: AppState.instance.currentPlayingSongIndex,
                    builder: (context, value, child) => Text(
                      widget.songEntityList[value].name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ValueListenableBuilder(
                    valueListenable: AppState.instance.currentPlayingSongIndex,
                    builder: (context, value, child) => Text(
                      widget.songEntityList[value].artists.first,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ValueListenableBuilder(
                    valueListenable: isLikedSong,
                    builder: (context, isLikedVal, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isLikedVal
                                ? context
                                    .read<FavoriteSongsCubit>()
                                    .removeSongFromFavorites(
                                        userId: AppState.instance.userId,
                                        songId: widget
                                            .songEntityList[AppState.instance
                                                .currentPlayingSongIndex.value]
                                            .id)
                                : context
                                    .read<FavoriteSongsCubit>()
                                    .addSongToFavorites(
                                        userId: AppState.instance.userId,
                                        songId: widget
                                            .songEntityList[AppState.instance
                                                .currentPlayingSongIndex.value]
                                            .id);
                          },
                          child: Icon(isLikedVal
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BlocBuilder<SongPlayerCubit, SongPlayerState>(
                    builder: (context, state) {
                      if (state is SongPlayerLoading) {
                        return const CircularProgressIndicator();
                      }
                      if (state is SongPlayerLoaded) {
                        return ValueListenableBuilder(
                          valueListenable:
                              context.read<SongPlayerCubit>().songPosition,
                          builder: (context, songPosition, child) => Column(
                            children: [
                              Slider(
                                  activeColor: AppColors.primary,
                                  inactiveColor: AppColors.grey,
                                  thumbColor: AppColors.primary,
                                  value: songPosition.inSeconds.toDouble(),
                                  min: 0.0,
                                  max: context
                                      .read<SongPlayerCubit>()
                                      .songDuration
                                      .inSeconds
                                      .toDouble(),
                                  onChanged: (value) {
                                    int seekPosition = value.toInt();
                                    context
                                        .read<SongPlayerCubit>()
                                        .seekTo(seekPosition);
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatDuration(songPosition)),
                                  Text(formatDuration(context
                                      .read<SongPlayerCubit>()
                                      .songDuration))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<SongPlayerCubit>()
                                          .previousSong();
                                    },
                                    child: const SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Icon(
                                        Icons.arrow_left,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<SongPlayerCubit>()
                                          .playOrPauseSong();
                                    },
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: DecoratedBox(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary),
                                        child: Icon(
                                          context
                                                  .read<SongPlayerCubit>()
                                                  .audioPlayer
                                                  .playing
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: () {
                                      if (AppState.instance
                                              .currentPlayingSongIndex.value !=
                                          widget.songEntityList.length - 1) {
                                        context
                                            .read<SongPlayerCubit>()
                                            .nextSong();
                                      }
                                    },
                                    child: const SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Icon(
                                        Icons.arrow_right,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void enableWakelock() async {
    await WakelockPlus.enable();
  }

  void disableWakelock() async {
    await WakelockPlus.disable();
  }
}
