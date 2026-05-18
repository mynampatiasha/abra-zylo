import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends BaseModel {
  List<TransactionData>? transactionData;
  String? transactionsTotal;
  String? transactionText;
  String? totalBalance;

  TransactionModel(
      {this.transactionData,
      this.transactionsTotal,
      this.transactionText,
      this.totalBalance});

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}

@JsonSerializable()
class TransactionData {
  String? amount;
  String? description;
  @JsonKey(name: "date_added")
  String? dateAdded;

  TransactionData({this.amount, this.description, this.dateAdded});

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}
