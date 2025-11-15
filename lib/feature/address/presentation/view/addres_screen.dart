import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/address/presentation/bloc/address.dart';
import 'package:empire/feature/address/presentation/view/map_widget.dart';
import 'package:empire/feature/address/presentation/view/widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<AddressBloc>(context), child: AddressView());
  }
}

class AddressView extends StatelessWidget {
  String? isSlected;
  AddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoRs.addresBackgroundcolor,
      appBar: appBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AddressBloc>().add(LoadAddresses());
        },
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AddressError) {
              return Center(child: Text('Error: //${state.message}'));
            }
            if (state is SelectedAddress) {
              isSlected = state.id;
            }
            if (state is AddressLoaded) {
              if (state.addresses.isEmpty) {
                return const EmptyAddress();
              }
              final selected = state.selectedAddress;
              return BlocProvider.value(
                value: BlocProvider.of<AddressBloc>(context),
                child: addressSection(selected, context, state),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Column addressSection(
      MainAddress? selected, BuildContext context, AddressLoaded state) {
    return Column(
      children: [
        if (selected != null) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: ColoRs.buttoncolor,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.03,
                ),
                Flexible(
                  flex: 5,
                  child: Text(
                    'Default Address: ${selected.fullAddress}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.01,
              );
            },
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
            itemCount: state.addresses.length,
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return GestureDetector(
                onTap: () {
                  context
                      .read<AddressBloc>()
                      .add(SelectAddress(id: address.id, mainAddress: address));
                },
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.09,
                  width: MediaQuery.sizeOf(context).width * 0.5,
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
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              address.fullAddress,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: ColoRs.buttoncolor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                      value: context.read<AddressBloc>(),
                      child: const MapConfirmPage()),
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

  AppBar appBar() {
    return AppBar(
      title: const Text('Address Selection',
          style: TextStyle(
              color: ColoRs.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: Fonts.raleway)),
      backgroundColor: ColoRs.addresBackgroundcolor,
    );
  }
}

class EmptyAddress extends StatelessWidget {
  const EmptyAddress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: ColoRs.white,
              textStyle: const TextStyle(
                fontSize: 15,
              ),
              backgroundColor: ColoRs.buttoncolor),
          onPressed: () {
            BlocProvider.value(
                value: BlocProvider.of<AddressBloc>(context),
                child: const MapConfirmPage());

            //   Navigator.of(context).push(
            //   MaterialPageRoute(builder: (_) {
            //     return BlocProvider.value(
            //         value: BlocProvider.of<AddressBloc>(context),
            //         child: const MapConfirmPage());
            //   }),
            // );
          },
          child: const Text('Add Address'),
        ),
      ),
    );
  }
}
