import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/text_field/common_text_field.dart';
import 'package:spotify_clone/core/configs/constants/app_routes.dart';
import 'package:spotify_clone/core/modules/auth/bloc/signin/signin_cubit.dart';
import 'package:spotify_clone/core/modules/auth/bloc/signin/signin_state.dart';

import '../../../../common/utils/toast_utils.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../common/widgets/button/basic_app_button.dart';
import '../../../../common/widgets/loader/custom_loader.dart';
import '../../../configs/assets/app_vectors.dart';
import '../../../configs/theme/app_colors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInLoading) {
          CustomLoader.showLoader(context);
        } else if (state is SignInSuccess) {
          CustomLoader.hideLoader(context);
          ToastUtils.showSuccess(message: state.message);
          context.pushNamedAndRemoveUntil(AppRoutes.homePage);
        } else if (state is SignInFailure) {
          CustomLoader.hideLoader(context);
          ToastUtils.showFailed(message: state.error);
        }
      },
      child: Scaffold(
        appBar: BasicAppbar(
          title: SvgPicture.asset(
            AppVectors.logo,
            height: 40,
            width: 40,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              CommonTextField(
                controller: _email,
                hintText: 'Email',
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextField(
                controller: _password,
                hintText: 'Password',
              ),
              const SizedBox(
                height: 20,
              ),
              BasicAppButton(
                  onPressed: () async {
                    context
                        .read<SignInCubit>()
                        .signIn(email: _email.text, password: _password.text);
                  },
                  title: 'Sign In')
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not A Member? ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              TextButton(
                  onPressed: () {
                    context.pushReplacementNamed(AppRoutes.signupPage);
                  },
                  child: const Text('Register Now',
                      style: TextStyle(color: AppColors.blueText)))
            ],
          ),
        ),
      ),
    );
  }
}
