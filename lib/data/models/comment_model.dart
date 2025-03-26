import 'package:flutter_tech_task/domain/entities/comment.dart';
import 'package:hive/hive.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 1)
class CommentModel extends Comment {
  @override
  @HiveField(0)
  final int id;
  
  @override
  @HiveField(1)
  final int postId;
  
  @override
  @HiveField(2)
  final String name;
  
  @override
  @HiveField(3)
  final String email;
  
  @override
  @HiveField(4)
  final String body;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  }) : super(id: id, postId: postId, name: name, email: email, body: body);

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