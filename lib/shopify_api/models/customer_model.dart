/// Customer Model
/// 
/// Represents a Shopify customer.
/// Used to link app users with Shopify customers.

class CustomerModel {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int numberOfOrders;
  final bool acceptsMarketing;
  final CustomerAddress? defaultAddress;
  final List<CustomerAddress> addresses;
  final List<CustomerOrder> orders;

  CustomerModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.numberOfOrders = 0,
    this.acceptsMarketing = false,
    this.defaultAddress,
    this.addresses = const [],
    this.orders = const [],
  });

  /// Parse from GraphQL response
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] ?? json;
    
    final addresses = <CustomerAddress>[];
    if (customer['addresses'] != null && 
        customer['addresses']['edges'] != null) {
      for (var edge in customer['addresses']['edges']) {
        addresses.add(CustomerAddress.fromJson(edge['node']));
      }
    }

    final orders = <CustomerOrder>[];
    if (customer['orders'] != null && 
        customer['orders']['edges'] != null) {
      for (var edge in customer['orders']['edges']) {
        orders.add(CustomerOrder.fromJson(edge['node']));
      }
    }

    return CustomerModel(
      id: customer['id'] ?? '',
      email: customer['email'] ?? '',
      firstName: customer['firstName'],
      lastName: customer['lastName'],
      phone: customer['phone'],
      createdAt: customer['createdAt'] != null 
          ? DateTime.parse(customer['createdAt']) 
          : null,
      updatedAt: customer['updatedAt'] != null 
          ? DateTime.parse(customer['updatedAt']) 
          : null,
      numberOfOrders: customer['numberOfOrders'] ?? 0,
      acceptsMarketing: customer['acceptsMarketing'] ?? false,
      defaultAddress: customer['defaultAddress'] != null
          ? CustomerAddress.fromJson(customer['defaultAddress'])
          : null,
      addresses: addresses,
      orders: orders,
    );
  }
}

/// Customer Address Model
class CustomerAddress {
  final String id;
  final String? address1;
  final String? address2;
  final String? city;
  final String? province;
  final String? country;
  final String? zip;
  final String? firstName;
  final String? lastName;
  final String? phone;

  CustomerAddress({
    required this.id,
    this.address1,
    this.address2,
    this.city,
    this.province,
    this.country,
    this.zip,
    this.firstName,
    this.lastName,
    this.phone,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] ?? '',
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      province: json['province'],
      country: json['country'],
      zip: json['zip'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
    );
  }
}

/// Customer Order Model
class CustomerOrder {
  final String id;
  final String name;
  final int orderNumber;
  final DateTime? processedAt;
  final Money totalPrice;
  final Money? subtotalPrice;
  final Money? totalTax;
  final String? fulfillmentStatus;
  final String? financialStatus;
  final CustomerAddress? shippingAddress;
  final List<OrderLineItem> lineItems;

  CustomerOrder({
    required this.id,
    required this.name,
    required this.orderNumber,
    this.processedAt,
    required this.totalPrice,
    this.subtotalPrice,
    this.totalTax,
    this.fulfillmentStatus,
    this.financialStatus,
    this.shippingAddress,
    this.lineItems = const [],
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    final lineItems = <OrderLineItem>[];
    if (json['lineItems'] != null && 
        json['lineItems']['edges'] != null) {
      for (var edge in json['lineItems']['edges']) {
        lineItems.add(OrderLineItem.fromJson(edge['node']));
      }
    }

    return CustomerOrder(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      orderNumber: json['orderNumber'] ?? 0,
      processedAt: json['processedAt'] != null 
          ? DateTime.parse(json['processedAt']) 
          : null,
      totalPrice: Money.fromJson(json['totalPrice'] ?? {}),
      subtotalPrice: json['subtotalPrice'] != null
          ? Money.fromJson(json['subtotalPrice'])
          : null,
      totalTax: json['totalTax'] != null
          ? Money.fromJson(json['totalTax'])
          : null,
      fulfillmentStatus: json['fulfillmentStatus'],
      financialStatus: json['financialStatus'],
      shippingAddress: json['shippingAddress'] != null
          ? CustomerAddress.fromJson(json['shippingAddress'])
          : null,
      lineItems: lineItems,
    );
  }
}

/// Order Line Item Model
class OrderLineItem {
  final String id;
  final String title;
  final int quantity;
  final String variantId;
  final String variantTitle;
  final Money price;
  final String productId;
  final String productTitle;
  final String productHandle;
  final String? productImageUrl;

  OrderLineItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.variantId,
    required this.variantTitle,
    required this.price,
    required this.productId,
    required this.productTitle,
    required this.productHandle,
    this.productImageUrl,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    final variant = json['variant'] ?? {};
    final product = variant['product'] ?? {};
    final featuredImage = product['featuredImage'];

    return OrderLineItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      quantity: json['quantity'] ?? 0,
      variantId: variant['id'] ?? '',
      variantTitle: variant['title'] ?? '',
      price: Money.fromJson(variant['price'] ?? {}),
      productId: product['id'] ?? '',
      productTitle: product['title'] ?? '',
      productHandle: product['handle'] ?? '',
      productImageUrl: featuredImage?['url'],
    );
  }
}

/// Money Model (re-exported from product_model)
class Money {
  final String amount;
  final String currencyCode;

  Money({required this.amount, required this.currencyCode});

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      amount: json['amount'] ?? '0.0',
      currencyCode: json['currencyCode'] ?? 'USD',
    );
  }
}

