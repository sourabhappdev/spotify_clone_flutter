import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';

import '../../../../common/widgets/button/basic_app_button.dart';
import '../../../configs/assets/app_images.dart';
import '../../../configs/assets/app_vectors.dart';
import '../../../configs/constants/app_routes.dart';
import '../../../configs/theme/app_colors.dart';
import '../bloc/theme_cubit.dart';

class ChooseModePage extends StatefulWidget {
  const ChooseModePage({super.key});

  @override
  State<ChooseModePage> createState() => _ChooseModePageState();
}

class _ChooseModePageState extends State<ChooseModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      AppImages.chooseModeBG,
                    ))),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                const Spacer(),
                const Text(
                  'Choose Mode',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: context.isDarkMode
                                    ? Border.all(color: Colors.white)
                                    : null,
                                shape: BoxShape.circle,
                                color: AppColors.darkGrey.withOpacity(0.5),
                              ),
                              child: SvgPicture.asset(
                                AppVectors.moon,
                                fit: BoxFit.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Dark Mode',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () {
                        context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: context.isDarkMode
                                    ? null
                                    : Border.all(color: Colors.white),
                                shape: BoxShape.circle,
                                color: AppColors.darkGrey.withOpacity(0.5),
                              ),
                              child: SvgPicture.asset(
                                AppVectors.sun,
                                fit: BoxFit.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Light Mode',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                BasicAppButton(
                    onPressed: () {
                      context.pushNamed(AppRoutes.chooseSignInSignUpPage);
                    },
                    title: 'Continue')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
