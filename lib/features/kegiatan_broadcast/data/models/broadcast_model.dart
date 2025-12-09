class BroadcastModel {
  final int id;
  final String title;
  final String content;
  final String senderName;
  final String createdAt;
  final String? imageLink;
  final String? documentLink;

  BroadcastModel({
    required this.id,
    required this.title,
    required this.content,
    required this.senderName,
    required this.createdAt,
    this.imageLink,
    this.documentLink,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) {
    return BroadcastModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      senderName: json['sender_name'],
      createdAt: json['created_at'],
      imageLink: json['image_link'],
      documentLink: json['document_link'],
    );
  }
}
