import 'package:flutter/material.dart';
import 'package:antarkanma/theme.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: Dimenssions.height10,
          left: Dimenssions.height10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Daftar Akun',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: semiBold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text('Masukkan Data Anda', style: subtitleTextStyle)
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        margin: const EdgeInsets.only(top: 70, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Lengkap',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: Dimenssions.width50,
              padding: EdgeInsets.symmetric(
                horizontal: Dimenssions.radius15,
              ),
              decoration: BoxDecoration(
                color: backgroundColor2,
                borderRadius: BorderRadius.circular(Dimenssions.radius15),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      color: logoColorSecondary,
                      'assets/icon_name.png',
                      width: Dimenssions.width15,
                    ),
                    SizedBox(width: Dimenssions.width15),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Nama Lengkap Kamu',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 35, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alamat Email',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: Dimenssions.width50,
              padding: EdgeInsets.symmetric(
                horizontal: Dimenssions.radius15,
              ),
              decoration: BoxDecoration(
                color: backgroundColor2,
                borderRadius: BorderRadius.circular(Dimenssions.radius15),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      color: logoColorSecondary,
                      'assets/icon_email.png',
                      width: Dimenssions.width15,
                    ),
                    SizedBox(width: Dimenssions.width15),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Alamat Email Kamu',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget phoneInput() {
      return Container(
        margin: const EdgeInsets.only(top: 35, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Telepon/Wa ',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: Dimenssions.width50,
              padding: EdgeInsets.symmetric(
                horizontal: Dimenssions.radius15,
              ),
              decoration: BoxDecoration(
                color: backgroundColor2,
                borderRadius: BorderRadius.circular(Dimenssions.radius15),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      color: logoColorSecondary,
                      'assets/phone_icon.png',
                      width: 15,
                    ),
                    SizedBox(width: Dimenssions.width15),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Nomor Telepon/Wa Kamu',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: const EdgeInsets.only(top: 35, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: Dimenssions.width50,
              padding: EdgeInsets.symmetric(
                horizontal: Dimenssions.radius15,
              ),
              decoration: BoxDecoration(
                color: backgroundColor2,
                borderRadius: BorderRadius.circular(Dimenssions.radius15),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      color: logoColorSecondary,
                      'assets/icon_password.png',
                      width: Dimenssions.width15,
                    ),
                    SizedBox(width: Dimenssions.width15),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Password Kamu',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget signButton() {
      return Container(
        height: Dimenssions.height50,
        width: double.infinity,
        margin: EdgeInsets.only(
          top: Dimenssions.height30,
          left: Dimenssions.height10,
          right: Dimenssions.height10,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          style: TextButton.styleFrom(
              backgroundColor: logoColorSecondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimenssions.radius15))),
          child: Text('Daftar',
              style: primaryTextStyle.copyWith(
                fontSize: Dimenssions.font16,
                fontWeight: medium,
              )),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(bottom: Dimenssions.height30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum Punya Akun ? ',
              style: subtitleTextStyle.copyWith(
                fontSize: Dimenssions.font14,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sign-in');
              },
              child: Text('Daftar',
                  style: primaryTextOrange.copyWith(
                    fontSize: Dimenssions.font14,
                    fontWeight: medium,
                  )),
            )
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: backgroundColor3,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              child: Column(
                children: [
                  header(),
                  nameInput(),
                  emailInput(),
                  phoneInput(),
                  passwordInput(),
                  signButton(),
                  const Spacer(),
                  footer(),
                ],
              )),
        ));
  }
}
