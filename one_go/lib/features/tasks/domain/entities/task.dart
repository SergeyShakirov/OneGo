class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String deadline;
  final String authorId;
  final String authorName;
  final double authorRating;
  final int responsesCount;
  final bool isUrgent;
  final List<String> skills;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status; // active, in_progress, completed, cancelled
  final String? assignedToId;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.deadline,
    required this.authorId,
    required this.authorName,
    required this.authorRating,
    required this.responsesCount,
    required this.isUrgent,
    required this.skills,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.assignedToId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      deadline: json['deadline'],
      authorId: json['author_id'],
      authorName: json['author_name'],
      authorRating: json['author_rating'].toDouble(),
      responsesCount: json['responses_count'],
      isUrgent: json['is_urgent'],
      skills: List<String>.from(json['skills']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
      assignedToId: json['assigned_to_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'deadline': deadline,
      'author_id': authorId,
      'author_name': authorName,
      'author_rating': authorRating,
      'responses_count': responsesCount,
      'is_urgent': isUrgent,
      'skills': skills,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'assigned_to_id': assignedToId,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? price,
    String? deadline,
    String? authorId,
    String? authorName,
    double? authorRating,
    int? responsesCount,
    bool? isUrgent,
    List<String>? skills,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    String? assignedToId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      deadline: deadline ?? this.deadline,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRating: authorRating ?? this.authorRating,
      responsesCount: responsesCount ?? this.responsesCount,
      isUrgent: isUrgent ?? this.isUrgent,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      assignedToId: assignedToId ?? this.assignedToId,
    );
  }
}

class CreateTaskRequest {
  final String title;
  final String description;
  final String category;
  final double price;
  final String deadline;
  final bool isUrgent;
  final List<String> skills;

  const CreateTaskRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.deadline,
    required this.isUrgent,
    required this.skills,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'deadline': deadline,
      'is_urgent': isUrgent,
      'skills': skills,
    };
  }
}
