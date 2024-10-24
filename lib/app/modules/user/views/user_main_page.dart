// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:antarkanma/app/modules/user/views/chat_page.dart';
import 'package:antarkanma/app/modules/user/views/home_page.dart';
import 'package:antarkanma/app/modules/user/views/order_page.dart';
import 'package:antarkanma/app/modules/user/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:antarkanma/theme.dart';

class UserMainPage extends StatefulWidget {
  UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Fungsi untuk menentukan konten yang ditampilkan berdasarkan indeks saat ini
    Widget body() {
      switch (currentIndex) {
        case 0:
          return HomePage();
        case 1:
          return ChatPage();
        case 2:
          return OrderPage();
        case 3:
          return ProfilePage();
        default:
          return HomePage();
      }
    }

    // Fungsi untuk membuat item navigasi
    BottomNavigationBarItem createNavItem(
        String assetPath, String label, int index) {
      return BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(top: Dimenssions.height10),
          child: Image.asset(
            color:
                currentIndex == index ? logoColorSecondary : secondaryTextColor,
            assetPath,
            width: Dimenssions.height22,
          ),
        ),
        label: label,
      );
    }

    // Widget untuk navigasi bawah
    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimenssions.radius20),
        ),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: backgroundColor6,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]),
          child: BottomNavigationBar(
            selectedItemColor: logoColorSecondary,
            unselectedItemColor: secondaryTextColor,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: backgroundColor2,
            items: [
              createNavItem('assets/icon_home.png', 'Home', 0),
              createNavItem('assets/icon_cart.png', 'Keranjang', 1),
              createNavItem('assets/list.png', 'Pesanan', 2),
              createNavItem('assets/icon_profile.png', 'Profile', 3),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}
