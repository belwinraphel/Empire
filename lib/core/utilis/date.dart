import 'package:intl/intl.dart';

String formatTimeAgo(String timestamp) {
  // 1. Parse the string to a DateTime object
  DateTime date = DateTime.parse(timestamp);
  
  // 2. Get the current time
  DateTime now = DateTime.now();
  
  // 3. Calculate the difference
  Duration diff = now.difference(date);

  // 4. Logic to return the correct string
  if (diff.inSeconds < 60) {
    return 'Just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} min ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hr ago';
  } else if (diff.inDays == 1) {
    return 'Yesterday';
  } else {
    // If more than 24 hours (and not yesterday), show the actual date
    // Pattern 'dd MMM yyyy' outputs: 12 Jan 2023
    return DateFormat('dd MMM yyyy').format(date);
  }
}