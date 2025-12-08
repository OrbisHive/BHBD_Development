import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../Widgets/height_width_box.dart';
import '../../../../../resources/resources.dart';

class SeeAllProductsScreen extends StatefulWidget {
  const SeeAllProductsScreen({super.key});

  @override
  State<SeeAllProductsScreen> createState() => _SeeAllProductsScreenState();
}

class _SeeAllProductsScreenState extends State<SeeAllProductsScreen> {
  List<String> images = [
    R.images.shampoo,
    R.images.shampoo2,
    R.images.shop4,
    R.images.shampoo,
    R.images.shop4,
    R.images.shampoo2,
    R.images.shop4,
    R.images.shampoo,
    R.images.shop4,
    R.images.shampoo2,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 15, 0, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(.1),
                  blurRadius: 0.5,
                  spreadRadius: 0.2,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          ),
        ),
        title: Text(
          "All Bestsellers",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return productCard(
              "BHBD Hair Care Essential Kit",
              "\$45.89",
              "\$54.49",
              images[index],
            );
          },
        ),
      ),
    );
  }

  Widget productCard(String title, String price, String oldPrice, String img) {
    return Container(
      width: 180.w,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
                child: Image.asset(
                  img,
                  height: 130.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              heightBox(8),
              Text(
                title,
                style: R.textStyles.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
              heightBox(4),
              Row(
                children: [
                  Text(
                    price,
                    style: R.textStyles.poppins(
                      color: R.color.commonLightGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    oldPrice,
                    style: R.textStyles.poppins(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: R.color.commonLightGrey,
                    ),
                  ),
                ],
              ),
              heightBox(3),
              Row(
                children: [
                  Icon(Icons.star, color: R.color.commonLightGrey, size: 18),
                  SizedBox(width: 3),
                  Text(
                    "4.9 (14 reviews)",
                    style: R.textStyles.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: R.color.blackColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 10,
            bottom: 80,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: R.color.offerBG,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Best Seller",
                    style: R.textStyles.poppins(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                widthBox(5),
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: R.color.offerBG2,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "10 % Off",
                    style: R.textStyles.poppins(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
