import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/modules/auth/Models/song_model.dart';

import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../configs/theme/app_colors.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';

class SongPlayerPage extends StatefulWidget {
  final List<SongModel> songEntityList;
  final int index;

  const SongPlayerPage(
      {required this.songEntityList, super.key, required this.index});

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  late ValueNotifier<int> index;

  @override
  void initState() {
    index = ValueNotifier(widget.index);
    final List<String> urls =
        widget.songEntityList.map((song) => song.url).toList();
    context.read<SongPlayerCubit>().loadPlaylist(urls, widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Now playing',
          style: TextStyle(fontSize: 18),
        ),
        action: IconButton(
            onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Builder(builder: (context) {
          return Column(
            children: [
              ValueListenableBuilder(
                valueListenable: index,
                builder: (context, value, child) => SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: widget.songEntityList[index.value].coverImage,
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
                valueListenable: index,
                builder: (context, value, child) => Text(
                  widget.songEntityList[index.value].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ValueListenableBuilder(
                valueListenable: index,
                builder: (context, value, child) => Text(
                  widget.songEntityList[index.value].artists.first,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.thumb_up_alt_outlined),
                  ),
                ],
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
                    return Column(
                      children: [
                        Slider(
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.grey,
                            thumbColor: AppColors.primary,
                            value: context
                                .read<SongPlayerCubit>()
                                .songPosition
                                .inSeconds
                                .toDouble(),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(
                                context.read<SongPlayerCubit>().songPosition)),
                            Text(formatDuration(
                                context.read<SongPlayerCubit>().songDuration))
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
                                context.read<SongPlayerCubit>().previousSong();
                                if (index.value != 0) {
                                  index.value--;
                                }
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
                                if (index.value !=
                                    widget.songEntityList.length - 1) {
                                  context.read<SongPlayerCubit>().nextSong();
                                  index.value++;
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
                    );
                  }

                  return const SizedBox.shrink();
                },
              )
            ],
          );
        }),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
