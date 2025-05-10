import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';

import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../configs/assets/app_images.dart';
import '../../../configs/assets/app_vectors.dart';
import '../../../configs/theme/app_colors.dart';
import '../../profile/bloc/favorite_songs_cubit.dart';
import '../bloc/new_songs_cubit.dart';
import '../widgets/news_songs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<FavoriteSongsCubit>().setLikedSongs();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: SvgPicture.asset(
                AppVectors.logo,
                height: 40,
                width: 40,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.people,
              label: 'My Friends',
              onTap: () => context.pushNamed(AppRoutes.myFriends),
              context: context,
            ),
            _buildDrawerItem(
              icon: Icons.add_reaction_rounded,
              label: 'Add Friends',
              onTap: () => context.pushNamed(AppRoutes.addFriends),
              context: context,
            ),
            _buildDrawerItem(
              icon: Icons.alternate_email,
              label: 'Friend Requests',
              onTap: () => context.pushNamed(AppRoutes.friendRequest),
              context: context,
            ),
            _buildDrawerItem(
              icon: Icons.upload,
              label: 'Upload Songs',
              onTap: () async {
                await context.pushNamed(AppRoutes.uploadSongs);
                if (context.mounted) {
                  context.read<NewSongsCubit>().getNewsSongs();
                }
              },
              context: context,
            ),
            _buildDrawerItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () => context.pushNamed(AppRoutes.profilePage),
              context: context,
            ),
          ],
        ),
      ),
      appBar: BasicAppbar(
        backgroundColor: AppColors.primary,
        hideBack: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.profilePage);
            },
            icon: Icon(
              Icons.person,
              color:
                  context.isDarkMode ? Colors.white : const Color(0xff2C2B2B),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(AppVectors.homeTopCard),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: Image.asset(AppImages.homeArtist),
                    ),
                  )
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: context.isDarkMode ? Colors.white : Colors.black,
              indicatorColor: AppColors.primary,
              dividerHeight: 0,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
              tabs: const [
                Text(
                  'New Songs',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  'Videos',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  'Artists',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: NewsSongs(),
                  ),
                  SpotifyLoader(),
                  SpotifyLoader(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: context.isDarkMode ? Colors.white : Colors.black),
      title: Text(
        label,
        style: TextStyle(
          color: context.isDarkMode ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
