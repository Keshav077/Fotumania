import 'package:flutter/material.dart';
import 'package:fotumania/models/service_data.dart';

class ServiceProvider with ChangeNotifier {
  List<ServiceData> _servicesList = [
    ServiceData(
      serviceName: "PHOTO SHOOT",
      serviceContent:
          "With our finest focus capture your flattering portrait sight.",
      serviceId: "001",
      icon: Icons.camera_sharp,
      widthRatio: 0.6,
    ),
    ServiceData(
      serviceName: "PACKAGES",
      serviceContent: "Packages Content",
      serviceId: "002",
      icon: Icons.videocam_rounded,
      widthRatio: 0.98,
    ),
    // ServiceData(
    //   serviceName: "PRINTS",
    //   serviceContent: "Prints Content",
    //   serviceId: "003",
    //   icon: Icons.print_rounded,
    //   widthRatio: 0.6,
    // ),
    // ServiceData(
    //   serviceName: "PRODUCTS",
    //   serviceContent: "Products Content",
    //   serviceId: "004",
    //   icon: Icons.filter_frames_rounded,
    //   widthRatio: 0.98,
    // ),
    // ServiceData(
    //   serviceName: "ARTS",
    //   serviceContent: "Arts Content",
    //   serviceId: "005",
    //   icon: Icons.palette_rounded,
    //   widthRatio: 0.6,
    // ),
  ];

  int getServiceIndex(String id) {
    return servicesList.indexWhere((element) => element.serviceId == id);
  }

  List<ServiceData> get servicesList {
    return [..._servicesList];
  }

  addService(ServiceData service) {
    _servicesList.add(service);
  }
}
