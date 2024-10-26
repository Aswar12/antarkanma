import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final String merchantName;
  final double distance;
  final int duration;
  final double rating;
  final int reviews;
  final VoidCallback? onTap;

  const ProductTile({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.merchantName,
    required this.distance,
    required this.duration,
    required this.rating,
    required this.reviews,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Fixed height for the container
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
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimenssions.radius20),
                bottomLeft: Radius.circular(Dimenssions.radius20),
              ),
              child: Image.asset(
                imageUrl,
                width: Dimenssions.height150,
                height: Dimenssions.height150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Dimenssions.height10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: primaryTextStyle.copyWith(
                        fontSize: Dimenssions.font14,
                        fontWeight: semiBold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Rp ${price.toStringAsFixed(0)}',
                      style: priceTextStyle.copyWith(
                        fontSize: Dimenssions.font12,
                        fontWeight: medium,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.store,
                            color: backgroundColor6, size: Dimenssions.font14),
                        SizedBox(width: Dimenssions.width5),
                        Expanded(
                          child: Text(
                            merchantName,
                            style: secondaryTextStyle.copyWith(
                              fontSize: Dimenssions.font10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem(
                            Icons.location_on,
                            '${distance.toStringAsFixed(1)} km',
                            backgroundColor6),
                        _buildInfoItem(Icons.access_time_rounded,
                            '$duration min', backgroundColor6),
                        _buildRatingItem(rating, reviews),
                      ],
                    ),
                  ],
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
        const SizedBox(width: 2),
        Text(
          text,
          style: secondaryTextStyle.copyWith(fontSize: Dimenssions.font10),
        ),
      ],
    );
  }

  Widget _buildRatingItem(double rating, int reviews) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: Dimenssions.font14),
        const SizedBox(width: 2),
        Text(
          '$rating ($reviews)',
          style: secondaryTextStyle.copyWith(fontSize: Dimenssions.font10),
        ),
      ],
    );
  }
}
