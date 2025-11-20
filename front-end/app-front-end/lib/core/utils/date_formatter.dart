/// Date Formatter Utility
/// Simple date formatting without external dependencies
class DateFormatter {
  /// Format date as "Month DD, YYYY" (e.g., "November 20, 2025")
  static String formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${_padZero(date.day)}, ${date.year}';
  }

  /// Format date as "Mon DD, YYYY" (e.g., "Nov 20, 2025")
  static String formatDateShort(DateTime date) {
    return '${_getMonthNameShort(date.month)} ${_padZero(date.day)}, ${date.year}';
  }

  /// Format date as "DD/MM/YYYY"
  static String formatDateNumeric(DateTime date) {
    return '${_padZero(date.day)}/${_padZero(date.month)}/${date.year}';
  }

  /// Format time as "HH:MM AM/PM"
  static String formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${_padZero(hour)}:${_padZero(date.minute)} $period';
  }

  /// Format date and time as "Month DD, YYYY at HH:MM AM/PM"
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} at ${formatTime(date)}';
  }

  /// Get relative time (e.g., "2 days ago", "in 3 hours")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative) {
      final futureDiff = date.difference(now);
      if (futureDiff.inDays > 0) {
        return 'in ${futureDiff.inDays} day${futureDiff.inDays != 1 ? 's' : ''}';
      } else if (futureDiff.inHours > 0) {
        return 'in ${futureDiff.inHours} hour${futureDiff.inHours != 1 ? 's' : ''}';
      } else if (futureDiff.inMinutes > 0) {
        return 'in ${futureDiff.inMinutes} minute${futureDiff.inMinutes != 1 ? 's' : ''}';
      } else {
        return 'in a moment';
      }
    }

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years != 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months != 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  static String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  static String _getMonthNameShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  static String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }
}
