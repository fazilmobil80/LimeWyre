class GroupListResponse {
  final String status;
  final GroupListData data;

  GroupListResponse({required this.status, required this.data});

  factory GroupListResponse.fromJson(Map<String, dynamic> json) {
    return GroupListResponse(
      status: json['status'] ?? '',
      data: GroupListData.fromJson(json['data'] ?? {}),
    );
  }
}

class GroupListData {
  final List<GroupItem> items;

  GroupListData({required this.items});

  factory GroupListData.fromJson(Map<String, dynamic> json) {
    return GroupListData(
      items: (json['Items'] as List<dynamic>? ?? [])
          .map((e) => GroupItem.fromJson(e))
          .toList(),
    );
  }
}

class GroupItem {
  final String userId;
  final String userEmailId;
  final String userStatus;
  final String groupName;
  final String groupId;
  final String userRole;
  final int userCreatedOn;

  GroupItem({
    required this.userId,
    required this.userEmailId,
    required this.userStatus,
    required this.groupName,
    required this.groupId,
    required this.userRole,
    required this.userCreatedOn,
  });

  factory GroupItem.fromJson(Map<String, dynamic> json) {
    return GroupItem(
      userId: json['user_id'] ?? '',
      userEmailId: json['user_email_id'] ?? '',
      userStatus: json['user_status'] ?? '',
      groupName: json['group_name'] ?? '',
      groupId: json['group_id'] ?? '',
      userRole: json['user_role'] ?? '',
      userCreatedOn: json['user_created_on'] ?? 0,
    );
  }
}
