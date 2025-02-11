// import 'dart:async';
// import 'dart:developer' as dev;

// import 'package:get/get.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// class CompassController {
//   Rx<int?> degree = Rx<int?>(null);
//   late StreamSubscription compassSubscription;

//   void startListing() {
//     compassSubscription =
//         magnetometerEventStream(samplingPeriod: SensorInterval.uiInterval)
//             .listen(
//       (MagnetometerEvent event) {
//         // calculate angle
//       },
//       onError: (error) {
//         dev.log(error.toString());
//       },
//       cancelOnError: true,
//     );
//   }

//   void stopListing() {
//     compassSubscription.cancel();
//   }

//   void getCurrentLocation() async {}
// }
