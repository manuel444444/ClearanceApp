import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void sendMail(String recipient, String subject, String body) async {
  String username = 'YOUR_MAILGUN_SMTP_USERNAME';
  String password = 'YOUR_MAILGUN_SMTP_PASSWORD';

  final smtpServer = SmtpServer('smtp.mailgun.org',
      username: username, password: password, port: 587);

  final message = Message()
    ..from = Address(username, 'Your Name')
    ..recipients.add(recipient)
    ..subject = subject
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
