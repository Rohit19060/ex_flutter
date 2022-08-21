import 'package:flutter/cupertino.dart';

import 'profiles.dart';

class MatchEngine extends ChangeNotifier {
  MatchEngine({
    required List<DateMatch> matches,
  }) : _matches = matches {
    _currentMatchIndex = 0;
    _nextMatchIndex = 1;
  }
  final List<DateMatch> _matches;
  int _currentMatchIndex = 0;
  int _nextMatchIndex = 0;

  DateMatch get currentMatch => _matches[_currentMatchIndex];
  DateMatch get nextMatch => _matches[_nextMatchIndex];

  void cycleMatch() {
    if (currentMatch.decision != Decision.undecided) {
      currentMatch.reset();
      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex =
          _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;
      notifyListeners();
    }
  }
}

class DateMatch extends ChangeNotifier {
  DateMatch({required this.profile});
  final Profile profile;
  Decision decision = Decision.undecided;

  void like() {
    if (decision == Decision.undecided) {
      decision = Decision.like;
      notifyListeners();
    }
  }

  void nope() {
    if (decision == Decision.undecided) {
      decision = Decision.nope;
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.undecided) {
      decision = Decision.superLike;
      notifyListeners();
    }
  }

  void reset() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }
}

enum Decision { undecided, nope, like, superLike }
