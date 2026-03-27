import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../Constants/main_vm.dart';
import '../../../../../resources/resources.dart';
import 'add_address_dialog.dart';
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});
  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Map<String, dynamic>> addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final list = await MainVM.authVM(context).getAllAddresses();
    if (!mounted) return;
    setState(() {
      addresses = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[100],
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
          "Addresses",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? _buildEmptyState()
          : _buildAddressesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddAddressDialog();
        },
        backgroundColor: R.colors.buttonColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Address",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            Text(
              "No addresses added",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Add your first address to get started",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            // SizedBox(height: 32.h),
            // ElevatedButton(
            //   onPressed: () {
            //     _showAddAddressDialog();
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: R.colors.buttonColor,
            //     padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: Text(
            //     "Add Address",
            //     style: GoogleFonts.poppins(
            //       color: Colors.white,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${address['firstName'] ?? ''} ${address['lastName'] ?? ''}"
                            .trim()
                            .isEmpty
                        ? 'Address'
                        : "${address['firstName'] ?? ''} ${address['lastName'] ?? ''}"
                              .trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (address['isDefault'] == true)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Default",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Street/House no: ${address['address1']}${(address['address2'] ?? '').toString().isEmpty ? '' : '\n${address['address2']}'}\nCity : ${address['city']},\nPostal code : ${address['zip']}${(address['province'] ?? '').toString().isEmpty ? '' : ', ${address['province']}'}\nCountry : ${address['country']}',
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TODO: integrate edit/delete APIs when required.
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddAddressDialog({Map<String, dynamic>? address}) {
    showDialog(
      useSafeArea: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => AddAddressDialog(
        address: address,
        onSave: (newAddress) async {
          final bool created = await MainVM.authVM(
            context,
          ).addAddress(address: newAddress);
          if (!created) return false;

          await _loadAddresses();
          if (!mounted) return false;
          Get.snackbar("Success", "Address added successfully");
          return true;
        },
      ),
    );
  }
}
