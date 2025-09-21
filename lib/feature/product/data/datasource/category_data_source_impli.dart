 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
 
import 'package:empire/feature/product/data/datasource/category_data_source.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';

import 'package:logger/logger.dart';

class CategoryDataSourceImpl implements CategoryDataSource {
  CategoryDataSourceImpl(this.logger);
  final Logger logger;

  @override
  Future<Either<List<CategoryEntities>, Failures>> getCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('category')
          .get();

      final categories = snapshot.docs.map((doc) {
        return CategoryEntities(
          description: doc['description'] ?? '',
          uid: doc.id,
          imageUrl: doc['imageurl'] ?? '',
          category: doc['name'] ?? '',
        );
      }).toList();

      return left(categories);
    } catch (e) {
      return right(Failures.server(e.toString()));
    }
  }

  
 

  @override
  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(
    String id,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(id)
          .collection('subcategory')
          .get();

      final categories = snapshot.docs.map((doc) {
        return CategoryEntities(
          description: doc['description'] ?? '',
          uid: doc.id,
          imageUrl: doc['imageurl'] ?? '',
          category: doc['Subcategory'] ?? '',
        );
      }).toList();

      return right(categories);
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }
}
