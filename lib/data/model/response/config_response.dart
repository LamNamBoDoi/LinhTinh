class ConfigResponse {
  ConfigResponse({
    required this.versionName,
  });

  late final String versionName;

  ConfigResponse.fromJson(Map<String, dynamic> json) {
    versionName = json['versionName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['versionName'] = versionName;
    return data;
  }
}
