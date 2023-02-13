import 'dart:math';

class transectionUtils {
  transectionUtils() {}
  // Generate the transaction Id
  String genarateTransactionId() {
    final random = Random();
    const chars =
        "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String transactionId = '';
    for (int i = 0; i < 10; i++) {
      transactionId += chars[random.nextInt(chars.length)];
    }

    return transactionId;
  }

  // Get Time
  String dateTime() {
    var now = DateTime.now();
    return now.toString();
  }
}
