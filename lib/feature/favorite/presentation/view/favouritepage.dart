import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/favorite/domain/usecase/add_favorites_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/get_favourite_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/remove_favorites_usecase.dart';
import 'package:empire/feature/favorite/presentation/bloc/favorite.dart';
import 'package:empire/feature/favorite/presentation/bloc/fetingfavourite.dart';
import 'package:empire/feature/product/presentation/views/sucategoryPage/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoRs.background,
        centerTitle: true,
        title: const Text('Favorite Page'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FavoritesBloc(
              repository: sl<FavoritesRepository>(),
              getFavoritesStreamUseCase: sl<GetFavoritesStreamUseCase>(),
              addFavoriteUseCase: sl<AddFavoriteUseCase>(),
              removeFavoriteUseCase: sl<RemoveFavoriteUseCase>(),
            )..add(LoadFavorites()),
          ),
          BlocProvider(
            create: (context) => FetchingFavoriteBloc(sl<FavoritesRepository>())
              ..add(LoadFetchingFavorites()),
          ),
        ],
        child: BlocListener<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is FavoritesLoaded) {
              context.read<FetchingFavoriteBloc>().add(LoadFetchingFavorites());
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<FetchingFavoriteBloc, FetchingFavoriteState>(
                  builder: (context, fetchState) {
                    if (fetchState is FetchingFavoriteLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (fetchState is FetchingFavoriteError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 64, color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(fetchState.message),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<FetchingFavoriteBloc>()
                                    .add(LoadFetchingFavorites());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (fetchState is FetchingFavoriteLoaded) {
                      if (fetchState.products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              const Text(
                                'No Favorite Products',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.60,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: fetchState.products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: fetchState.products[index],
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
