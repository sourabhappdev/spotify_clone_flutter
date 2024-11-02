import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';

import '../../../../common/services/app_state.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../configs/constants/app_routes.dart';
import '../bloc/profile_info_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileInfoCubit>().getProfileInfo(AppState.instance.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        backgroundColor: AppColors.primary,
        title: Text('Profile'),
      ),
      body: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
        builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return Container(
                alignment: Alignment.center, child: const SpotifyLoader());
          } else if (state is ProfileInfoSuccess) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? const Color(0xff2C2B2B)
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    state.profileInfoModel.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                              Text('Edit profile')
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(state.profileInfoModel.email),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          state.profileInfoModel.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FAVORITE SONGS',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.songPlayerPage,
                                  args: {
                                    'songEntity':
                                        state.profileInfoModel.likedSong,
                                    'index': index,
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        state
                                                            .profileInfoModel
                                                            .likedSong[index]
                                                            .coverImage),
                                              )),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.profileInfoModel
                                                .likedSong[index].name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            state.profileInfoModel
                                                .likedSong[index].artists.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11),
                                          ),
                                          Text(state.profileInfoModel
                                              .likedSong[index].duration
                                              .toString()
                                              .replaceAll('.', ':')),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.pink,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 20,
                              ),
                          itemCount: state.profileInfoModel.likedSong.length)
                    ],
                  ),
                )
              ],
            );
          } else if (state is ProfileInfoFailure) {
            return const Text('Please try again');
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
