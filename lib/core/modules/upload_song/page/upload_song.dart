import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/text_field/common_text_field.dart';
import 'package:spotify_clone/core/modules/upload_song/blocs/upload_song_state.dart';
import 'dart:io';

import '../../../../common/utils/toast_utils.dart';
import '../../../../common/widgets/loader/custom_loader.dart';
import '../blocs/upload_song_cubit.dart';
import '../../../configs/theme/app_colors.dart';

class UploadSongPage extends StatefulWidget {
  const UploadSongPage({super.key});

  @override
  State<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends State<UploadSongPage> {
  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _songDurationController = TextEditingController();
  File? _songFile;
  File? _coverImageFile;

  final List<String> _artists = [];

  @override
  void dispose() {
    _songNameController.dispose();
    _artistController.dispose();
    _songDurationController.dispose();
    super.dispose();
  }

  // Method to add artist to the list
  void _addArtist() {
    if (_artistController.text.isNotEmpty) {
      setState(() {
        _artists.add(_artistController.text);
        _artistController.clear(); // Clear the artist text field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        backgroundColor: AppColors.primary,
        title: Text("Upload Song"),
      ),
      body: BlocListener<UploadSongCubit, UploadSongState>(
        listener: (context, state) {
          if (state is UploadSongLoading) {
            CustomLoader.showLoader(context);
          } else if (state is UploadSongSuccess) {
            CustomLoader.hideLoader(context);
            ToastUtils.showSuccess(message: "Song uploaded successfully!");
            Navigator.pop(context);
          } else if (state is UploadSongFailure) {
            CustomLoader.hideLoader(context);
            ToastUtils.showFailed(message: state.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CommonTextField(
                controller: _songNameController,
                hintText: "Song name",
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                children: _artists
                    .map((artist) => Chip(
                          color:
                              const WidgetStatePropertyAll(AppColors.primary),
                          deleteIconColor: Colors.white,
                          label: Text(
                            artist,
                            style: TextStyle(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onDeleted: () {
                            setState(() {
                              _artists.remove(artist);
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              CommonTextField(
                controller: _artistController,
                hintText: "Artist",
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _addArtist,
                child: Container(
                  width: 200,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: context.isDarkMode
                            ? Colors.white
                            : const Color(0xff2C2B2B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Artist',
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
              const SizedBox(height: 10),
              CommonTextField(
                controller: _songDurationController,
                hintText: "Duration",
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  File? songFile =
                      await context.read<UploadSongCubit>().pickMP3File();
                  _songFile = songFile;
                },
                child: Container(
                  width: 200,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.audiotrack,
                        color: context.isDarkMode
                            ? Colors.white
                            : const Color(0xff2C2B2B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pick Song (MP3)',
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  File? coverImageFile =
                      await context.read<UploadSongCubit>().pickCoverImage();
                  _coverImageFile = coverImageFile;
                },
                child: Container(
                  width: 200,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: context.isDarkMode
                            ? Colors.white
                            : const Color(0xff2C2B2B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pick Cover Image',
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (_songFile != null &&
                      _coverImageFile != null &&
                      _artists.isNotEmpty) {
                    context.read<UploadSongCubit>().uploadSong(
                          songName: _songNameController.text,
                          artists: _artists,
                          songFile: _songFile!,
                          coverImage: _coverImageFile!,
                          duration: _songDurationController
                              .text, // Placeholder duration
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please select song, cover image, and at least one artist')),
                    );
                  }
                },
                child: Container(
                  width: 200,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload,
                        color: context.isDarkMode
                            ? Colors.white
                            : const Color(0xff2C2B2B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Upload Song',
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
      ),
    );
  }
}
