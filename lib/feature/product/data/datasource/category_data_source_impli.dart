import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';

import 'package:empire/feature/product/data/datasource/category_data_source.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:flutter/foundation.dart';

import 'package:logger/logger.dart';

class CategoryDataSourceImpl implements CategoryDataSource {
  final Logger logger;
  final FirebaseFirestore firestore;

  CategoryDataSourceImpl(
      {required this.logger, FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  @override
  Future<Either<List<CategoryEntities>, Failures>> getCategory() async {
    try {
      final snapshot = await firestore.collection('category').get();

      final docs = snapshot.docs.map((doc) {
        return {
          'uid': doc.id,
          'category': doc['name'] ?? '',
          'description': doc['description'] ?? '',
          'imageUrl': doc['imageurl'] ?? ''
        };
      }).toList();

      final categories = await compute(parseCategories, docs);

      return left(categories);
    } catch (e) {
      logger.e('Error fetching categories: $e');
      return right(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(
    String id,
  ) async {
    try {
      final snapshot = await firestore
          .collection('category')
          .doc(id)
          .collection('subcategory')
          .get();

      final docs = snapshot.docs.map((doc) {
        return {
          'uid': doc.id,
          'category': doc['Subcategory'] ?? '',
          'description': doc['description'] ?? '',
          'imageUrl': doc['imageurl'] ?? ''
        };
      }).toList();

      final categories = await compute(parseCategories, docs);

      return right(categories);
    } catch (e) {
      logger.e('Error fetching subcategories for $id: $e');
      return left(Failures.server(e.toString()));
    }
  }
}
