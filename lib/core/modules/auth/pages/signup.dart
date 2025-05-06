import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/utils/toast_utils.dart';
import 'package:spotify_clone/common/widgets/loader/custom_loader.dart';
import 'package:spotify_clone/common/widgets/text_field/common_text_field.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/core/modules/auth/bloc/signup/sign_up_cubit.dart';

import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../common/widgets/button/basic_app_button.dart';
import '../../../configs/assets/app_vectors.dart';
import '../../../configs/constants/app_routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final ValueNotifier<bool> isObscure = ValueNotifier(true);
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _fullName.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          CustomLoader.showLoader(context);
        } else if (state is SignUpSuccess) {
          CustomLoader.hideLoader(context);
          ToastUtils.showSuccess(message: state.message);
          context.pushNamedAndRemoveUntil(AppRoutes.homePage);
        } else if (state is SignUpFailure) {
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                CommonTextFormField(
                  controller: _fullName,
                  hintText: 'Full name',
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTextFormField(
                  isEmail: true,
                  controller: _email,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTextFormField(
                  controller: _password,
                  hintText: 'Password',
                  isPassword: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                BasicAppButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<SignUpCubit>().createAccount(
                          email: _email.text,
                          password: _password.text,
                          name: _fullName.text);
                    },
                    title: 'Create Account')
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Do you have an account? ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              TextButton(
                  onPressed: () {
                    context.pushReplacementNamed(AppRoutes.signInPage);
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: AppColors.blueText),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
