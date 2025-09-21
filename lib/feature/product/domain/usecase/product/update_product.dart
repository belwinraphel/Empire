// import 'package:dartz/dartz.dart';
// import 'package:empire/core/utilis/failure.dart';
// import 'package:empire/feature/product/domain/enities/product_entities.dart';
// import 'package:empire/feature/product/domain/repository/product_repository.dart';

// class UpdateProduct {
//   final ProductRepository repository;

//   UpdateProduct(this.repository);

//   Future<Either<Failures, void>> call({
//     required ProductEntity product,
//     required String subcategoryId,
//     required String mainCategoryId,
//   }) async {
//     return await repository.updateProduct(
//       product: product,
//       subcategoryId: subcategoryId,
//       mainCategoryId: mainCategoryId,
//     );
//   }
// }