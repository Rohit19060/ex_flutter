class ProductItem {
  ProductItem({
    required this.uid,
    required this.image,
    required this.title,
    required this.amount,
  });
  final String image, title;
  final int amount, uid;
}

List<ProductItem> products = [
  ProductItem(
    uid: 1,
    title: 'PS5 Controller',
    amount: 75,
    image: 'assets/images/ps5.png',
  ),
  ProductItem(
    uid: 2,
    title: 'Drone',
    amount: 155,
    image: 'assets/images/drone.png',
  ),
  ProductItem(
    uid: 3,
    title: 'Beats Studio',
    amount: 230,
    image: 'assets/images/beats.png',
  ),
  ProductItem(
    uid: 4,
    title: 'Alexa',
    amount: 45,
    image: 'assets/images/alexa.png',
  ),
  ProductItem(
    uid: 5,
    title: 'Nintendo Switch',
    amount: 298,
    image: 'assets/images/switch.png',
  ),
  ProductItem(
    uid: 6,
    title: 'Apple Watch',
    amount: 165,
    image: 'assets/images/watch.png',
  ),
  ProductItem(
    uid: 7,
    title: 'Macbook',
    amount: 1950,
    image: 'assets/images/mac.png',
  ),
  ProductItem(
    uid: 8,
    title: 'Iphone',
    amount: 1200,
    image: 'assets/images/iphone.png',
  ),
];
