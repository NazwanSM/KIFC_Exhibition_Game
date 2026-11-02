// Derived from Welcome_Wave/Review/APPROVED_CAMERA_SETUP.json.
// Blender Z-up -> glTF Y-up: (x, y, z) -> (x, z, -y).
// Source camera roll is below 0.00003 degrees; orbit uses world Y-up.
class ApprovedMascotCamera {
  static const name = 'CAM-UserApprovedView';
  static const aspect = 2100 / 1009;
  static const orbit = '-0.3977650321286112rad 1.4829576043125434rad 3.5m';
  static const target =
      '0.14820505678653717m 0.9663659296929836m -0.07670897245407104m';
  static const fieldOfView = '0.6661117646972256rad';
}
