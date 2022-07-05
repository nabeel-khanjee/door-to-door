import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class CenterBounds {
  Object centerBounds(path) {
    print(path);
  
    print({
      'lat': LatLngBounds.fromPoints(path).center.latitude,
      'lng': LatLngBounds.fromPoints(path).center.longitude
    });
    print('############');
    return {
      'lat': LatLngBounds.fromPoints(path).center.latitude,
      'lng': LatLngBounds.fromPoints(path).center.longitude
    };
  }
}
