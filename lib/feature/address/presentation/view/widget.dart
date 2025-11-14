import 'dart:async';

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
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapConfirmPage extends StatefulWidget {
  const MapConfirmPage({super.key});

  @override
  State<MapConfirmPage> createState() => _MapConfirmPageState();
}

class _MapConfirmPageState extends State<MapConfirmPage> {
  GoogleMapController? _mapController;

  static const LatLng _initialTarget = LatLng(19.0760, 72.8777);
  static const CameraPosition _initialCamera =
      CameraPosition(target: _initialTarget, zoom: 16);
  TextEditingController label = TextEditingController();
  LatLng _pin = _initialTarget;
  Position? _myPosition;
  double? _distanceKm;
  bool _isLoadingLocation = false;
  Timer? _debounceTimer;
  String _addressLine1 = 'Pandharpur Village';
  String _addressLine2 = 'Chhatrapati Sambhajinagar';
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _ensureLocationPermission();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController?.dispose();
    label.dispose();

    super.dispose();
  }

  Future<void> _ensureLocationPermission() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }
      _goToCurrentLocation();
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _myPosition = pos;
          _distanceKm = _computeDistanceKm(_pin, pos);
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  double _computeDistanceKm(LatLng a, Position b) {
    final meters = Geolocator.distanceBetween(
        a.latitude, a.longitude, b.latitude, b.longitude);
    return meters / 1000.0;
  }

  Future<void> _goToCurrentLocation() async {
    if (_isLoadingLocation) return;

    if (_myPosition == null) {
      await _ensureLocationPermission();
    }

    if (_myPosition == null || _mapController == null) return;

    final target = LatLng(_myPosition!.latitude, _myPosition!.longitude);
    await _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: 17.5),
    ));

    if (mounted) {
      setState(() {
        _pin = target;
        _distanceKm = 0.0;
      });
    }
  }

  void _onCameraMove(CameraPosition p) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted && _myPosition != null) {
        setState(() {
          _pin = p.target;
          _distanceKm = _computeDistanceKm(_pin, _myPosition!);
        });
      }
    });
  }

  void _onCameraIdle() {
    if (mounted && _myPosition != null) {
      setState(() {
        _distanceKm = _computeDistanceKm(_pin, _myPosition!);
      });
    }
    // Fetch address after camera stops
    _getAddressFromCoordinates(_pin);
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    if (_isLoadingAddress) return;

    setState(() => _isLoadingAddress = true);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;

        // Build address lines
        String line1 = '';
        String line2 = '';

        if (place.street != null && place.street!.isNotEmpty) {
          line1 = place.street!;
        } else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          line1 = place.subLocality!;
        } else if (place.locality != null && place.locality!.isNotEmpty) {
          line1 = place.locality!;
        } else if (place.name != null && place.name!.isNotEmpty) {
          line1 = place.name!;
        } else {
          line1 = 'Location Selected';
        }

        List<String> line2Parts = [];
        if (place.locality != null &&
            place.locality!.isNotEmpty &&
            place.locality != line1) {
          line2Parts.add(place.locality!);
        }
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          line2Parts.add(place.subAdministrativeArea!);
        } else if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          line2Parts.add(place.administrativeArea!);
        }

        line2 = line2Parts.join(', ');
        if (line2.isEmpty) {
          line2 = place.country ?? 'India';
        }

        setState(() {
          _addressLine1 = line1;
          _addressLine2 = line2;
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      if (mounted) {
        setState(() {
          _addressLine1 = 'Unable to get address';
          _addressLine2 = 'Please try again';
          _isLoadingAddress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF18A957);
    const dark = Color(0xFF2C2C2C);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MapBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AddressBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text('Confirm map pin location'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCamera,
              onMapCreated: (c) => _mapController = c,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              padding: const EdgeInsets.only(bottom: 280, top: 90),
              minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
              liteModeEnabled: false,
            ),
            const Positioned(
              left: 20,
              right: 20,
              bottom: 570,
              child: IgnorePointer(
                ignoring: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Bubble(
                      color: dark,
                      text1: 'Your order will be delivered here',
                      text2: 'Move pin to your exact location',
                    ),
                    SizedBox(height: 6),
                    _MapPin(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 340,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 80.0,
                  left: 80.0,
                ),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: green, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: green,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: _isLoadingLocation ? null : _goToCurrentLocation,
                  icon: _isLoadingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(green),
                          ),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(_isLoadingLocation
                      ? 'Getting location...'
                      : 'Go to current location'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomSheetPanel(
                labelcontroller: label,
                green: green,
                distanceKm: _distanceKm,
                pin: _pin,
                addressLine1: _addressLine1,
                addressLine2: _addressLine2,
                isLoadingAddress: _isLoadingAddress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final Color color;
  final String text1;
  final String text2;

  const _Bubble({
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
          painter: _TrianglePainter(color),
          size: const Size(18, 10),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter(this.color);

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
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
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

class _BottomSheetPanel extends StatelessWidget {
  final Color green;
  final double? distanceKm;
  final LatLng pin;
  final String addressLine1;
  final String addressLine2;
  final bool isLoadingAddress;

  final TextEditingController? labelcontroller;
  _BottomSheetPanel({
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
                // Title
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
            

                const SizedBox(height: 14),

         
                BlocListener<AddressBloc, AddressState>(
                  listener: (context, state) {
                    if (state is AddressAdded) {
                      Navigator.pop(context,);
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
