import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/address/presentation/bloc/address.dart';
import 'package:empire/feature/address/presentation/bloc/map_bloc.dart';
import 'package:empire/feature/address/presentation/view/map_widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AddressView();
  }
}

class AddressView extends StatelessWidget {
  String? isSlected;
  AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoRs.addresBackgroundcolor,
      appBar: AppBar(
        title: const Text('Address Management'),
        backgroundColor: ColoRs.addresBackgroundcolor,
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AddressError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is SelectedAddress) {
            isSlected = state.id;
          }
          if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MapConfirmPage()),
                  ),
                  child: const Text('Add Address'),
                ),
              );
            }
            final selected = state.selectedAddress;
            return Column(
              children: [
                if (selected != null) ...[
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(selected.label),
                    subtitle: Text(selected.fullAddress),
                    trailing: const Icon(Icons.check),
                  ),
                ],
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.01,
                      );
                    },
                    padding: const EdgeInsets.all(14),
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final address = state.addresses[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [ColoRs.white, ColoRs.white],
                            end: Alignment(0.0, -5),
                            begin: Alignment(0.0, -5),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: ColoRs.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.sizeOf(context).width * 0.10,
                              child: const Icon(
                                Icons.home,
                                color: ColoRs.background,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.03,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.74,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.label,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    address.fullAddress,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColoRs.buttoncolor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => sl<MapBloc>(),
                            child: const MapConfirmPage(),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Add New Address',
                      style: TextStyle(color: ColoRs.white),
                    ),
                  ),
                ),
              ],
            );
          }
          context.read<AddressBloc>().add(LoadAddresses());
          return const SizedBox();
        },
      ),
    );
  }
}
