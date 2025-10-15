import 'package:empire/feature/address/presentation/bloc/address.dart';
import 'package:empire/feature/address/presentation/view/widget.dart';

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
      appBar: AppBar(title: const Text('Address Management')),
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
                  child: ListView.builder(
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final address = state.addresses[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(address.label),
                        subtitle: Text(address.fullAddress),
                        trailing: isSlected == state.addresses[index].id
                            ? const Icon(Icons.check, color: Colors.green)
                            : IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => context
                                    .read<AddressBloc>()
                                    .add(DeleteAddress(address.id)),
                              ),
                        onTap: () => context.read<AddressBloc>().add(
                            SelectAddress(state.addresses[index],
                                state.addresses[index].id)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const MapConfirmPage()),
                      );
                    },
                    child: const Text('Add New Address'),
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
