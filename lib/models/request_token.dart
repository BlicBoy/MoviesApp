class RequestToken {
  late final String? request_token;
  late final String? expires_at;
  late final bool? sucess;

  RequestToken({this.request_token, this.expires_at, this.sucess});

  factory RequestToken.fromJson(Map<String, dynamic> json) {
    return RequestToken(
      request_token: json['request_token'] ?? "",
      expires_at: json['expires_at'] ?? "",
      sucess: json['sucess'] ?? false
    );
  }
}
