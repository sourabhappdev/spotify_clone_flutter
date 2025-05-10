import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import 'bloc/my_friends/my_friends_cubit.dart';

class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({super.key});

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {
  @override
  void initState() {
    context.read<MyFriendsCubit>().fetchConfirmedFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('My Friends'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<MyFriendsCubit, MyFriendsState>(
        builder: (context, state) {
          if (state is MyFriendsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyFriendsLoaded) {
            if (state.friends.isEmpty) {
              return const Center(child: Text("No confirmed friends yet."));
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.friends.length,
              itemBuilder: (context, index) {
                final friend = state.friends[index];
                return ListTile(
                  onTap: () {
                    context.pushNamed(AppRoutes.friendsProfile, args: {
                      'profileInfoModel': friend,
                    });
                  },
                  key: ValueKey(friend.hashCode),
                  tileColor: AppColors.darkGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.lightBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: friend.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        friend.name,
                        style:
                            const TextStyle(color: AppColors.lightBackground),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.music_note,
                              size: 18, color: AppColors.lightBackground),
                          Text(
                            friend.likedSong.length.toString(),
                            style: const TextStyle(
                                color: AppColors.lightBackground),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.menu,
                        color: AppColors.lightBackground),
                    onPressed: () {},
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {},
            );
          } else if (state is MyFriendsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
