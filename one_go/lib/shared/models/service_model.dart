import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'service_model.g.dart';

@JsonSerializable()
class Service extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final PriceType priceType;
  final List<String> images;
  final User provider;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.priceType,
    required this.images,
    required this.provider,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        price,
        priceType,
        images,
        provider,
        rating,
        reviewCount,
        isActive,
        createdAt,
        updatedAt,
      ];

  Service copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? price,
    PriceType? priceType,
    List<String>? images,
    User? provider,
    double? rating,
    int? reviewCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      priceType: priceType ?? this.priceType,
      images: images ?? this.images,
      provider: provider ?? this.provider,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum PriceType {
  @JsonValue('fixed')
  fixed,
  @JsonValue('hourly')
  hourly,
  @JsonValue('daily')
  daily,
}
