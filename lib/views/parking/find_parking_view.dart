import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/find_parking_viewmodel.dart';
import 'parking_detail_view.dart';

class FindParkingView extends StatefulWidget {
  const FindParkingView({super.key});

  @override
  State<FindParkingView> createState() => _FindParkingViewState();
}

class _FindParkingViewState extends State<FindParkingView> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<FindParkingViewModel>();
      vm.getUserLocation(context).then((_) {
        if (vm.userLocation != null && mounted) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _mapController.move(vm.userLocation!, 15.5);
          });
        }
        if (vm.locationError != null && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(vm.locationError!)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FindParkingViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Find Parking',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF0A2540),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(33.6844, 73.0479),
                  initialZoom: 14.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.smartparkify.app',
                  ),
                  MarkerLayer(
                    markers: [
                      if (vm.userLocation != null)
                        Marker(
                          point: vm.userLocation!,
                          width: 35,
                          height: 35,
                          child: const Icon(
                            Icons.my_location,
                            color: Color(0xFF2196F3),
                            size: 35,
                          ),
                        ),
                      ...vm.sortedSpots.map((spot) {
                        return Marker(
                          point: spot.location,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.local_parking,
                            color: spot.isAvailable ? Colors.green : Colors.red,
                            size: 40,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),

              // Bottom Sheet
              DraggableScrollableSheet(
                initialChildSize: 0.42,
                minChildSize: 0.35,
                maxChildSize: 0.85,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Nearby Parking',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Sort by: Distance',
                                style: TextStyle(
                                  color: Color(0xFF00BFA5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: vm.sortedSpots.length,
                            itemBuilder: (context, index) {
                              final spot = vm.sortedSpots[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: spot.isAvailable
                                          ? Colors.green.withValues(alpha: 0.15)
                                          : Colors.red.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.local_parking,
                                      color: spot.isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                  title: Text(
                                    spot.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            spot.distance,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        spot.isAvailable
                                            ? '${spot.available}/${spot.total} Available'
                                            : 'Occupied (0/${spot.total})',
                                        style: TextStyle(
                                          color: spot.isAvailable
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    spot.price,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ParkingDetailView(
                                          name: spot.name,
                                          distance:
                                              double.tryParse(
                                                spot.distance.split(' ')[0],
                                              ) ??
                                              0.0,
                                          available: spot.available,
                                          total: spot.total,
                                          price: spot.price,
                                          isAvailable: spot.isAvailable,
                                          location: spot.location,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // GPS Button
              Positioned(
                bottom: 180,
                right: 20,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => vm.getUserLocation(context),
                  backgroundColor: const Color(0xFF00BFA5),
                  child: vm.loadingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 24,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
