import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'bloc/friend_request/friend_request_cubit.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  @override
  void initState() {
    context.read<FriendRequestsCubit>().fetchRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Friend Requests'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<FriendRequestsCubit, FriendRequestsState>(
        builder: (context, state) {
          if (state is FriendRequestsLoading) {
            return const Center(child: SpotifyLoader());
          } else if (state is FriendRequestsLoaded) {
            if (state.requests.isEmpty) {
              return const Center(child: Text('No friend requests'));
            }

            return ListView.builder(
              itemCount: state.requests.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
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
                          imageUrl: request.senderPhotoUrl,
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
                    children: [
                      Text(
                        request.senderName,
                        style: const TextStyle(
                          color: AppColors.lightBackground,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy hh:mm a')
                            .format(request.timeStamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightBackground,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          context.read<FriendRequestsCubit>().respondToRequest(
                                request.docId,
                                RequestStatus.confirmed,
                                request.senderId,
                              );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context.read<FriendRequestsCubit>().respondToRequest(
                                request.docId,
                                RequestStatus.rejected,
                                request.senderId,
                              );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is FriendRequestsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
