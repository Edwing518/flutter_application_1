import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _position;
  bool _loading = false;
  String? _error;

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _error = 'La ubicación está desactivada';
        _loading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _error = 'Permiso denegado';
          _loading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _error = 'Permiso denegado permanentemente';
        _loading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _position = position;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_position != null)
              Text(
                'Ubicación: \nLat: ${_position!.latitude}, Lon: ${_position!.longitude}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            if (_loading) const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Obtener ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}
