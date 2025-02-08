class Post {
  String id;
  String text;
  DateTime createdAt;
  DateTime? updatedAt;

  Post({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
});
}