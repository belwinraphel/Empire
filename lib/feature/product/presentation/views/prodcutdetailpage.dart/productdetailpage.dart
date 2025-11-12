import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/presentation/views/prodcutdetailpage.dart/widget.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;
  ProductDetailScreen({required this.product});
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedVariation = 'Pink';
  String selectedSize = 'M';
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFE6B800),
                                Color(0xFFFFD700),
                              ],
                            ),
                          ),
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: widget.product.images.first,
                              fit: BoxFit.fill,
                              placeholder: (context, url) {
                                return const CircularProgressIndicator();
                              },
                              // color: isActive ? Colors.white : null,
                              errorWidget: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: ColoRs.black,
                            )),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${widget.product.price}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.product.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          widget.product.category == 'Dress'
                              ? Row(
                                  children: [
                                    const Text(
                                      'Variations',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.pink[50],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Text(
                                        'Pink',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        'M',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        _buildVariantImage(
                                            'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=60&h=60&fit=crop'),
                                        const SizedBox(width: 8),
                                        _buildVariantImage(
                                            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=60&h=60&fit=crop'),
                                        const SizedBox(width: 8),
                                        _buildVariantImage(
                                            'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=60&h=60&fit=crop'),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(height: 16),
                          const SizedBox(height: 32),
                          widget.product.category == 'Dress'
                              ? Column(
                                  children: [
                                    const Text(
                                      'Specifications',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildSpecRow('Material', 'Cotton 95%'),
                                    const SizedBox(height: 12),
                                    _buildSpecRow('Origin', 'EU'),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Size',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : widget.product.category == 'electronics'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        const Titlesnew(
                                            nametitle: 'Shipping Details'),
                                        const SizedBox(height: 16),
                                        buildDetailRow(
                                          'Weight (kg)',
                                          widget.product.weight
                                              .toStringAsFixed(2),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: buildDetailRow(
                                                'Length (cm)',
                                                widget.product.length
                                                    .toStringAsFixed(0),
                                              ),
                                            ),
                                            Expanded(
                                              child: buildDetailRow(
                                                'Width (cm)',
                                                widget.product.width
                                                    .toStringAsFixed(0),
                                              ),
                                            ),
                                            Expanded(
                                              child: buildDetailRow(
                                                'Height (cm)',
                                                widget.product.height
                                                    .toStringAsFixed(0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    )
                                  : const SizedBox(),
                          const SizedBox(),
                          const SizedBox(height: 12),
                          widget.product.category == 'Dress'
                              ? Row(
                                  children: [
                                    _buildSizeOption('S', false),
                                    const SizedBox(width: 12),
                                    _buildSizeOption('M', true),
                                    const SizedBox(width: 12),
                                    _buildSizeOption('L', false),
                                    const SizedBox(width: 12),
                                    _buildSizeOption('XL', false),
                                  ],
                                )
                              : const SizedBox(),
                          if (widget.product.variantDetails.isNotEmpty) ...[
                            const Titlesnew(nametitle: 'Variants'),
                            const SizedBox(height: 16),
                            buildVariantsSection(widget.product.variantDetails),
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                 
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Proceeding to checkout!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Buy now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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

  Widget _buildVariantImage(String imageUrl) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
