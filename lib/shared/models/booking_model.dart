import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'service_model.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class Booking extends Equatable {
  final String id;
  final Service service;
  final User customer;
  final User provider;
  final DateTime scheduledDate;
  final String? notes;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.service,
    required this.customer,
    required this.provider,
    required this.scheduledDate,
    this.notes,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);

  @override
  List<Object?> get props => [
        id,
        service,
        customer,
        provider,
        scheduledDate,
        notes,
        totalPrice,
        status,
        createdAt,
        updatedAt,
      ];

  Booking copyWith({
    String? id,
    Service? service,
    User? customer,
    User? provider,
    DateTime? scheduledDate,
    String? notes,
    double? totalPrice,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      service: service ?? this.service,
      customer: customer ?? this.customer,
      provider: provider ?? this.provider,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      notes: notes ?? this.notes,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}
