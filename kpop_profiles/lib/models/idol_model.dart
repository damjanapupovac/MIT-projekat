import 'package:image_picker/image_picker.dart';
import 'package:kpop_profiles/models/comment_model.dart';

class IdolModel {
  String id;
  String name;
  String birthday;
  XFile? pickedImage;
  String? imageUrl;  
  bool isFavorite;
  List<CommentModel> comments;

  IdolModel({
    required this.id,
    this.name = '',
    this.birthday = '',
    this.pickedImage,
    this.imageUrl,
    this.isFavorite = false,
    this.comments = const [],
  });
}