class TokenResponsive {
  String? accessToken;// mã thông báo truy cập
  String? tokenType;// loại mã thông báo
  String? refreshToken;// mã thông báo làm mới
  int? expiresIn;// thời gian còn lại
  String? scope;// phạm vi quyền
  String? organization;// tên tổ chức

  TokenResponsive(
      {this.accessToken,
      this.tokenType,
      this.refreshToken,
      this.expiresIn,
      this.scope,
      this.organization});

  TokenResponsive.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    scope = json['scope'];
    organization = json['organization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['refresh_token'] = this.refreshToken;
    data['expires_in'] = this.expiresIn;
    data['scope'] = this.scope;
    data['organization'] = this.organization;
    return data;
  }
}
