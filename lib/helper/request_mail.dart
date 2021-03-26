import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

requestMail(String mechanicEmail, String shopName , BuildContext context) async {
  String username = 'rapidservice999@gmail.com';
  String password = 'Rapidthu&er999';

  // ignore: deprecated_member_use
  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Rapid Service')
    ..recipients.add('$mechanicEmail')
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'New Request Found 😀'
    // ..text = 'New Request Founded.\nKindly Action On The Request.'
    ..html = "<h1>A New Booking Request Received.</h1>\n<p>Kindly check the app and <b>Process</b> on The Request.</p>";

  try {
    final sendReport = await send(message, smtpServer);

    Fluttertoast.showToast(
        msg: 'Message sent: to $shopName',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
        
    Navigator.pop(context);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    Fluttertoast.showToast(
        msg: e.message != null ? e.message : "Message not sent!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    print('Message not sent.');
    for (var p in e.problems) {

      Fluttertoast.showToast(
        msg: "Problem: ${p.code}: ${p.msg}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);

      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  // DONE
}
