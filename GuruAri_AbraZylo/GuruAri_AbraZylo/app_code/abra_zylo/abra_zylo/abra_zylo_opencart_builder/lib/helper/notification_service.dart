import 'package:notification_center/notification_center.dart';

class NotificationService {
  static final instance = NotificationService._();
  final NotificationCenter notificationCenter = NotificationCenter.internal();

  NotificationService._();

  static String updateCategoryKey = 'update_category';
}
