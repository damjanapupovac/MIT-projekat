import 'package:flutter/material.dart';
import '../models/idol_model.dart';
import '../models/comment_model.dart';

class IdolProvider with ChangeNotifier {
  final List<IdolModel> _idols = [
    IdolModel(
      id: '101',
      name: 'Nayeon',
      birthday: '22.09.1995',
      isFavorite: false,
      comments: [
        CommentModel(username: 'Admin', text: 'Welcome to Nayeon\'s profile!')
      ],
    ),
  ];

  List<IdolModel> get idols => _idols;

  List<IdolModel> get favoriteIdols =>
      _idols.where((idol) => idol.isFavorite).toList();

  void toggleFavorite(String idolId) {
    final index = _idols.indexWhere((idol) => idol.id == idolId);
    if (index != -1) {
      _idols[index].isFavorite = !_idols[index].isFavorite;
      notifyListeners();
    }
  }
}