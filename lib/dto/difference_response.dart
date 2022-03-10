class DifferenceResponseDto {
  late Data? data;

  DifferenceResponseDto(this.data);

  DifferenceResponseDto.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  late int differenceCount;
  late List<String> difference;

  Data(this.differenceCount, this.difference);

  Data.fromJson(Map<String, dynamic> json) {
    differenceCount = json['differenceCount'];
    difference = json['difference'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['differenceCount'] = this.differenceCount;
    data['difference'] = this.difference;
    return data;
  }
}
