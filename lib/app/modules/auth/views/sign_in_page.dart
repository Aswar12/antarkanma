import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../constants/app_values.dart';
import '../../../widgets/custom_input_field.dart';

class SignInPage extends GetView<AuthController> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor3,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(Dimenssions.height15),
        child: SafeArea(
          child: Form(
            key: _signInFormKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                children: [
                  header(),
                  emailInput(),
                  SizedBox(height: Dimenssions.height15),
                  passwordInput(),
                  signButton(),
                  const Spacer(),
                  footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      margin: const EdgeInsets.only(
          top: AppValues.height10, left: AppValues.height10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Login',
              style:
                  primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
            ),
          ),
          const SizedBox(height: 2),
          const Text('Masuk Untuk lanjut'),
        ],
      ),
    );
  }

  // Di dalam class SignInPage

  Widget emailInput() {
    return CustomInputField(
      label: 'Email atau WhatsApp',
      hintText: 'Masukkan Email atau Nomor WA',
      controller: controller.identifierController,
      validator: controller.validateIdentifier,
      iconPath: 'assets/icon_email.png',
    );
  }

  Widget passwordInput() {
    return CustomInputField(
      label: 'Password',
      hintText: 'Masukkan Password Kamu',
      controller: controller.passwordController,
      validator: controller.validatePassword,
      initialObscureText: true,
      iconPath: 'assets/icon_password.png',
      showVisibilityToggle: true,
    );
  }

  Widget signButton() {
    return Container(
      height: AppValues.height50,
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: AppValues.height30,
        left: AppValues.height10,
        right: AppValues.height10,
      ),
      child: Obx(
        () => TextButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (_signInFormKey.currentState!.validate()) {
                    controller.login();
                  }
                },
          style: TextButton.styleFrom(
            backgroundColor: logoColorSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppValues.radius15),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  'Login',
                  style: primaryTextStyle.copyWith(
                    fontSize: AppValues.font16,
                    fontWeight: medium,
                  ),
                ),
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.height30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum Punya Akun? ',
            style: subtitleTextStyle.copyWith(
              fontSize: AppValues.font14,
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed('/register'),
            child: Text(
              'Daftar',
              style: primaryTextOrange.copyWith(
                fontSize: AppValues.font14,
                fontWeight: medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
