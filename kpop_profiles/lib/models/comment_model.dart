class CommentModel {
  final String username;
  final String text;
  int likes;

  CommentModel({
    required this.username,
    required this.text,
    this.likes = 0,
  });
}