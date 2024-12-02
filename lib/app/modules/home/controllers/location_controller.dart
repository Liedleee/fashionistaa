import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  var currentPosition = Rxn<Position>(); // Menggunakan Rxn untuk nullable
  var initialPosition = Rxn<LatLng>(); // Koordinat awal peta

  // Mendapatkan lokasi pengguna
  Future<void> getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition.value = position;
      initialPosition.value = LatLng(position.latitude, position.longitude);
    } else {
      print("Location permission denied");
    }
  }
}
