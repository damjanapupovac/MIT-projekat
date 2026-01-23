import 'package:kpop_profiles/models/comment_model.dart';
import 'package:kpop_profiles/models/idol_model.dart';

class GroupModel {
  String id;
  String name;
  String imageUrl;
  List<IdolModel> idols;
  List<CommentModel> comments;

  GroupModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.idols,
    this.comments = const [],
  });
}