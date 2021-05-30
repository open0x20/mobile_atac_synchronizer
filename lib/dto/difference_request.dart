class DifferenceRequestDto {
  List<String> filenames;

  DifferenceRequestDto({this.filenames});

  DifferenceRequestDto.fromJson(Map<String, dynamic> json) {
    filenames = json['filenames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filenames'] = this.filenames;
    return data;
  }
}
