import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }
}
enum OTP {
success,
failes,
timout,
error,
unknownerror,
firebaserror,

}