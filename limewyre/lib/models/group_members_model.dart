class GroupMembersResponse {
  final List<GroupMember> items;

  GroupMembersResponse({required this.items});

  factory GroupMembersResponse.fromJson(Map<String, dynamic> json) {
    return GroupMembersResponse(
      items: (json['Items'] as List<dynamic>? ?? [])
          .map((e) => GroupMember.fromJson(e))
          .toList(),
    );
  }
}

class GroupMember {
  final String userId;
  final String userRole;
  final String userStatus;
  final String userEmailId;
  final String groupId;
  final String groupName;
  final int userCreatedOn;

  GroupMember({
    required this.userId,
    required this.userRole,
    required this.userStatus,
    required this.userEmailId,
    required this.groupId,
    required this.groupName,
    required this.userCreatedOn,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['user_id'] ?? '',
      userRole: json['user_role'] ?? '',
      userStatus: json['user_status'] ?? '',
      userEmailId: json['user_email_id'] ?? '',
      groupId: json['group_id'] ?? '',
      groupName: json['group_name'] ?? '',
      userCreatedOn: json['user_created_on'] ?? 0,
    );
  }
}
