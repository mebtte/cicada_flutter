import '../../constants/index.dart';
import '../../server/request.dart';

class Profile {
  final String id;
  final String username;
  final String? avatar;
  final String nickname;
  final int joinTimestamp;
  final bool twoFAEnabled;

  Profile({
    required this.id,
    required this.username,
    required this.avatar,
    required this.nickname,
    required this.joinTimestamp,
    required this.twoFAEnabled,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'],
      nickname: json['nickname'],
      joinTimestamp: json['joinTimestamp'],
      twoFAEnabled: json['twoFAEnabled'],
    );
  }
}

Future<Profile> getProfile(String? token) async {
  Map<String, String> headers = {};
  if (token != null) {
    headers[TOKEN_HEADER_KEY] = token;
  }
  final responseData = await httpGet(path: "/api/profile", headers: headers);
  return Profile.fromJson(responseData);
}
