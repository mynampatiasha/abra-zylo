// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_items_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountItemsListModelAdapter extends TypeAdapter<AccountItemsListModel> {
  @override
  final int typeId = 24;

  @override
  AccountItemsListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountItemsListModel();
  }

  @override
  void write(BinaryWriter writer, AccountItemsListModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountItemsListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountItemsListModel _$AccountItemsListModelFromJson(
        Map<String, dynamic> json) =>
    AccountItemsListModel(
      myAccount: json['my_account'] as String?,
      edit: json['edit'] as String?,
      password: json['password'] as String?,
      address: json['address'] as String?,
      wishlist: json['wishlist'] as String?,
      order: json['order'] as String?,
      productReview: json['product_review'] as String?,
      download: json['download'] as String?,
      reward: json['reward'] as String?,
      itemReturn: json['return'] as String?,
      transaction: json['transaction'] as String?,
      newsletter: json['newsletter'] as String?,
      recurring: json['recurring'] as String?,
      banner: json['banner'] == null
          ? null
          : BannerModel.fromJson(json['banner'] as Map<String, dynamic>),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?;

Map<String, dynamic> _$AccountItemsListModelToJson(
        AccountItemsListModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'my_account': instance.myAccount,
      'edit': instance.edit,
      'password': instance.password,
      'address': instance.address,
      'wishlist': instance.wishlist,
      'order': instance.order,
      'product_review': instance.productReview,
      'download': instance.download,
      'reward': instance.reward,
      'return': instance.itemReturn,
      'transaction': instance.transaction,
      'newsletter': instance.newsletter,
      'recurring': instance.recurring,
      'banner': instance.banner,
    };

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      banner: json['banner'] as String?,
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'image': instance.image,
      'banner': instance.banner,
    };
