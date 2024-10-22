import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimenssions.width25,
        right: Dimenssions.width25,
        bottom: Dimenssions.height25,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimenssions.radius30),
            child: Image.asset(
              'assets/image_shoes.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: Dimenssions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Football',
                  style: secondaryTextStyle.copyWith(
                    fontSize: Dimenssions.font16,
                  ),
                ),
                SizedBox(
                  height: Dimenssions.height10,
                ),
                Text(
                  'Predator 20,2 firm ground',
                  style: primaryTextStyle.copyWith(
                    fontSize: Dimenssions.font18,
                    fontWeight: semiBold,
                  ),
                ),
                SizedBox(
                  height: Dimenssions.height10,
                ),
                Text(
                  'Rp.800.000',
                  style: priceTextStyle.copyWith(
                      fontSize: Dimenssions.font16, fontWeight: medium),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
