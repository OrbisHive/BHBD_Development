import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/src/DashBoard/views/Home/views/all_products_highlights%20_view.dart';
import 'package:bhbd_project/src/DashBoard/views/Home/views/bestSeller_all_view.dart';
import 'package:bhbd_project/src/DashBoard/views/shop/views/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../resources/resources.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
          )
          ..initialize().then((_) {
            setState(() {});
            _controller.setLooping(true);
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildTitle(String title, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: R.textStyles.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          GestureDetector(
            onTap: (){
           if(index==0){
             Get.to(()=>SeeAllProductsScreen());
           } else if(index==1){
             Get.to(()=>SeeAllProductHighlights());
           } else{
             Get.to(()=>SeeAllProductsScreen());
           }
            }
            ,
            child: Text(
              "See all",
              style: R.textStyles.poppins(
                color: R.color.lightGreyColor.withOpacity(.5),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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

          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: bannerWidget(),
          ),

          heightBox(8),
          buildTitle("Our Bestsellers",0),
          SizedBox(
            height: 210.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  productCard(
                    "BHBD Hair Care Essential Kit",
                    "\$45.89",
                    "\$54.49",
                    R.images.shampoo,
                  ),
                  widthBox(10),
                  productCard(
                    "BHBD Hair Care Essential Kit",
                    "\$45.89",
                    "\$54.49",
                    R.images.shampoo2,
                  ),
                  widthBox(10),
                  productCard(
                    "BHBD Hair Care Essential Kit",
                    "\$45.89",
                    "\$54.49",
                    R.images.shampoo,
                  ),
                ],
              ),
            ),
          ),

          buildTitle("Product Highlights",1),
          heightBox(8),
          SizedBox(
            height: 135.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemCount: 3,
              itemBuilder: (context, index) =>
                  videoCard("Highlights Title", "2:45"),
            ),
          ),

          buildTitle("Recommended Courses",2),
          SizedBox(
            height: 170.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              children: [
                courseCard("Course Title", "Iker Robbio", R.images.course1),
                courseCard("Course Title", "Anna Kebrics", R.images.course2),
                courseCard("Course Title", "Iker Robbio", R.images.course1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bannerWidget() {
    return Stack(
      children: [

        CarouselSlider(

          options: CarouselOptions(

            height: 130.h,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
          items: [
            Image.asset(
              R.images.welcomeBG,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Image.asset(
              R.images.welcomeBG,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Image.asset(
              R.images.welcomeBG,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ],
        ),

        Positioned(
          top: 15,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Aboard!",
                style: R.textStyles.poppins(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              heightBox(8),
              Text(
                "Explore courses, chat with instructors,\nand track progress in one place.",
                style: TextStyle(color: Colors.white, fontSize: 13.sp),
              ),
              heightBox(12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: R.color.commonLightGrey,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Explore shop",
                  style: R.textStyles.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: R.color.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget productCard(String title, String price, String oldPrice, String img) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>ProductDetailsScreen());
      },
      child: Container(
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
              bottom: 75,
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
      ),
    );
  }

  Widget videoCard(String title, String duration) {
    return Container(
      width: 180.w,
      padding: EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              Positioned(
                top: 15,
                left: 50,
                child: IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Colors.white,
                    size: 35.h,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
              ),
            ],
          ),
          heightBox(12),
          Text(
            title,
            style: R.textStyles.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
          heightBox(6),
          Text(
            duration,
            style: R.textStyles.poppins(
              color: R.color.commonLightGrey,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
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
                SizedBox(height: 6),
                Text(
                  author,
                  style: R.textStyles.poppins(
                    color: R.color.blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8),
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
}
