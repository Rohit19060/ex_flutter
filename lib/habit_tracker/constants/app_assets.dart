import 'package:flutter_svg/flutter_svg.dart';

// system UI
const String check = 'assets/check.svg',
    plus = 'assets/plus.svg',
    threeDots = 'assets/three-dots.svg',
    delete = 'assets/delete.svg',
    navigationClose = 'assets/navigation-close.svg',
    navigationBack = 'assets/navigation-back.svg';

// tasks
const String basketball = 'assets/basketball-ball.svg',
    beer = 'assets/beer.svg',
    bike = 'assets/bike.svg',
    book = 'assets/book.svg',
    carrot = 'assets/carrot.svg',
    chef = 'assets/chef.svg',
    dentalFloss = 'assets/dental-floss.svg',
    dog = 'assets/dog.svg',
    dumBell = 'assets/dumbell.svg',
    guitar = 'assets/guitar.svg',
    homework = 'assets/homework.svg',
    html = 'assets/html-coding.svg',
    karate = 'assets/karate.svg',
    mask = 'assets/mask.svg',
    meditation = 'assets/meditation.svg',
    painting = 'assets/paint-board-and-brush.svg',
    phone = 'assets/phone.svg',
    pushups = 'assets/pushups-man.svg',
    rest = 'assets/rest.svg',
    run = 'assets/run.svg',
    smoking = 'assets/smoking.svg',
    stretching = 'assets/stretching-exercises.svg',
    sun = 'assets/sun.svg',
    swimmer = 'assets/swimmer.svg',
    toothbrush = 'assets/toothbrush.svg',
    vitamins = 'assets/vitamins.svg',
    washHands = 'assets/wash-hands.svg',
    water = 'assets/water.svg';

const allTaskIcons = [
  basketball,
  beer,
  bike,
  book,
  carrot,
  chef,
  dentalFloss,
  dog,
  dumBell,
  guitar,
  homework,
  html,
  karate,
  mask,
  meditation,
  painting,
  phone,
  pushups,
  rest,
  run,
  smoking,
  stretching,
  sun,
  swimmer,
  toothbrush,
  vitamins,
  washHands,
  water,
];

Future<void> preloadSVGs() async {
  final assets = [
    // system UI
    check,
    plus,
    threeDots,
    delete,
    navigationClose,
    navigationBack,
    // tasks
    ...allTaskIcons,
  ];
  for (final asset in assets) {
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, asset),
      null,
    );
  }
}
