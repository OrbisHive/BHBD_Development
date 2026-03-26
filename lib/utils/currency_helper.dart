import 'dart:ui' as ui;
import 'package:intl/intl.dart';

/// Currency Helper
/// 
/// Handles currency formatting based on device location/country.
/// Converts prices to local currency format.
class CurrencyHelper {
  // Currency exchange rates (update these with real-time rates or API)
  // Base currency: SEK (Swedish Krona)
  // Rates: How many units of target currency = 1 SEK
  static const Map<String, double> _exchangeRates = {
    'PKR': 30.0,  // 1 SEK = ~30 PKR (approximate, update with real rates)
    'SEK': 1.0,   // Base currency
    'USD': 0.095, // 1 SEK = ~0.095 USD
    'EUR': 0.088, // 1 SEK = ~0.088 EUR
    'GBP': 0.075, // 1 SEK = ~0.075 GBP
  };

  // Currency symbols
  static const Map<String, String> _currencySymbols = {
    'PKR': 'Rs.',
    'SEK': 'kr',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
  };

  /// Get device country code from locale
  static String getDeviceCountryCode() {
    try {
      final locale = ui.PlatformDispatcher.instance.locale;
      return locale.countryCode ?? 'SE'; // Default to Sweden
    } catch (e) {
      return 'SE'; // Default fallback
    }
  }

  /// Get currency code based on country
  static String getCurrencyCodeForCountry(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'PK':
        return 'PKR';
      case 'SE':
        return 'SEK';
      case 'US':
        return 'USD';
      case 'GB':
        return 'GBP';
      case 'DE':
      case 'FR':
      case 'IT':
      case 'ES':
      case 'NL':
      case 'BE':
      case 'AT':
      case 'PT':
      case 'FI':
      case 'IE':
      case 'GR':
      case 'LU':
        return 'EUR';
      default:
        return 'SEK'; // Default to SEK
    }
  }

  /// Get current currency code based on device location
  static String getCurrentCurrencyCode() {
    final countryCode = getDeviceCountryCode();
    return getCurrencyCodeForCountry(countryCode);
  }

  /// Convert amount from one currency to another
  static double convertCurrency(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    
    // Convert to base (SEK) first
    final fromRate = _exchangeRates[fromCurrency] ?? 1.0;
    final toRate = _exchangeRates[toCurrency] ?? 1.0;
    
    // Convert: amount / fromRate * toRate
    return (amount / fromRate) * toRate;
  }

  /// Format price with currency symbol
  static String formatPrice(double amount, {String? currencyCode}) {
    final currency = currencyCode ?? getCurrentCurrencyCode();
    final symbol = _currencySymbols[currency] ?? currency;
    
    // Format number with proper decimal places
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: currency == 'PKR' ? 0 : 2, // PKR typically no decimals
      locale: _getLocaleForCurrency(currency),
    );
    
    return formatter.format(amount);
  }

  /// Format price from Shopify Money object
  static String formatShopifyPrice(String amount, String shopifyCurrencyCode, {String? targetCurrencyCode}) {
    final amountNum = double.tryParse(amount) ?? 0.0;
    final targetCurrency = targetCurrencyCode ?? getCurrentCurrencyCode();
    
    // Convert if needed
    final convertedAmount = convertCurrency(amountNum, shopifyCurrencyCode, targetCurrency);
    
    return formatPrice(convertedAmount, currencyCode: targetCurrency);
  }

  /// Get locale string for currency formatting
  static String _getLocaleForCurrency(String currency) {
    switch (currency) {
      case 'PKR':
        return 'en_PK';
      case 'SEK':
        return 'sv_SE';
      case 'USD':
        return 'en_US';
      case 'EUR':
        return 'en_DE';
      case 'GBP':
        return 'en_GB';
      default:
        return 'en_US';
    }
  }

  /// Get currency symbol
  static String getCurrencySymbol({String? currencyCode}) {
    final currency = currencyCode ?? getCurrentCurrencyCode();
    return _currencySymbols[currency] ?? currency;
  }
}

