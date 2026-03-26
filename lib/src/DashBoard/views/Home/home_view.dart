import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/src/DashBoard/views/Home/views/bestSeller_all_view.dart';
import 'package:bhbd_project/src/DashBoard/views/shop/views/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../resources/resources.dart';
import '../../../../shopify_api/services/shopify_client.dart';
import '../../../../shopify_api/services/collection_service.dart';
import '../../../../shopify_api/models/product_model.dart';
import '../../../../utils/currency_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  
  // Shopify services
  late ShopifyClient _shopifyClient;
  late CollectionService _collectionService;
  
  // Bestsellers products
  List<ProductModel> _bestsellersProducts = [];
  bool _isLoadingBestsellers = true;
  bool _isLoadingMoreBestsellers = false;
  String? _bestsellersError;
  String? _bestsellersCursor; // Cursor for pagination
  bool _hasMoreBestsellers = false; // Whether there are more products to load
  ScrollController? _bestsellersScrollController;

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
    
    // Initialize scroll controller for pagination
    _bestsellersScrollController = ScrollController();
    _bestsellersScrollController!.addListener(_onBestsellersScroll);
    
    // Initialize Shopify services
    _initializeShopify();
  }
  
  void _onBestsellersScroll() {
    // Check if user has scrolled to bottom
    if (_bestsellersScrollController!.position.pixels >= 
        _bestsellersScrollController!.position.maxScrollExtent - 200) {
      // Load more when 200px from bottom
      if (_hasMoreBestsellers && !_isLoadingMoreBestsellers && !_isLoadingBestsellers) {
        _loadMoreBestsellers();
      }
    }
  }
  
  Future<void> _initializeShopify() async {
    try {
      _shopifyClient = ShopifyClient();
      await _shopifyClient.initialize();
      _collectionService = CollectionService(_shopifyClient);
      
      // Fetch bestsellers products
      await _fetchBestsellers();
    } catch (e) {
      setState(() {
        _bestsellersError = e.toString();
        _isLoadingBestsellers = false;
      });
    }
  }
  
  Future<void> _fetchBestsellers({bool reset = true}) async {
    if (reset) {
      setState(() {
        _isLoadingBestsellers = true;
        _bestsellersError = null;
        _bestsellersProducts = [];
        _bestsellersCursor = null;
        _hasMoreBestsellers = false;
      });
    }
    
    try {
      print('🔍 Fetching bestsellers collection...');
      print('📦 Store URL: https://bhbd.myshopify.com/api/2025-10/graphql.json');
      
      final result = await _collectionService.getCollectionWithProducts(
        handle: 'bestsellers',
        productsFirst: 20, // Fetch 20 products per page
        productsAfter: reset ? null : _bestsellersCursor,
        // Note: Collection products are already sorted by Shopify's collection order
        // No need for sortKey as the collection itself defines the order
      );
      
      print('✅ Successfully fetched ${result.products.length} products');
      print('📄 Has more: ${result.hasNextPage}, Cursor: ${result.endCursor}');
      
      setState(() {
        if (reset) {
          _bestsellersProducts = result.products;
        } else {
          _bestsellersProducts.addAll(result.products);
        }
        _isLoadingBestsellers = false;
        _hasMoreBestsellers = result.hasNextPage;
        _bestsellersCursor = result.endCursor;
      });
    } catch (e) {
      // Extract more detailed error message
      String errorMessage = 'Failed to load products';
      String debugInfo = '';
      
      if (e.toString().contains('NOT_FOUND') || e.toString().contains('not found')) {
        errorMessage = 'Collection "bestsellers" not found.\n\nPossible solutions:\n1. Check if the collection handle is correct\n2. Ensure the collection is published in Shopify';
        debugInfo = 'Try checking available collections in Shopify admin.';
      } else if (e.toString().contains('ACCESS_DENIED') || e.toString().contains('401') || e.toString().contains('403')) {
        errorMessage = 'Access denied.\n\nPlease add your Storefront API access token in:\nlib/shopify_api/config/shopify_config.dart';
        debugInfo = 'Get token from: Shopify Admin > Settings > Apps > Develop apps';
      } else if (e.toString().contains('Network') || e.toString().contains('timeout') || e.toString().contains('SocketException')) {
        errorMessage = 'Network error.\n\nPlease check your internet connection.';
        debugInfo = 'Error: ${e.toString()}';
      } else if (e.toString().contains('MAX_COMPLEXITY')) {
        errorMessage = 'Query too complex.\n\nTry reducing the number of products or add Storefront API access token.';
        debugInfo = 'Error: ${e.toString()}';
      } else {
        errorMessage = 'Error loading products';
        debugInfo = 'Details: ${e.toString()}';
      }
      
      print('❌ Error fetching bestsellers: $e');
      print('📋 Debug info: $debugInfo');
      
      setState(() {
        _bestsellersError = '$errorMessage\n\n$debugInfo';
        _isLoadingBestsellers = false;
        _isLoadingMoreBestsellers = false;
      });
    }
  }
  
  Future<void> _loadMoreBestsellers() async {
    if (!_hasMoreBestsellers || _isLoadingMoreBestsellers || _bestsellersCursor == null) {
      return;
    }
    
    setState(() {
      _isLoadingMoreBestsellers = true;
    });
    
    try {
      final result = await _collectionService.getCollectionWithProducts(
        handle: 'bestsellers',
        productsFirst: 20,
        productsAfter: _bestsellersCursor,
      );
      
      print('✅ Loaded ${result.products.length} more products');
      print('📄 Has more: ${result.hasNextPage}');
      
      setState(() {
        _bestsellersProducts.addAll(result.products);
        _hasMoreBestsellers = result.hasNextPage;
        _bestsellersCursor = result.endCursor;
        _isLoadingMoreBestsellers = false;
      });
    } catch (e) {
      print('❌ Error loading more bestsellers: $e');
      setState(() {
        _isLoadingMoreBestsellers = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bestsellersScrollController?.removeListener(_onBestsellersScroll);
    _bestsellersScrollController?.dispose();
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
              // Navigate to see all bestsellers
              Get.to(()=>SeeAllProductsScreen());
            },
            child: Text(
              "See all",
              style: R.textStyles.poppins(
                color: R.colors.lightGreyColor.withOpacity(.5),
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
      backgroundColor: R.colors.backGroundColor,
      body: ListView(
        controller: _bestsellersScrollController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: R.colors.fieldBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: R.colors.fieldBorderColor),
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
                  borderSide: BorderSide(color: R.colors.fieldBorderColor),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoadingBestsellers
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(
                        color: R.colors.buttonColor,
                      ),
                    ),
                  )
                : _bestsellersError != null
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),
                              SizedBox(height: 12),
                              Text(
                                _bestsellersError!,
                                textAlign: TextAlign.center,
                                style: R.textStyles.poppins(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _fetchBestsellers(reset: true),
                                child: Text(
                                  'Retry',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: R.colors.buttonColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _bestsellersProducts.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text(
                                'No products found',
                                style: R.textStyles.poppins(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 3,
                                  childAspectRatio: 0.75, // Adjust based on card size
                                ),
                                itemCount: _bestsellersProducts.length,
                                itemBuilder: (context, index) {
                                  final product = _bestsellersProducts[index];
                                  return productCardFromModel(product);
                                },
                              ),
                              // Loading indicator for pagination
                              if (_isLoadingMoreBestsellers)
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: R.colors.buttonColor,
                                    ),
                                  ),
                                ),
                              // End of list indicator
                              if (!_hasMoreBestsellers && _bestsellersProducts.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      'No more products',
                                      style: R.textStyles.poppins(
                                        fontSize: 12.sp,
                                        color: Colors.grey,
                                      ),
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
                  backgroundColor: R.colors.commonLightGrey,
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
                    color: R.colors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Legacy method - keeping for backward compatibility if needed
  Widget productCard(String title, String price, String oldPrice, String img) {
    return productCardFromModel(null, title: title, price: price, oldPrice: oldPrice, img: img);
  }
  
  // New method using ProductModel from Shopify
  Widget productCardFromModel(ProductModel? product, {String? title, String? price, String? oldPrice, String? img}) {
    // Use product data if available, otherwise use provided parameters
    final productTitle = product?.title ?? title ?? 'Product';
    final productImages = product?.imageUrls ?? [];
    final productImage = product?.featuredImageUrl ?? img;
    final isAvailable = product?.availableForSale ?? true;
    
    // Prepare images list for carousel
    final List<String> imagesToShow = [];
    if (productImages.isNotEmpty) {
      imagesToShow.addAll(productImages);
    } else if (productImage != null && productImage.startsWith('http')) {
      imagesToShow.add(productImage);
    } else if (img != null) {
      imagesToShow.add(img);
    }
    
    // Format price based on device location
    String currentPrice;
    if (product?.priceRange?.minVariantPrice != null) {
      currentPrice = CurrencyHelper.formatShopifyPrice(
        product!.priceRange!.minVariantPrice.amount,
        product.priceRange!.minVariantPrice.currencyCode,
      );
    } else {
      currentPrice = price ?? CurrencyHelper.formatPrice(0.0);
    }
    
    // Get original price from compareAtPrice if available (formatted for device location)
    String? originalPrice;
    if (product?.compareAtPrice != null) {
      originalPrice = CurrencyHelper.formatShopifyPrice(
        product!.compareAtPrice!.amount,
        product.compareAtPrice!.currencyCode,
      );
    }
    
    final hasDiscount = originalPrice != null && 
        product?.priceRange?.minVariantPrice.amount != null &&
        product?.compareAtPrice?.amount != null;
    
    final oldPriceText = oldPrice ?? (hasDiscount ? originalPrice : null);
    
    return GestureDetector(
      onTap: (){
        Get.to(()=>ProductDetailsScreen());
      },
      child: Container(
        padding: EdgeInsets.all(3),
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
                    top: Radius.circular(08),
                  ),
                  child: imagesToShow.isNotEmpty && imagesToShow[0].startsWith('http')
                      ? imagesToShow.length > 1
                          ? _ProductImageSlider(
                              images: imagesToShow,
                              height: 140.h,
                            )
                          : Image.network(
                              imagesToShow[0],
                              height: 140.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 130.h,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 130.h,
                                color: Colors.grey[200],
                                child: Icon(Icons.error),
                              ),
                            )
                      : productImage != null && !productImage.startsWith('http')
                          ? Image.asset(
                              productImage,
                              height: 130.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 130.h,
                              color: Colors.grey[200],
                              child: Icon(Icons.image_not_supported),
                            ),
                ),
                heightBox(8),
                Text(
                  productTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: R.textStyles.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
                heightBox(4),
                Row(
                  children: [
                    Text(
                      currentPrice,
                      style: R.textStyles.poppins(
                        color: R.colors.commonLightGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                    if (oldPriceText != null) ...[
                      SizedBox(width: 6),
                      Text(
                        oldPriceText,
                        style: R.textStyles.poppins(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ],
                ),
                heightBox(3),
                // Show sold out or rating
                if (!isAvailable)
                  Text(
                    "Sold out",
                    style: R.textStyles.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  )
                else if (product?.averageRating != null && product!.averageRating! > 0)
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 2),
                      Text(
                        product.averageRating!.toStringAsFixed(1),
                        style: R.textStyles.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: R.colors.blackColor,
                        ),
                      ),
                      if (product.reviewCount != null && product.reviewCount! > 0) ...[
                        SizedBox(width: 4),
                        Text(
                          "(${product.reviewCount} ${product.reviewCount == 1 ? 'review' : 'reviews'})",
                          style: R.textStyles.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  )
                else
                  SizedBox.shrink(), // Hide if no reviews available
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
                      color: R.colors.blackColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Best Seller",
                      style: R.textStyles.poppins(
                        color: Colors.white,
                        fontSize: 08.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (hasDiscount) ...[
                    widthBox(5),
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: R.colors.offerBG2,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Sale",
                        style: R.textStyles.poppins(
                          color: Colors.white,
                          fontSize: 08.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
              color: R.colors.commonLightGrey,
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
                    color: R.colors.blackColor,
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
                        color: R.colors.commonLightGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "\$15.49",
                      style: R.textStyles.poppins(
                        color: R.colors.commonLightGrey,
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

/// Product Image Slider Widget
/// Separate StatefulWidget to properly manage PageController
class _ProductImageSlider extends StatefulWidget {
  final List<String> images;
  final double height;

  const _ProductImageSlider({
    required this.images,
    required this.height,
  });

  @override
  State<_ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<_ProductImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop to last image
      _pageController.jumpToPage(widget.images.length - 1);
    }
  }

  void _goToNext() {
    if (_currentPage < widget.images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop to first image
      _pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: widget.height,
                width: double.infinity,
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: widget.height,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: widget.height,
                    color: Colors.grey[200],
                    child: Icon(Icons.error),
                  ),
                ),
              );
            },
          ),
        // Previous arrow (left)
        Positioned(
          left: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: _goToPrevious,
              child: Container(
                width: 27.w,
                height: 27.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        // Next arrow (right)
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: _goToNext,
              child: Container(
                width: 27.w,
                height: 27.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        )],
      ),
    );
  }
}
