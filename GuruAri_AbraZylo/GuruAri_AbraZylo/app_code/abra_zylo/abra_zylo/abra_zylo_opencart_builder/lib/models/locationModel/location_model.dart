import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel extends BaseModel {
  @JsonKey(name: "track")
  List<Track>? tracks;
  LocationModel({this.tracks});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

@JsonSerializable()
class Track extends BaseModel {
  @JsonKey(name: "lat")
  String? lat;
  @JsonKey(name: "lon")
  String? lon;
  Track({this.lat, this.lon});

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);
}
