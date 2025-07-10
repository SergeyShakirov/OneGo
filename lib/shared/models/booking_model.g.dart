// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      id: json['id'] as String,
      service: Service.fromJson(json['service'] as Map<String, dynamic>),
      customer: User.fromJson(json['customer'] as Map<String, dynamic>),
      provider: User.fromJson(json['provider'] as Map<String, dynamic>),
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      notes: json['notes'] as String?,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'service': instance.service,
      'customer': instance.customer,
      'provider': instance.provider,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'notes': instance.notes,
      'totalPrice': instance.totalPrice,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.inProgress: 'in_progress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};
