// lib/presentation/pages/map_confirm_page.dart
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/address/presentation/bloc/address.dart';
import 'package:empire/feature/address/presentation/bloc/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapConfirmPage extends StatefulWidget {
  const MapConfirmPage({super.key});

  @override
  State<MapConfirmPage> createState() => _MapConfirmPageState();
}

class _MapConfirmPageState extends State<MapConfirmPage> {
  GoogleMapController? _mapController;
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(19.0760, 72.8777),
    zoom: 16,
  );
  TextEditingController label = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(MapInitialized());
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    context.read<MapBloc>().add(MapCameraMoved(position.target));
  }

  void _onCameraIdle() {
    final state = context.read<MapBloc>().state;
    context
        .read<MapBloc>()
        .add(AddressFromCoordinatesRequested(state.pinPosition));
  }

  Future<void> _goToCurrentLocation() async {
    context.read<MapBloc>().add(CurrentLocationRequested());

    Future.delayed(const Duration(milliseconds: 500), () {
      final state = context.read<MapBloc>().state;
      if (state.currentPosition != null && _mapController != null) {
        final target = LatLng(
          state.currentPosition!.latitude,
          state.currentPosition!.longitude,
        );
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 17.5),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text('Confirm map pin location'),
        ),
        body: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialCamera,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  zoomGesturesEnabled: true,
                  padding: const EdgeInsets.only(bottom: 280, top: 90),
                  minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
                  cameraTargetBounds: CameraTargetBounds.unbounded,
                ),

                // Center pin with bubble
                const Positioned(
                  left: 20,
                  right: 20,
                  bottom: 570,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MapBubble(
                          color: ColoRs.dark,
                          text1: 'Your order will be delivered here',
                          text2: 'Move pin to your exact location',
                        ),
                        SizedBox(height: 6),
                        _MapPin(),
                      ],
                    ),
                  ),
                ),

                // Current location button
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 340,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF18A957), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF18A957),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed:
                          state.isLoadingLocation ? null : _goToCurrentLocation,
                      icon: state.isLoadingLocation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF18A957)),
                              ),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(
                        state.isLoadingLocation
                            ? 'Getting location...'
                            : 'Go to current location',
                      ),
                    ),
                  ),
                ),

                // Bottom sheet
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MapBottomSheet(
                    pin: state.pinPosition,
                    distanceKm: state.distanceKm,
                    addressLine1: state.addressLine1,
                    addressLine2: state.addressLine2,
                    isLoadingAddress: state.isLoadingAddress,
                    labelcontroller: label,
                    green: ColoRs.green,
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}

class MapBubble extends StatelessWidget {
  final Color color;
  final String text1;
  final String text2;

  const MapBubble({
    super.key,
    required this.color,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text2,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        // Pointer triangle
        CustomPaint(
          painter: TrianglePainter(color),
          size: const Size(18, 10),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  const TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) =>
      color != oldDelegate.color;
}

class _MapPin extends StatelessWidget {
  const _MapPin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: 18,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF2F80ED).withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}

class MapBottomSheet extends StatelessWidget {
  final Color green;
  final double? distanceKm;
  final LatLng pin;
  final String addressLine1;
  final String addressLine2;
  final bool isLoadingAddress;

  final TextEditingController? labelcontroller;
  MapBottomSheet({
    super.key,
    required this.labelcontroller,
    required this.green,
    required this.distanceKm,
    required this.pin,
    required this.addressLine1,
    required this.addressLine2,
    required this.isLoadingAddress,
  });
  final GlobalKey<FormState> formKeylabel = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(20);

    final warning = distanceKm == null
        ? 'Pin location distance unavailable'
        : distanceKm! > 0.2
            ? 'Pin location is ${distanceKm!.toStringAsFixed(1)}km away - this seems far!'
            : '';

    return Material(
      elevation: 20,
      borderRadius: const BorderRadius.only(topLeft: radius, topRight: radius),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          ),
          child: Form(
            key: formKeylabel,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Text(
                      'Delivering your order to',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE7ECF0)),
                  ),
                  child: Row(
                    children: [
                      const _MapPin(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isLoadingAddress
                                ? const SizedBox(
                                    height: 16,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Color(0xFFE7ECF0),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF18A957)),
                                    ),
                                  )
                                : Text(
                                    addressLine1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            const SizedBox(height: 2),
                            Text(
                              addressLine2,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                warning,
                                style: TextStyle(
                                  color: distanceKm != null && distanceKm! > 5
                                      ? const Color(0xFFD32F2F)
                                      : ColoRs.warning,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          side: const BorderSide(color: Color(0xFFE0E6EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: Colors.green,
                          backgroundColor: Colors.white,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {},
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    return Validators.validateStrting(
                        value ?? "", labelcontroller!.text);
                  },
                  controller: labelcontroller,
                  decoration: const InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: 10.0,
                      ),
                      hint: Text('Label'),
                      fillColor: Color(0xFFE7ECF0),
                      labelStyle: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: Fonts.raleway),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                // Warning line

                const SizedBox(height: 14),

                // Primary CTA
                BlocListener<AddressBloc, AddressState>(
                  listener: (context, state) {
                    if (state is AddressLoaded) {
                      Navigator.pop(context);
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const AddressSelectionScreen();
                      //     },
                      //   ),
                      //   (route) => false,
                      // );
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        if (formKeylabel.currentState!.validate()) {
                          context.read<AddressBloc>().add(AddAddress(
                              MainAddress(
                                  id: '',
                                  label: labelcontroller!.text,
                                  fullAddress: addressLine1 + addressLine2,
                                  latitude: pin.latitude,
                                  longitude: pin.longitude)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Give label')));
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add  address '),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
