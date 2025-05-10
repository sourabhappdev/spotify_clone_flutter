import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/core/modules/friend/bloc/add_friend/add_friend_cubit.dart';

import '../../../common/utils/toast_utils.dart';
import 'bloc/search_friends/search_friend_cubit.dart';

// Custom SearchField widget
class SearchField extends StatelessWidget {
  final Function(String) onChanged;

  const SearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search for friends...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        suffixIcon: const Icon(Icons.search),
      ),
    );
  }
}

// The main AddFriendsScreen widget
class AddFriendsScreen extends StatelessWidget {
  const AddFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        backgroundColor: AppColors.primary,
        title: Text('Add Friends'),
      ),
      body: MultiBlocListener(
  listeners: [
    BlocListener<AddFriendCubit, AddFriendState>(
      listener: (context, state) {
        if (state is AddFriendSuccess) {
          CustomLoader.hideLoader(context);
          ToastUtils.showSuccess(message: state.msg);
        } else if (state is AddFriendFailure) {
          CustomLoader.hideLoader(context);
          ToastUtils.showFailed(message: state.msg);
        } else if (state is AddFriendLoading) {
          CustomLoader.showLoader(context);
        }
      },
    ),
  ],
  child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              onChanged: (query) {
                context.read<SearchFriendCubit>().searchFriends(query);
              },
            ),
            const SizedBox(height: 20),

            // BlocBuilder listens to the SearchFriendCubit state and builds UI accordingly
            BlocBuilder<SearchFriendCubit, SearchFriendState>(
              builder: (context, state) {
                if(state is SearchFriendLoading){
                  return const SpotifyLoader();
                }
                else if (state is SearchFriendInitial) {
                  return const Center(
                      child: Text('Start searching for friends.'));
                } else if (state is SearchFriendLoaded) {
                  final friends = state.searchResults;
                  if (friends.isEmpty) {
                    return const Center(child: Text('No friends found.'));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];

                        return ListTile(
                          tileColor: AppColors.darkGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              imageUrl: friend.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                      strokeWidth: 2),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              Text(friend.name,style: TextStyle(color: context.isDarkMode ?  Colors.black:AppColors.lightBackground),),
                              Row(
                                spacing: 8,
                                children: [
                                   Icon(Icons.music_note,size: 18,color: context.isDarkMode ?  Colors.black:AppColors.lightBackground),
                                  Text(friend.likedSong.length.toString(),style: TextStyle(color: context.isDarkMode ?  Colors.black:AppColors.lightBackground),),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon:  Icon(Icons.add_reaction_rounded,color: context.isDarkMode ?  Colors.black:AppColors.lightBackground),
                            onPressed: () {
                              context.read<AddFriendCubit>().addFriend(receiverId: friend.id);
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Error fetching data.'));
                }
              },
            ),
          ],
        ),
      ),
),
    );
  }
}
