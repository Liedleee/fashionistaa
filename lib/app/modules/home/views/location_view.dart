import 'package:fashionista/app/modules/home/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationView extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Pengguna'),
      ),
      body: Obx(() {
        // Cek apakah data posisi pengguna sudah ada.
        if (locationController.currentPosition.value == null ||
            locationController.initialPosition.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          // Jika data lokasi tersedia, tampilkan informasi dan peta.
          Position position = locationController.currentPosition.value!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Koordinat Lokasi Anda: \nLatitude: ${position.latitude} \nLongitude: ${position.longitude}',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              // Map widget bisa ditambahkan disini jika perlu
            ],
          );
        }
      }),
    );
  }

  Future<void> _checkPermission() async {
    // Cek izin lokasi
    PermissionStatus permission = await Permission.location.status;

    if (permission.isDenied) {
      // Jika izin belum diberikan, minta izin
      permission = await Permission.location.request();
    }

    if (permission.isGranted) {
      // Jika izin diberikan, lanjutkan untuk mengambil lokasi
      _getCurrentLocation();
    } else if (permission.isPermanentlyDenied) {
      // Jika izin ditolak permanen, arahkan pengguna ke pengaturan untuk memberikan izin
      openAppSettings();
    } else {
      // Tampilkan pesan atau penanganan lain jika izin tidak diberikan
      print("Izin lokasi tidak diberikan");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Pastikan permission sudah diberikan
      await _checkPermission();

      // Mengambil posisi saat ini setelah izin diberikan
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update posisi pada controller
      locationController.currentPosition.value = position;
      locationController.initialPosition.value =
          LatLng(position.latitude, position.longitude);
    } catch (e) {
      // Menangani error jika gagal mengambil lokasi
      print('Error mengambil lokasi: $e');
    }
  }
}
