import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/src/DashBoard/views/shop/views/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<String> filterList = ["All", "Wigs", "Wig Care", "Shampoo", "Hair Mask"];

  int selectedIndex = 0; // ✅ default selected item index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              // 🔍 Search Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: R.color.fieldBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: R.color.fieldBorderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search here.....",
                        hintStyle: R.textStyles.poppins(
                          color: Colors.black38,
                          fontSize: 14.sp,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: R.color.fieldBorderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Image.asset(R.images.search, scale: 4),
                      ),
                    ),
                  ),
                  widthBox(8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: R.color.buttonColor2,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(R.images.sort, scale: 3.9),
                  ),
                ],
              ),
        
              heightBox(12),
        
              // 🔁 Horizontal scrollable filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    filterList.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: types(filterList[index], index),
                    ),
                  ),
                ),
              ),
              heightBox(8),
              SizedBox(
                height: 200.h,
                child: Row(
                  children: [
                    productCard(
                      "BHBD Hair Care Essential Kit",
                      "\$45.89",
                      "\$54.49",
                      R.images.shampoo,
                      0,
                    ),
                    widthBox(12),
                    productCard(
                      "BHBD Hair Care Essential Kit",
                      "\$45.89",
                      "\$54.49",
                      R.images.shampoo2,
                      1,
                    ),
                  ],
                ),
              ),
              heightBox(8),
              SizedBox(
                height: 200.h,
                child: Row(
                  children: [
                    productCard(
                      "BHBD Hair Care Essential Kit",
                      "\$45.89",
                      "\$54.49",
                      R.images.shop3,
                      1,
                    ),
                    widthBox(12),
                    productCard(
                      "BHBD Hair Care Essential Kit",
                      "\$45.89",
                      "\$54.49",
                      R.images.shop4,
                      0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Filter type widget
  Widget types(String title, int index) {
    bool isSelected = selectedIndex == index;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? R.color.buttonColor : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? R.color.buttonColor : Colors.grey[200]!,
        ),
      ),
      child: Text(
        title,
        style: R.textStyles.poppins(
          color: isSelected ? Colors.white : R.color.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget courseCard(String title, String author, String img) {
    return Container(
      width: 180.w,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              img,
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: R.textStyles.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  author,
                  style: R.textStyles.poppins(
                    color: R.color.blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "\$12.75",
                      style: R.textStyles.poppins(
                        color: R.color.commonLightGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "\$15.49",
                      style: R.textStyles.poppins(
                        color: R.color.commonLightGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
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
  }

  Widget productCard(
    String title,
    String price,
    String oldPrice,
    String img,
    int index,
  ) {
    return InkWell(
      onTap: (){
        Get.to(()=>ProductDetailsScreen());
      },
      child: Container(
        width: 157.w,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Stack(
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
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                heightBox(8),
                const SizedBox(height: 4),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: R.textStyles.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                heightBox(6),
                Row(
                  children: [
                    Text(
                      price,
                      style: R.textStyles.poppins(
                        color: R.color.buttonColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      oldPrice,
                      style: R.textStyles.poppins(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: R.color.commonLightGrey,
                      ),
                    ),
                  ],
                ),
                heightBox(5),
                Row(
                  children: [
                    Icon(Icons.star, color: R.color.buttonColor, size: 18),
                    const SizedBox(width: 3),
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
              left: 8,
              bottom: 90,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: R.color.buttonColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Best Seller",
                      style: R.textStyles.poppins(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  widthBox(5),
                  index == 1
                      ? Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: R.color.offerBG2,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "10 % Off",
                            style: R.textStyles.poppins(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
