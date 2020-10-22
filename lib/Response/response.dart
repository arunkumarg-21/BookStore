import 'dart:convert';

ResponseResult responseFromJson(String str) => ResponseResult.fromJson(json.decode(str));

String responseToJson(ResponseResult data) => json.encode(data.toJson());

class ResponseResult {
  ResponseResult({
    this.head,
    this.body,
  });

  Head head;
  Body body;

  factory ResponseResult.fromJson(Map<String, dynamic> json) => ResponseResult(
    head: Head.fromJson(json["head"]),
    body: Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "head": head.toJson(),
    "body": body.toJson(),
  };
}

class Body {
  Body({
    this.resultInfo,
    this.txnToken,
    this.isPromoCodeValid,
    this.authenticated,
  });

  ResultInfo resultInfo;
  String txnToken;
  bool isPromoCodeValid;
  bool authenticated;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    resultInfo: ResultInfo.fromJson(json["resultInfo"]),
    txnToken: json["txnToken"],
    isPromoCodeValid: json["isPromoCodeValid"],
    authenticated: json["authenticated"],
  );

  Map<String, dynamic> toJson() => {
    "resultInfo": resultInfo.toJson(),
    "txnToken": txnToken,
    "isPromoCodeValid": isPromoCodeValid,
    "authenticated": authenticated,
  };
}

class ResultInfo {
  ResultInfo({
    this.resultStatus,
    this.resultCode,
    this.resultMsg,
  });

  String resultStatus;
  String resultCode;
  String resultMsg;

  factory ResultInfo.fromJson(Map<String, dynamic> json) => ResultInfo(
    resultStatus: json["resultStatus"],
    resultCode: json["resultCode"],
    resultMsg: json["resultMsg"],
  );

  Map<String, dynamic> toJson() => {
    "resultStatus": resultStatus,
    "resultCode": resultCode,
    "resultMsg": resultMsg,
  };
}

class Head {
  Head({
    this.responseTimestamp,
    this.version,
    this.signature,
  });

  String responseTimestamp;
  String version;
  String signature;

  factory Head.fromJson(Map<String, dynamic> json) => Head(
    responseTimestamp: json["responseTimestamp"],
    version: json["version"],
    signature: json["signature"],
  );

  Map<String, dynamic> toJson() => {
    "responseTimestamp": responseTimestamp,
    "version": version,
    "signature": signature,
  };
}