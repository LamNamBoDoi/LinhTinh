enum ResponseToken implements Comparable<ResponseToken> {
  ok(code: 200, message: "Đăng nhập thành công"),
  invalidGrant(code: 400, message: "Sai mật khẩu tài khoản"),
  other(code: 500, message: "Sai mật khẩu tài khoản"),
  badGateway(code: 502, message: "Đăng nhập thành công");

  const ResponseToken({
    required this.code,
    required this.message,
  });

  final int code;
  final String message;

  @override
  int compareTo(ResponseToken other) => code - other.code;
}
