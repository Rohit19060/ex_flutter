extension MapExtension on Map<String, String> {
  String? encodeQueryParameters() => entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);

  bool isOnlyAlpha() => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  bool isEmail() => RegExp(
          r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
      .hasMatch(this);

  bool isPhone() => RegExp(r'^[0-9]{10}$').hasMatch(this);

  bool isPassword() =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
          .hasMatch(this);

  String getDecimal() => double.parse(this).toStringAsFixed(0);

  String capitalizeAll() =>
      split(' ').map((word) => word.capitalize()).join(' ');

  String getGenderAvatar() {
    switch (this) {
      case 'Male':
        return 'https://raw.githubusercontent.com/TechMET-Solutions/Developer-Utilities/main/maleSquare.png';
      case 'Female':
        return 'https://raw.githubusercontent.com/TechMET-Solutions/Developer-Utilities/main/femaleSquare.png';
      default:
        return 'https://raw.githubusercontent.com/TechMET-Solutions/Developer-Utilities/main/other.png';
    }
  }
}

extension DoubleExtension on double {
  String toStringAsFixed(int fractionDigits) =>
      this.toStringAsFixed(fractionDigits);
}

extension IntExtension on int {
  double getDiscountPercent(int discountedPrice) =>
      ((this - discountedPrice) / this) * 100;
}
