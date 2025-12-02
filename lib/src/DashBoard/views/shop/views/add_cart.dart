import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../resources/resources.dart';
import 'check_out_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      "image": R.images.shampoo2,
      "title": "BHBD Silver Shampoo",
      "rating": "4.7 (21 reviews)",
      "price": 28.00,
      "oldPrice": 34.59,
      "count": 2,
    },
    {
      "image":  R.images.shop4,
      "title": "BHBD Mask 250ml",
      "rating": "4.6 (104 reviews)",
      "price": 19.29,
      "oldPrice": 28.75,
      "count": 5,
    },
    {
      "image":  R.images.shampoo,
      "title": "BHBD Hair Care Essentials",
      "rating": "4.9 (14 reviews)",
      "price": 45.89,
      "oldPrice": 54.49,
      "count": 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,
      appBar: AppBar(
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
          "Your Cart",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item["image"],
                            height: 70.h,
                            width: 70.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item["title"],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cartItems.removeAt(index);
                                      });
                                    },
                                    child: Icon(Icons.close,
                                        color: Colors.grey[500], size: 20),
                                  )
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: const Color(0xFF6D466B), size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    item["rating"],
                                    style: GoogleFonts.poppins(fontSize: 12.sp,fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    "\$${item["price"].toStringAsFixed(2)}",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF6D466B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "\$${item["oldPrice"].toStringAsFixed(2)}",
                                    style: GoogleFonts.poppins(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.transparent
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (item["count"] > 1) {
                                                item["count"]--;
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(.2),
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          item["count"].toString(),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              item["count"]++;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(.2),
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: const Icon(
                                              Icons.add,
                                              size: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                Get.to(()=>CheckoutScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: R.color.buttonColor,
                minimumSize:  Size(double.infinity, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Proceed to checkout",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
            heightBox(30)
          ],
        ),
      ),
    );
  }
}
