final List<Profile> demoProfiles = [
  Profile(photos: [
    'assets/images/photo_1.jpg',
    'assets/images/photo_2.jpg',
    'assets/images/photo_3.jpg',
  ], name: 'Rohit Special', bio: 'This is the person you want!'),
  Profile(photos: [
    'assets/images/photo_4.jpg',
    'assets/images/photo_3.jpg',
    'assets/images/photo_2.jpg',
    'assets/images/photo_1.jpg',
  ], name: 'Super ROhit Person', bio: 'You better swipe left...'),
  Profile(photos: [
    'assets/images/photo_2.jpg',
    'assets/images/photo_3.jpg',
    'assets/images/photo_4.jpg',
    'assets/images/photo_1.jpg',
  ], name: 'Dhoni', bio: 'You better swipe left...'),
  Profile(photos: [
    'assets/images/photo_3.jpg',
    'assets/images/photo_4.jpg',
    'assets/images/photo_1.jpg',
  ], name: 'Virat', bio: 'You better swipe left...'),
  Profile(photos: [
    'assets/images/photo_4.jpg',
    'assets/images/photo_1.jpg',
  ], name: 'Gross Person', bio: 'You better swipe left...'),
];

class Profile {
  Profile({
    required this.photos,
    required this.name,
    required this.bio,
  });
  final List<String> photos;
  final String name;
  final String bio;
}
