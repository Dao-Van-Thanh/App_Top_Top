enum EnumNotificationType { comment, chat, follow, upvideo, share }

String toStringNotificationEnum(EnumNotificationType e) {
  switch (e) {
    case EnumNotificationType.comment:
      return 'comment';
    case EnumNotificationType.chat:
      return 'chat';
    case EnumNotificationType.follow:
      return 'follow';
    case EnumNotificationType.upvideo:
      return 'upvideo';
    case EnumNotificationType.share:
      return 'share';
  }
}

EnumNotificationType fromStringNotificationEnum(String value) {
  switch (value) {
    case 'comment':
      return EnumNotificationType.comment;
    case 'chat':
      return EnumNotificationType.chat;
    case 'follow':
      return EnumNotificationType.follow;
    case 'upvideo':
      return EnumNotificationType.upvideo;
    case 'share':
      return EnumNotificationType.share;
    default:
      throw ArgumentError('Invalid value: $value');
  }
}
