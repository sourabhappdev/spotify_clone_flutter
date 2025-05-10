import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';

import '../../../common/services/app_state.dart';
import '../../../common/utils/toast_utils.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/loader/custom_loader.dart';
import '../../configs/constants/app_routes.dart';
import '../../configs/theme/app_colors.dart';
import '../profile/bloc/favorite_songs_cubit.dart';
import '../profile/models/profile_info_model.dart';

class FriendsProfile extends StatefulWidget {
  final ProfileInfoModel profileInfoModel;

  const FriendsProfile({super.key, required this.profileInfoModel});

  @override
  State<FriendsProfile> createState() => _FriendsProfileState();
}

class _FriendsProfileState extends State<FriendsProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        backgroundColor: AppColors.primary,
        title: Text('${widget.profileInfoModel.name} Profile'),
      ),
      body: BlocListener<FavoriteSongsCubit, FavoriteSongsState>(
        listener: (context, state) {
          if (state is AddToFavoriteSongsLoading ||
              state is RemoveFavoriteSongsLoading) {
            CustomLoader.showLoader(context);
          } else if (state is AddToFavoriteSongsSuccess ||
              state is RemoveFavoriteSongsSuccess) {
            CustomLoader.hideLoader(context);
            setState(() {});
          } else if (state is AddToFavoriteSongsFailure) {
            CustomLoader.hideLoader(context);
            ToastUtils.showFailed(message: state.error);
          } else if (state is RemoveFavoriteSongsFailure) {
            CustomLoader.hideLoader(context);
            ToastUtils.showFailed(message: state.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Favorite songs'),
              const SizedBox(height: 20),
              if (widget.profileInfoModel.likedSong.isEmpty)
                const Center(child: Text('No liked songs')),
              if (widget.profileInfoModel.likedSong.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.profileInfoModel.likedSong.length,
                    itemBuilder: (context, index) {
                      final song = widget.profileInfoModel.likedSong[index];
                      return GestureDetector(
                        key: ValueKey(song.id),
                        onTap: () {
                          AppState.instance.currentPlayingSongIndex.value =
                              index;
                          context.pushNamed(
                            AppRoutes.songPlayerPage,
                            args: {
                              'songEntity': widget.profileInfoModel.likedSong,
                              'index': index,
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: song.coverImage,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      song.artists.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11),
                                    ),
                                    Text(
                                      song.duration
                                          .toString()
                                          .replaceAll('.', ':'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                AppState.instance.likedSongs.contains(song.id)
                                    ? context
                                        .read<FavoriteSongsCubit>()
                                        .removeSongFromFavorites(
                                          songId: song.id,
                                          userId: AppState.instance.userId,
                                        )
                                    : context
                                        .read<FavoriteSongsCubit>()
                                        .addSongToFavorites(
                                          songId: song.id,
                                          userId: AppState.instance.userId,
                                        );
                              },
                              icon: Icon(
                                AppState.instance.likedSongs.contains(song.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: AppState.instance.likedSongs
                                        .contains(song.id)
                                    ? Colors.pink
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
