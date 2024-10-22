// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:antarkanma/pages/Home/chat_page.dart';
import 'package:antarkanma/pages/Home/home_page.dart';
import 'package:antarkanma/pages/Home/order_page.dart';
import 'package:antarkanma/pages/Home/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:antarkanma/theme.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget cardButton() {
      return FloatingActionButton(
        backgroundColor: logoColorSecondary,
        onPressed: () {},
        child: Image.asset(
          'assets/icon_cart.png',
          width: Dimenssions.height25,
        ),
      );
    }

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
              print(value);
              setState(() {
                currentIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: backgroundColor2,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: Dimenssions.height10),
                  child: Image.asset(
                    color: currentIndex == 0
                        ? logoColorSecondary
                        : secondaryTextColor,
                    'assets/icon_home.png',
                    width: Dimenssions.height22,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: Dimenssions.height10),
                  child: Image.asset(
                    color: currentIndex == 1
                        ? logoColorSecondary
                        : secondaryTextColor,
                    'assets/icon_cart.png',
                    width: Dimenssions.height22,
                  ),
                ),
                label: 'Keranjang',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: Dimenssions.height10),
                  child: Image.asset(
                    color: currentIndex == 2
                        ? logoColorSecondary
                        : secondaryTextColor,
                    'assets/list.png',
                    width: Dimenssions.height22,
                  ),
                ),
                label: 'Pesanan',
              ),
              // BottomNavigationBarItem(
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: Dimenssions.height10),
                  child: Image.asset(
                    color: currentIndex == 3
                        ? logoColorSecondary
                        : secondaryTextColor,
                    'assets/icon_profile.png',
                    width: Dimenssions.height22,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      bottomNavigationBar: customBottomNav(),
      // floatingActionButton: cardButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: body(),
    );
  }
}
