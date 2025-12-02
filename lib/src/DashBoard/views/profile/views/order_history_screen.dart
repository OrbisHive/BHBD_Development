import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../resources/resources.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool isActiveSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: R.color.backGroundColor,
        surfaceTintColor: Colors.transparent,
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
          "Order History",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isActiveSelected = true),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: isActiveSelected ? const Color(0xFF5A3E42) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Active",
                        style: GoogleFonts.poppins(
                          color: isActiveSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isActiveSelected = false),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: !isActiveSelected ? const Color(0xFF5A3E42) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Completed",
                        style: GoogleFonts.poppins(
                          color: !isActiveSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Active Orders
            if (isActiveSelected)
              Expanded(
                child: ListView(
                  children: [
                    orderCard(
                      orderId: "#404502231",
                      items: 3,
                      price: "\$113.79",
                      images: [
                        R.images.shampoo2,
                        R.images.shop1,
                        R.images.shampoo,

                      ],
                    ),
                    orderCard(
                      orderId: "#404502232",
                      items: 1,
                      price: "\$29.99",
                      images: [
                        R.images.shop1,
                      ],
                    ),
                    orderCard(
                      orderId: "#404502233",
                      items: 5,
                      price: "\$250.00",
                      images: [
                        R.images.shampoo2,
                        R.images.shop1,
                        R.images.shampoo,
                        R.images.shop3,

                      ],
                    ),
                  ],
                ),
              )
            else
              orderCard(
                orderId: "#404502233",
                items: 5,
                price: "\$250.00",
                images: [
                  R.images.shampoo2,
                  R.images.shop1,
                  R.images.shampoo,
                  R.images.shop3,

                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget orderCard({
    required String orderId,
    required int items,
    required String price,
    required List<String> images,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID $orderId",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.5),
                decoration: BoxDecoration(
                  color: isActiveSelected?const Color(0xFFE8F2FF):Colors.green.withOpacity(.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                 isActiveSelected? "ACTIVE":"Completed",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: isActiveSelected?const Color(0xFF2196F3):Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          Text(
            "$items items  •  $price",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),

          // Images Row
          Row(
            children: images.map((url) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    url,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
