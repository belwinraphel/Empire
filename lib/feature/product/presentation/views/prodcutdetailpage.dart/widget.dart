import 'package:empire/feature/cart/domain/entities/variant_snapshot.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class Titlesnew extends StatelessWidget {
  final String nametitle;

  const Titlesnew({super.key, required this.nametitle});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 150),
      child: SlideAnimation(
        horizontalOffset: -50.0,
        child: FadeInAnimation(
          child: Text(
            nametitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildVariantsSection(List<Variant> variants, ProductEntity product) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: variants.length,
    itemBuilder: (context, index) {
      final variant = variants[index];
      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 150),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.white70,
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: variant.image == null
                        ? const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.black54,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              variant.image!,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  // Variant Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          variant.name,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: \$${variant.salePrice.toStringAsFixed(2)}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Sale price: ${variant.regularPrice}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity: ${variant.quantity}',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (product.productDocId != null) {
                                  final varientSnapshot = VariantSnapshot(
                                      name: variant.name,
                                      price: int.tryParse(
                                              variant.salePrice.toString()) ??
                                          0,
                                      weightGrams: int.tryParse(
                                              product.weight.toString()) ??
                                          0,
                                      sku: product.sku,
                                      stock: product.quantities);
                                  context.read<CartBloc>().add(AddToCart(
                                      product.productDocId!, variant.name, 1,
                                      snapshot: varientSnapshot));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Added to cart')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'please select the varients')));
                                }
                              },
                              child: const Text('Add to Cart'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildDetailRow(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF4B5563),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: GoogleFonts.roboto(
          fontSize: 14,
          color: const Color(0xFF111827),
        ),
      ),
    ],
  );
}
