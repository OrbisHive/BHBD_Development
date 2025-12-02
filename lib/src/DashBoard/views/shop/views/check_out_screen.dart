import 'package:bhbd_project/Widgets/app_button.dart';
import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../resources/resources.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedAddressIndex = 0;
  List<String> images = [
    R.images.shampoo,
    R.images.shampoo2,
    R.images.shop3,
    R.images.shop4,
    R.images.shampoo,
    R.images.shampoo2,
    R.images.shop3,
    R.images.shop4,
  ];
  final List<Map<String, String>> addresses = [
    {'title': 'Home', 'address': 'Metropolitan Heights, Rivertown'},
    {'title': 'Work', 'address': '1901 Thornridge Cir. Shiloh, Hawaii 81063'},
  ];

  void _editAddress(int index) {
    showDialog(
      context: context,
      builder: (_) {
        final controller = TextEditingController(
          text: addresses[index]['address'],
        );
        return AlertDialog(
          title: Text(
            'Edit Address',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    width: Get.width,
                    backgroundColor: R.color.buttonColor,
                    textColor: Colors.white,
                    onTap: () {
                      setState(
                        () => addresses[index]['address'] = controller.text,
                      );
                      Navigator.pop(context);
                    },
                    title: "Save",
                  ),
                ),
                widthBox(8),
                Expanded(
                  child: AppButton(
                    width: Get.width,
                    fontWeight: FontWeight.w500,
                    borderColor: R.color.buttonColor,
                    textColor: R.color.buttonColor,
                    backgroundColor: Colors.transparent,
                    onTap: () => Navigator.pop(context),
                    title: "Cancel",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: R.color.backGroundColor,
        surfaceTintColor: CupertinoColors.transparent,
        elevation: 0,
        leading: GestureDetector(
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
          "Check Out",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            heightBox(10),
            Container(
              padding: EdgeInsets.all(14),
              color: Colors.grey.withOpacity(.12),
              child: Center(
                child: Text(
                  "8 items  •  Total \$113.79",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: R.color.buttonColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightBox(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shipping Address",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "+ Add New",
                          style: GoogleFonts.poppins(
                            color: R.color.buttonColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // --- Address List ---
                  ...List.generate(addresses.length, (index) {
                    final isSelected = selectedAddressIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedAddressIndex = index),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? R.color.buttonColor
                                : Colors.grey.shade300,
                          ),
                          color: isSelected
                              ? Colors.purple.withOpacity(0.05)
                              : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Radio(
                              value: index,
                              groupValue: selectedAddressIndex,
                              activeColor: R.color.buttonColor,
                              onChanged: (v) =>
                                  setState(() => selectedAddressIndex = index),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addresses[index]['title']!,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    addresses[index]['address']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      color: R.color.lightGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Image.asset(R.images.edit, scale: 4),
                              onPressed: () => _editAddress(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 15.h),
                  Text(
                    "All Items (8)",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // --- Item Card ---
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(images.length, (index) {
                        return Container(
                          margin: EdgeInsets.only(right: index == images.length - 1 ? 0 : 12.w),

                          width: 180.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(11),
                                ),
                                child: Image.asset(
                                  images[index],
                                  height: 105.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "BHBD Silver Shampoo",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    Text(
                                      "Quantity: 2",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    heightBox(8),
                                    Row(
                                      children: [
                                        Text(
                                          "\$28.00",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: R.color.buttonColor,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          "\$34.59",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
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
                      }),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  _buildSummaryRow("Order Number", "466516823"),
                  _buildSummaryRow("Order Date", "Feb 14, 2025"),
                  _buildSummaryRow("Order Total", "\$113.79"),
                  _buildSummaryRow("Service Charges", "\$8.50"),
                  Divider(),
                  _buildSummaryRow("Total Amount", "\$122.99", isBold: true),
                  SizedBox(height: 20.h),
                  AppButton(
                    title: "Proceed to Pay",
                    onTap: () {},
                    backgroundColor: R.color.buttonColor,
                    height: 40.h,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.white,
                    fontSize: 13.sp,
                  ),
                  SizedBox(height: 5.h),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Your payment is secure and encrypted via ",
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                        children: [
                          TextSpan(
                            text: "Stripe.",
                            style: GoogleFonts.poppins(color: Colors.purple),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(.7),
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 13.sp,
              fontWeight:  FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}
