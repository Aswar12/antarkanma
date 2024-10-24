import 'package:antarkanma/app/controllers/auth_controller.dart';
import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    Widget header() {
      return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.all(Dimenssions.width30),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/image_profile.png',
                    width: Dimenssions.width60,
                  ),
                ),
                SizedBox(
                  width: Dimenssions.width15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aswar Sumarlin',
                        style: primaryTextStyle.copyWith(
                          fontSize: Dimenssions.font24,
                          fontWeight: medium,
                        ),
                      ),
                      Text(
                        '087886576650',
                        style: subtitleTextStyle.copyWith(
                          fontSize: Dimenssions.font16,
                        ),
                      )
                    ],
                  ),
                ),
                Image.asset(
                  'assets/button_exit.png',
                  width: Dimenssions.height25,
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget menuItem(String text) {
      return Container(
        margin: EdgeInsets.only(top: Dimenssions.height20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: secondaryTextStyle.copyWith(
                fontSize: Dimenssions.font16,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: logoColorSecondary,
              size: Dimenssions.font20,
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimenssions.width30,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dimenssions.height25,
              ),
              Text(
                'Akun',
                style: primaryTextStyle.copyWith(
                  fontSize: Dimenssions.font18,
                  fontWeight: semiBold,
                ),
              ),
              menuItem('Edit Profil'),
              menuItem('Orderan Kamu'),
              menuItem('Bantuan'),
              SizedBox(
                height: Dimenssions.height30,
              ),
              Text(
                'Umum',
                style: primaryTextStyle.copyWith(
                  fontSize: Dimenssions.font18,
                  fontWeight: semiBold,
                ),
              ),
              menuItem('Kebijakan & Privasi'),
              menuItem('Ketentuan Layanan'),
              menuItem('Rating Aplikasi'),
              Spacer(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: Dimenssions.height30),
                child: ElevatedButton(
                  onPressed: () => authController.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        EdgeInsets.symmetric(vertical: Dimenssions.height15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimenssions.radius15),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: primaryTextStyle.copyWith(
                      fontSize: Dimenssions.font16,
                      fontWeight: medium,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}
