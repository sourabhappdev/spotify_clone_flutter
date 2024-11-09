import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';
import 'package:spotify_clone/core/modules/home/bloc/new_songs_state.dart';

import '../../../configs/theme/app_colors.dart';
import '../bloc/new_songs_cubit.dart';

class NewsSongs extends StatefulWidget {
  const NewsSongs({super.key});

  @override
  State<NewsSongs> createState() => _NewsSongsState();
}

class _NewsSongsState extends State<NewsSongs> {
  @override
  void initState() {
    context.read<NewSongsCubit>().getNewsSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: BlocBuilder<NewSongsCubit, NewSongsState>(
          builder: (context, state) {
            if (state is NewSongsLoading) {
              return const SpotifyLoader();
            }
            if (state is NewSongsSuccess) {
              return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        AppState.instance.currentPlayingSongIndex.value = index;
                        context.pushNamed(
                          AppRoutes.songPlayerPage,
                          args: {
                            'songEntity': state.songs,
                          },
                        );
                      },
                      child: SizedBox(
                        width: 170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      state.songs[index].coverImage),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  transform:
                                      Matrix4.translationValues(10, 10, 0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: context.isDarkMode
                                          ? AppColors.darkGrey
                                          : const Color(0xffE6E6E6)),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: context.isDarkMode
                                        ? const Color(0xff959595)
                                        : const Color(0xff555555),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              state.songs[index].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              state.songs[index].artists.isNotEmpty
                                  ? state.songs[index].artists.first
                                  : '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 14,
                      ),
                  itemCount: state.songs.length);
            }

            return const SizedBox.shrink();
          },
        ));
  }
}
