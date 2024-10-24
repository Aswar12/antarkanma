// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:antarkanma/app/widgets/product_tile.dart';
import 'package:antarkanma/theme.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
                        const SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.search_outlined,
                          color: backgroundColor6,
                        ),
                        SizedBox(
                          width: Dimenssions.width10,
                        ),
                        Text(
                          'Apa Ku AntarkanKi ?',
                          style: subtitleTextStyle.copyWith(
                              fontSize: Dimenssions.font14,
                              color: backgroundColor6),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: Dimenssions.width55,
                height: Dimenssions.width55,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/profil.png')),
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
          SizedBox(
            height: Dimenssions.height5,
          ),
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
      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(
            top: Dimenssions.height5,
            left: Dimenssions.height25,
            bottom: Dimenssions.height10,
          ),
          child: Text(
            'Produk Populer',
            style: primaryTextStyle.copyWith(
              fontSize: Dimenssions.font20,
              color: backgroundColor6,
            ),
          ),
        ),
      );
    }

    Widget;
    listProductsTitle() {
      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(
            top: Dimenssions.height5,
            left: Dimenssions.height25,
            bottom: Dimenssions.height10,
          ),
          child: Text(
            'Daftar Produk',
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
        margin: EdgeInsets.only(
          top: Dimenssions.height10,
        ),
        child: const Column(children: [
          ProductTile(),
          ProductTile(),
          ProductTile(),
          ProductTile(),
        ]),
      );
    }

    return ListView(
      children: [
        header(),
        // categories(),
        popularProductsTitle(),
        popularProducts(),
        listProductsTitle(),
        listProducts(),
      ],
    );
  }

  _buildPageItem(
    int index,
  ) {
    // ProductProvider productProvider = Provider.of<ProductProvider>(context);
    // ProductModel product = productProvider.products[index];
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
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ProductPage(product),
        //   ),
        // );
      },
      child: Transform(
        transform: matrix,
        child: Stack(
          children: [
            Container(
              height: Dimenssions.pageViewContainer,
              margin: EdgeInsets.only(
                  left: Dimenssions.width10, right: Dimenssions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimenssions.radius30),
                  color: index.isEven
                      ? const Color(0xff69c5df)
                      : const Color(0xff9294cc),
                  image: const DecorationImage(
                    image: AssetImage('assets/image_shoes2.png'),
                    fit: BoxFit.cover,
                  )),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: Dimenssions.pageTextContainer,
                  margin: EdgeInsets.only(
                      left: Dimenssions.width30,
                      right: Dimenssions.width30,
                      bottom: Dimenssions.height10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimenssions.radius20),
                      color: Colors.white,
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(
                            color: Color(0xffe8e8e8),
                            blurRadius: 5.0,
                            offset: Offset(5, 5)),
                        const BoxShadow(
                            color: Colors.white, offset: Offset(-5, 0)),
                        const BoxShadow(
                            color: Colors.white, offset: Offset(5, 0))
                      ]),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: Dimenssions.height15,
                        left: Dimenssions.width15,
                        right: Dimenssions.width15),
                    // child: AppColumn(
                    //   name: product.name,
                    //   price: product.price,
                    //   kedai: product.kedai.name,
                    //   category: product.category.name,
                    // ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
