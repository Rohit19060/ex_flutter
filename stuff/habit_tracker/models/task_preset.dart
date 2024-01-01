import '../constants/app_assets.dart';

class TaskPreset {
  const TaskPreset({required this.name, required this.iconName});
  final String name;
  final String iconName;

  @override
  String toString() => 'TaskPreset($name, $iconName)';

  static const List<TaskPreset> allPresets = [
    TaskPreset(name: 'Eat a Healthy Meal', iconName: carrot),
    TaskPreset(name: 'Walk the Dog', iconName: dog),
    TaskPreset(name: 'Do Some Coding', iconName: html),
    TaskPreset(name: 'Meditate', iconName: meditation),
    TaskPreset(name: 'Do 10 Pushups', iconName: pushups),
    TaskPreset(name: 'Sleep 8 Hours', iconName: rest),
    TaskPreset(name: 'Take Vitamins', iconName: vitamins),
    TaskPreset(name: 'Cycle to Work', iconName: bike),
    TaskPreset(name: 'Wash Your Hands', iconName: washHands),
    TaskPreset(name: 'Wear a Mask', iconName: mask),
    TaskPreset(name: 'Brush Your Teeth', iconName: toothbrush),
    TaskPreset(name: 'Floss Your Teeth', iconName: dentalFloss),
    TaskPreset(name: 'Drink Water', iconName: water),
    TaskPreset(name: 'Practice Instrument', iconName: guitar),
    TaskPreset(name: 'Read for 10 Minutes', iconName: book),
    TaskPreset(name: "Don't Smoke", iconName: smoking),
    TaskPreset(name: "Don't Drink Alcohol", iconName: beer),
    TaskPreset(name: 'Decrease Screen Time', iconName: phone),
    TaskPreset(name: 'Do a Workout', iconName: dumBell),
    TaskPreset(name: 'Do Karate', iconName: karate),
    TaskPreset(name: 'Go Running', iconName: run),
    TaskPreset(name: 'Go Swimming', iconName: swimmer),
    TaskPreset(name: 'Do Some Stretches', iconName: stretching),
    TaskPreset(name: 'Play Sports', iconName: basketball),
    TaskPreset(name: 'Spend Time Outside', iconName: sun),
  ];
}
