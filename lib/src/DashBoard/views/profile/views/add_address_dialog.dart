import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../../resources/resources.dart';

class AddAddressDialog extends StatefulWidget {
  final Map<String, dynamic>? address;
  final Future<bool> Function(Map<String, dynamic>) onSave;

  const AddAddressDialog({
    super.key,
    this.address,
    required this.onSave,
  });

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isDefault = false;
  String _selectedCountry = 'Sweden';
  String _phoneNumber = '';

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _streetController;
  late TextEditingController _address2Controller;
  late TextEditingController _postalCodeController;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;
  bool _isSaving = false;

  final List<String> _countries = [
    'Sweden',
    'United States',
    'United Kingdom',
    'Canada',
    'Germany',
    'France',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.address?['firstName'] ?? '');
    _lastNameController = TextEditingController(text: widget.address?['lastName'] ?? '');
    _streetController = TextEditingController(text: widget.address?['address1'] ?? '');
    _address2Controller = TextEditingController(text: widget.address?['address2'] ?? '');
    _postalCodeController = TextEditingController(text: widget.address?['zip'] ?? '');
    _cityController = TextEditingController(text: widget.address?['city'] ?? '');
    _provinceController = TextEditingController(text: widget.address?['province'] ?? '');
    _isDefault = widget.address?['isDefault'] ?? false;
    _selectedCountry = widget.address?['country'] ?? 'Sweden';
    _phoneNumber = widget.address?['phone'] ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _address2Controller.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.withOpacity(.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(12.w),
        constraints: BoxConstraints(maxWidth: 500.w, maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.address == null ? "Add address" : "Edit address",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 24.sp),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                // Default address checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value ?? false;
                        });
                      },
                      activeColor: R.colors.buttonColor,
                    ),
                    Text(
                      "This is my default address",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Country/Region
                Text(
                  "Country/region",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value ?? 'Sweden';
                    });
                  },
                ),
                SizedBox(height: 8.h),

                // First Name and Last Name Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? "Required" : null,
                        decoration: InputDecoration(
                          hintText: "First name",
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? "Required" : null,
                        decoration: InputDecoration(
                          hintText: "Last name",
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Street and House Number
                TextFormField(
                  controller: _streetController,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Street is required" : null,
                  decoration: InputDecoration(
                    hintText: "Street and house number",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _address2Controller,
                  decoration: InputDecoration(
                    hintText: "Apartment, suite, etc. (optional)",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  ),
                ),
                SizedBox(height: 8.h),

                // Postal Code and City/Town Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _postalCodeController,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? "Required" : null,
                        decoration: InputDecoration(
                          hintText: "Postal code",
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? "Required" : null,
                        decoration: InputDecoration(
                          hintText: "City/town",
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _provinceController,
                  decoration: InputDecoration(
                    hintText: "Province / State (optional)",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: R.colors.buttonColor, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  ),
                ),
                SizedBox(height: 8.h),

                // Phone
                Text(
                  "Phone",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: IntlPhoneField(
                    initialCountryCode: _selectedCountry == 'Sweden' ? 'SE' : 'US',
                    decoration: InputDecoration(
                      hintText: "Phone number",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                    ),
                    onChanged: (phone) {
                      _phoneNumber = phone.completeNumber;
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(

                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              if (_phoneNumber.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Phone number is required"),
                                  ),
                                );
                                return;
                              }

                              setState(() => _isSaving = true);
                              final address = {
                                'firstName': _firstNameController.text.trim(),
                                'lastName': _lastNameController.text.trim(),
                                'address1': _streetController.text.trim(),
                                'address2': _address2Controller.text.trim(),
                                'city': _cityController.text.trim(),
                                'country': _selectedCountry,
                                'province': _provinceController.text.trim(),
                                'zip': _postalCodeController.text.trim(),
                                'phone': _phoneNumber.trim(),
                              };
                              final String province =
                                  _provinceController.text.trim();
                              if (province.isNotEmpty) {
                                address['province'] = province;
                              }
                              final bool saved = await widget.onSave(address);
                              if (!mounted) return;
                              setState(() => _isSaving = false);
                              if (saved) Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: R.colors.buttonColor,

                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              height: 16.h,
                              width: 16.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Save",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

