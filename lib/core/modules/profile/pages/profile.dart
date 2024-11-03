import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/utils/toast_utils.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/core/modules/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify_clone/core/modules/profile/bloc/log_out_cubit.dart';
import 'package:spotify_clone/core/modules/profile/bloc/select_image_cubit.dart';
import 'package:spotify_clone/core/modules/profile/bloc/upload_profile_image_cubit.dart';

import '../../../../common/services/app_state.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../configs/constants/app_routes.dart';
import '../../choose_mode/bloc/theme_cubit.dart';
import '../bloc/profile_info_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ValueNotifier<bool> isImageSelected = ValueNotifier(false);

  @override
  void initState() {
    context.read<ProfileInfoCubit>().getProfileInfo(AppState.instance.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile'),
        action: IconButton(
          icon: Icon(
            context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: context.isDarkMode ? Colors.white : const Color(0xff2C2B2B),
          ),
          onPressed: () {
            context.isDarkMode
                ? context.read<ThemeCubit>().updateTheme(ThemeMode.light)
                : context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
          },
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<FavoriteSongsCubit, FavoriteSongsState>(
            listener: (context, state) {
              if (state is RemoveFavoriteSongsSuccess) {
                context
                    .read<ProfileInfoCubit>()
                    .getProfileInfo(AppState.instance.userId);
              }
            },
          ),
          BlocListener<SelectImageCubit, SelectImageState>(
            listener: (context, state) {
              if (state is SelectImageFailure) {
                ToastUtils.showFailed(message: state.error);
              } else if (state is SelectImageSuccess) {
                isImageSelected.value = true;
              }
            },
          ),
          BlocListener<LogOutCubit, LogOutState>(
            listener: (context, state) {
              if (state is LogOutSuccess) {
                CustomLoader.hideLoader(context);
                context.pushNamedAndRemoveUntil(AppRoutes.signInPage);
              } else if (state is LogOutFailure) {
                CustomLoader.hideLoader(context);
                ToastUtils.showFailed(message: state.error);
              } else if (state is LogOutLoading) {
                CustomLoader.showLoader(context);
              }
            },
          ),
          BlocListener<UploadProfileImageCubit, UploadProfileImageState>(
            listener: (context, state) {
              if (state is UploadProfileImageSuccess) {
                CustomLoader.hideLoader(context);
                ToastUtils.showSuccess(message: state.message);
                isImageSelected.value = false;
                context
                    .read<ProfileInfoCubit>()
                    .getProfileInfo(AppState.instance.userId);
              } else if (state is UploadProfileImageFailure) {
                CustomLoader.hideLoader(context);
                ToastUtils.showFailed(message: state.error);
              } else if (state is UploadProfileImageLoading) {
                CustomLoader.showLoader(context);
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoSuccess) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.8,
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
                          ValueListenableBuilder(
                            valueListenable: isImageSelected,
                            builder: (context, value, child) => value
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showImagePickerOptions(context);
                                        },
                                        child: SizedBox(
                                          height: 90,
                                          width: 90,
                                          child: DecoratedBox(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle),
                                            child: ClipOval(
                                              child: Image.file(
                                                File(context
                                                    .read<SelectImageCubit>()
                                                    .image),
                                                fit: BoxFit.cover,
                                                height: 90,
                                                width: 90,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<UploadProfileImageCubit>()
                                              .uploadImage(context
                                                  .read<SelectImageCubit>()
                                                  .image);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.upload,
                                                color: context.isDarkMode
                                                    ? Colors.white
                                                    : const Color(0xff2C2B2B),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Upload',
                                                style: TextStyle(
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                      : const Color(0xff2C2B2B),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
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
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          _showImagePickerOptions(context);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: context.isDarkMode
                                                    ? Colors.white
                                                    : const Color(0xff2C2B2B),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Edit profile',
                                                style: TextStyle(
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                      : const Color(0xff2C2B2B),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<LogOutCubit>()
                                  .logout(AppState.instance.sessionId);
                            },
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : const Color(0xff2C2B2B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Log out',
                                    style: TextStyle(
                                      color: context.isDarkMode
                                          ? Colors.white
                                          : const Color(0xff2C2B2B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
                                              state
                                                  .profileInfoModel
                                                  .likedSong[index]
                                                  .artists
                                                  .first,
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
                                      onPressed: () {
                                        context
                                            .read<FavoriteSongsCubit>()
                                            .removeSongFromFavorites(
                                                songId: state.profileInfoModel
                                                    .likedSong[index].id,
                                                userId:
                                                    AppState.instance.userId);
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 20,
                                ),
                            itemCount: state.profileInfoModel.likedSong.length)
                      ],
                    ),
                  )
                ],
              );
            } else if (state is ProfileInfoFailure) {
              return const Center(child: Text('Please try again'));
            }
            return const SpotifyLoader();
          },
        ),
      ),
    );
  }
}

extension _HelperMehtod on _ProfilePageState {
  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Wrap(
            runSpacing: 10, // Space between ListTiles
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading:
                      const Icon(Icons.photo_library, color: AppColors.primary),
                  title: const Text(
                    'Pick from Gallery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    context
                        .read<SelectImageCubit>()
                        .selectImage(ImageSource.gallery);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading:
                      const Icon(Icons.camera_alt, color: AppColors.primary),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    context
                        .read<SelectImageCubit>()
                        .selectImage(ImageSource.camera);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
