class UserResponse {
  final String status;
  final UserData data;

  UserResponse({required this.status, required this.data});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserData {
  final List<UserModel> items;

  UserData({required this.items});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      items: (json['Items'] as List<dynamic>? ?? [])
          .map((e) => UserModel.fromJson(e))
          .toList(),
    );
  }
}

class UserModel {
  final int lastActedOn;
  final int groupNotesCount;
  final String userPaidSource;
  final String userStatus;
  final int totalNotesCount;
  final int personalNotesCount;
  final String userId;
  final List groupIds;
  final int userCreatedOn;
  final String userEmailId;

  UserModel({
    required this.lastActedOn,
    required this.groupNotesCount,
    required this.userPaidSource,
    required this.userStatus,
    required this.totalNotesCount,
    required this.personalNotesCount,
    required this.userId,
    required this.groupIds,
    required this.userCreatedOn,
    required this.userEmailId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      lastActedOn: json['last_acted_on'] ?? 0,
      groupNotesCount: json['group_notes_count'] ?? 0,
      userPaidSource: json['user_paid_source'] ?? '',
      userStatus: json['user_status'] ?? '',
      totalNotesCount: json['total_notes_count'] ?? 0,
      personalNotesCount: json['personal_notes_count'] ?? 0,
      userId: json['user_id'] ?? '',
      groupIds: json['group_ids'] ?? [],
      userCreatedOn: json['user_created_on'] ?? 0,
      userEmailId: json['user_email_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last_acted_on': lastActedOn,
      'group_notes_count': groupNotesCount,
      'user_paid_source': userPaidSource,
      'user_status': userStatus,
      'total_notes_count': totalNotesCount,
      'personal_notes_count': personalNotesCount,
      'user_id': userId,
      'group_ids': groupIds,
      'user_created_on': userCreatedOn,
      'user_email_id': userEmailId,
    };
  }
}
