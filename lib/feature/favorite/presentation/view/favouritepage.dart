import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/favorite/domain/usecase/add_favorites_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/get_favourite_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/remove_favorites_usecase.dart';
import 'package:empire/feature/favorite/presentation/bloc/favorite.dart';
import 'package:empire/feature/favorite/presentation/bloc/fetingfavourite.dart';
import 'package:empire/feature/product/presentation/views/sucategoryPage/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favouritepage extends StatelessWidget {
  const Favouritepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  FetchingFavoriteBloc(sl<FavoritesRepository>())
                    ..add(LoadFetchingFavorites()),
            ),
            BlocProvider(
              create: (context) => FavoritesBloc(
                getFavoritesStreamUseCase: sl<GetFavoritesStreamUseCase>(),
                addFavoriteUseCase: sl<AddFavoriteUseCase>(),
                removeFavoriteUseCase: sl<RemoveFavoriteUseCase>(),
              )..add(LoadFavorites()),
            ),
          ],
          child: Column(
            children: [
              BlocBuilder<FetchingFavoriteBloc, FetchingFavoriteState>(
                builder: (context, state) {
                  if (state is FetchingFavoriteLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(
                        child: Text('No Favorite Product'),
                      );
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: state.products[index],
                            );
                          },
                        ),
                      ),
                    );
                  } else if (state is FetchingFavoriteError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
