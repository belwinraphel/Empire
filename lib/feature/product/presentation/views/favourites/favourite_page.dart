import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: 1,
      name: "Aashirvaad Superior MP Atta (100% Atta, 0% Maida) (Godhithha)",
      weight: "5 kg",
      price: 310,
      mrp: 355,
      discount: "12% OFF",
      rating: 4.5,
      reviews: 8347,
      pricePerUnit: "₹6.20/100 g",
      deliveryTime: "10 MINS",
      isBestseller: false,
      imageUrl: "assets/atta1.png",
    ),
    Product(
      id: 2,
      name: "Aashirvaad Superior MP Atta - 1 kg (Godhittu)",
      weight: "1 kg",
      price: 72,
      mrp: 73,
      discount: null,
      rating: 4.5,
      reviews: 12959,
      pricePerUnit: "₹7.20/100 g",
      deliveryTime: "10 MINS",
      isBestseller: true,
      imageUrl: "assets/atta2.png",
    ),
    Product(
      id: 3,
      name:
          "Aashirvaad High Fibre Atta with Multigrains - 5 kg (Super Value Pack)",
      weight: "5 kg",
      price: 342,
      mrp: 401,
      discount: "14% OFF",
      rating: 4.5,
      reviews: 21700,
      pricePerUnit: null,
      deliveryTime: "10 MINS",
      isBestseller: true,
      imageUrl: "assets/atta3.png",
    ),
    Product(
      id: 4,
      name: "Aashirvaad Superior MP Atta",
      weight: "2 kg",
      price: 110,
      mrp: null,
      discount: null,
      rating: 5.0,
      reviews: 848,
      pricePerUnit: "₹5.50/100 g",
      deliveryTime: "10 MINS",
      isBestseller: false,
      imageUrl: "assets/atta4.png",
    ),
  ];

  final List<Category> categories = [
    Category("Atta", "assets/atta_icon.png", true),
    Category("Local Rice", "assets/rice_icon.png", false),
    Category("Rice", "assets/rice2_icon.png", false),
    Category("Dal", "assets/dal_icon.png", false),
    Category("Besan, Sooji & Maida", "assets/besan_icon.png", false),
    Category("Rajma, Chhole & Other Pulses", "assets/rajma_icon.png", false),
    Category("Millet & Other Flours", "assets/millet_icon.png", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Atta, Rice & Dal',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar with categories
          Container(
            width: 120,
            color: Colors.grey[50],
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        category.isSelected ? Colors.white : Colors.transparent,
                    border: category.isSelected
                        ? const Border(
                            left: BorderSide(color: Colors.green, width: 3))
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Icon(
                            _getCategoryIcon(category.name),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: category.isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: category.isSelected
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton("Filters", Icons.tune),
                        const SizedBox(width: 12),
                        _buildFilterButton("Sort", Icons.sort),
                        const SizedBox(width: 12),
                        _buildFilterButton("Brand", null),
                        const SizedBox(width: 12),
                        _buildFilterButton("Atta Type", null),
                      ],
                    ),
                  ),
                ),

                // Products grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.40,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.all(16),
      //   decoration: BoxDecoration(
      //     color: Colors.purple,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(12),
      //       topRight: Radius.circular(12),
      //     ),
      //   ),
      //   child: Row(
      //     children: [
      //       Container(
      //         padding: EdgeInsets.all(8),
      //         decoration: BoxDecoration(
      //           color: Colors.purple[700],
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //         child: Icon(Icons.local_movies, color: Colors.white),
      //       ),
      //       SizedBox(width: 12),
      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text(
      //               'Get a Movie Voucher worth ₹100',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.w600,
      //                 fontSize: 14,
      //               ),
      //             ),
      //             Text(
      //               'on orders above ₹199',
      //               style: TextStyle(
      //                 color: Colors.white70,
      //                 fontSize: 12,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.close, color: Colors.white),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildFilterButton(String text, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case "Atta":
        return Icons.grain;
      case "Local Rice":
      case "Rice":
        return Icons.rice_bowl;
      case "Dal":
        return Icons.circle;
      case "Besan, Sooji & Maida":
        return Icons.bakery_dining;
      case "Rajma, Chhole & Other Pulses":
        return Icons.eco;
      case "Millet & Other Flours":
        return Icons.grass;
      default:
        return Icons.category;
    }
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with badges
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Icon(
                    Icons.grain,
                    size: 60,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ),
              if (product.isBestseller)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Bestseller',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Product details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery time
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 12, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        product.deliveryTime,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Weight
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Text(
                      product.weight,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product name
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < product.rating.floor()
                              ? Icons.star
                              : index < product.rating
                                  ? Icons.star_half
                                  : Icons.star_border,
                          size: 12,
                          color: Colors.orange,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviews.toString()})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price section
                  Column(
                    children: [
                      if (product.discount != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            product.discount!,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      if (product.mrp != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          'MRP ₹${product.mrp}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (product.pricePerUnit != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.pricePerUnit!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  // Add button
                  Container(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String weight;
  final int price;
  final int? mrp;
  final String? discount;
  final double rating;
  final int reviews;
  final String? pricePerUnit;
  final String deliveryTime;
  final bool isBestseller;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    this.mrp,
    this.discount,
    required this.rating,
    required this.reviews,
    this.pricePerUnit,
    required this.deliveryTime,
    required this.isBestseller,
    required this.imageUrl,
  });
}

class Category {
  final String name;
  final String iconUrl;
  final bool isSelected;

  Category(this.name, this.iconUrl, this.isSelected);
}
