import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required int id,
    required int postId,
    required String name,
    required String email,
    required String body,
  }) : super(
          id: id,
          postId: postId,
          name: name,
          email: email,
          body: body,
        );

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['postId'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'name': name,
      'email': email,
      'body': body,
    };
  }
} 