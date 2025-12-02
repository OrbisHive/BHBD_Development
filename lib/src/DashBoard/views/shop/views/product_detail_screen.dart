
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../resources/resources.dart';
import 'add_cart.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentIndex = 0;

  final List<String> productImages = [
    R.images.shampoo,
    R.images.shampoo2,
    R.images.shampoo,
    R.images.shampoo2,
  ];

  final List<Map<String, dynamic>> relatedProducts = [
    {
      "image": R.images.shop3,
      "title": "Scarlet Wig / 50cm",
      "price": "\$28.00",
      "oldPrice": "\$34.59",
      "rating": "5.0 (8 reviews)",
    },
    {
      "image": R.images.shop4,
      "title": "BHBD Mask 250ml",
      "price": "\$19.29",
      "oldPrice": "\$28.75",
      "rating": "4.6 (104 reviews)",
    },
    {
      "image": R.images.shampoo2,
      "title": "Silver Shampoo 500ml",
      "price": "\$25.00",
      "oldPrice": "\$30.00",
      "rating": "4.9 (32 reviews)",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(18,15,0,15),
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
          "Product Details",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: R.color.backGroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      // 🖼️ Product Image Slider
                      Stack(
                        children: [
                          CarouselSlider.builder(
                            itemCount: productImages.length,
                            itemBuilder: (context, index, realIndex) {
                              return ClipRRect(
                                child: Image.asset(
                                  productImages[index],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 250.h,
                              viewportFraction: 1,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${_currentIndex + 1}/${productImages.length}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 🧴 Product Details
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Shampoo",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: R.color.buttonColor,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "BHBD Silver Shampoo",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: R.color.buttonColor, size: 22),
                                    SizedBox(width: 4),
                                    Text(
                                      "4.7 (21 reviews)",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                                  "Fusce non es vel neque suscipit tristique. Integer ullamcorper "
                                  "leo ut metus ultricies, eu suscipit tellus tempor.",
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Divider(color: Colors.grey.withOpacity(.2)),
                            SizedBox(height: 5.h),

                            // 🔁 Related Products
                            Text(
                              "Related products",
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  relatedProducts.length,
                                      (index) {
                                    final product = relatedProducts[index];
                                    return Container(
                                      width: 150.w,
                                      margin: EdgeInsets.only(
                                        right: index == relatedProducts.length - 1 ? 0 : 12, // ✅ last item condition
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(
                                              product["image"],
                                              height: 120.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            product["title"],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                product["price"],
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFF6D466B),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                product["oldPrice"],
                                                style: GoogleFonts.poppins(
                                                  decoration: TextDecoration.lineThrough,
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.star, color: R.color.buttonColor, size: 16),
                                              SizedBox(width: 4),
                                              Text(
                                                product["rating"],
                                                style: GoogleFonts.poppins(fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // space for bottom bar
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // ✅ Fixed Bottom Bar (no disorder now)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Price",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "\$28.00",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6D466B),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "\$34.59",
                        style: GoogleFonts.poppins(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: R.color.buttonColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.to(()=>CartScreen());
                },
                child: Text(
                  "Add to cart",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
