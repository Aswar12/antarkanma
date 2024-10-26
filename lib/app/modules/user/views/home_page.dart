// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:antarkanma/app/widgets/product_tile.dart';
import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(viewportFraction: 0.85);
  double _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = Dimenssions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _currPageValue = pageController.page ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        header(),
        popularProductsTitle(),
        popularProducts(),
        listProductsTitle(),
        listProducts(),
      ],
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.only(
        top: Dimenssions.height25,
        left: Dimenssions.width20,
        right: Dimenssions.width25,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Container(
                height: Dimenssions.height40,
                decoration: BoxDecoration(
                  border: Border.all(color: backgroundColor6, width: 2),
                  borderRadius: BorderRadius.circular(Dimenssions.radius15),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10.0),
                    Icon(Icons.search_outlined, color: backgroundColor6),
                    SizedBox(width: Dimenssions.width10),
                    Text(
                      'Apa Ku AntarkanKi ?',
                      style: subtitleTextStyle.copyWith(
                        fontSize: Dimenssions.font14,
                        color: backgroundColor6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: Dimenssions.width55,
              height: Dimenssions.width55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/profil.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget popularProducts() {
    return Column(
      children: [
        SizedBox(
          height: Dimenssions.pageView,
          child: PageView.builder(
            itemCount: 4,
            controller: pageController,
            itemBuilder: (context, position) {
              return _buildPageItem(position);
            },
          ),
        ),
        SizedBox(height: Dimenssions.height5),
        SmoothPageIndicator(
          controller: pageController,
          count: 4,
          effect: const WormEffect(
            activeDotColor: Color(0xfffffff6600),
            dotHeight: 11,
            dotWidth: 11,
            type: WormType.thinUnderground,
          ),
        ),
      ],
    );
  }

  Widget popularProductsTitle() {
    return _buildTitle('Produk Populer');
  }

  Widget listProductsTitle() {
    return _buildTitle('Daftar Produk');
  }

  Widget _buildTitle(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: Dimenssions.height5,
          left: Dimenssions.height25,
          bottom: Dimenssions.height10,
        ),
        child: Text(
          title,
          style: primaryTextStyle.copyWith(
            fontSize: Dimenssions.font20,
            color: backgroundColor6,
          ),
        ),
      ),
    );
  }

  Widget listProducts() {
    return Container(
      margin: EdgeInsets.only(top: Dimenssions.height10),
      child: const Column(
        children: [
          ProductTile(
            imageUrl: 'assets/image_shoes2.png',
            name: 'Sepatu Lari Ultra Boost',
            price: 1899000,
            merchantName: 'Sports Gear Shop',
            distance: 2.5,
            duration: 32,
            rating: 4.5,
            reviews: 1299,
            onTap: null,
          ),
          ProductTile(
            imageUrl: 'assets/image_shoes.png',
            name: 'Sepatu Lari Ultra Boost',
            price: 1899000,
            merchantName: 'Sports Gear Shop',
            distance: 2.5,
            duration: 32,
            rating: 4.5,
            reviews: 1299,
            onTap: null,
          ),
          ProductTile(
            imageUrl: 'assets/image_shoes8.png',
            name: 'Sepatu Lari Ultra Boost',
            price: 1899000,
            merchantName: 'Sports Gear Shop',
            distance: 2.5,
            duration: 32,
            rating: 4.5,
            reviews: 1299,
            onTap: null,
          ),
          ProductTile(
            imageUrl: 'assets/image_shoes8.png',
            name: 'Sepatu Lari Ultra Boost',
            price: 1899000,
            merchantName: 'Sports Gear Shop',
            distance: 2.5,
            duration: 32,
            rating: 4.5,
            reviews: 1299,
            onTap: null,
          ),
          ProductTile(
            imageUrl: 'assets/image_shoes8.png',
            name: 'Sepatu Lari Ultra Boost',
            price: 1899000,
            merchantName: 'Sports Gear Shop',
            distance: 2.5,
            duration: 32,
            rating: 4.5,
            reviews: 1299,
            onTap: null,
          ),
          ProductTile(
            imageUrl: 'assets/image_shoes8.png',
            name: 'Sepatu Lari Ultra Boost',
            price: 1899000,
            merchantName: 'Sports Gear Shop',
            distance: 2.5,
            duration: 32,
            rating: 4.5,
            reviews: 1299,
            onTap: null,
          )
        ],
      ),
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return GestureDetector(
      onTap: () {
        // Navigator.push logic here
        print('Product $index tapped');
      },
      child: Transform(
        transform: matrix,
        child: Stack(
          children: [
            Container(
              height: Dimenssions.pageViewContainer,
              margin: EdgeInsets.symmetric(horizontal: Dimenssions.width10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimenssions.radius30),
                color: index.isEven
                    ? const Color(0xff69c5df)
                    : const Color(0xff9294cc),
                image: const DecorationImage(
                  image: AssetImage('assets/image_shoes.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimenssions.pageTextContainer,
                margin: EdgeInsets.symmetric(
                  horizontal: Dimenssions.width30,
                  vertical: Dimenssions.height10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimenssions.radius20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dimenssions.height15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sepatu Lari Ultra Boost',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: Dimenssions.font16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Dimenssions.height10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Rp 1.899.000',
                            style: TextStyle(
                              fontSize: Dimenssions.font14,
                              color: logoColorSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.store,
                                  color: Colors.blue,
                                  size: Dimenssions.iconSize16),
                              SizedBox(width: Dimenssions.width5),
                              Text(
                                'Sports Gear Shop',
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: Dimenssions.font12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: logoColorSecondary,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoItem(
                              Icons.location_on, '2.5 km', Colors.green),
                          _buildInfoItem(Icons.access_time_rounded, '32 menit',
                              Colors.red),
                          _buildRatingItem(4.5, 1299),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: Dimenssions.iconSize16),
        SizedBox(width: Dimenssions.width5),
        Text(
          text,
          style:
              TextStyle(color: primaryTextColor, fontSize: Dimenssions.font12),
        ),
      ],
    );
  }

  Widget _buildRatingItem(double rating, int reviews) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: Dimenssions.iconSize16),
        SizedBox(width: Dimenssions.width5),
        Text(
          '$rating (${reviews.toString()})',
          style:
              TextStyle(color: primaryTextColor, fontSize: Dimenssions.font12),
        ),
      ],
    );
  }
}
