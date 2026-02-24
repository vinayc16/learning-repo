import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class BugReportService {
  final String adminEmail = "chauhanvinay857@gmail.com";
  final String senderEmail = "hello@yavasa.co.in";
  final String password = "hplnczhrfzvrhdyk";

  Future<bool> sendBugReport({
    required String title,
    required String description,
    required String deviceLogs,
  }) async {
    //final smtpServer = gmail(senderEmail, password);
    final smtpServer = SmtpServer(
      'smtp.office365.com',
      port: 587,
      username: senderEmail,
      password: password,
    );


    final message = Message()
      ..from = Address(senderEmail, 'Study Buddy Bug Reporter')
      ..recipients.add(adminEmail)
      ..subject = 'Bug Report: $title'
      ..text = 'Description: $description\n\nDevice Info/Logs:\n$deviceLogs';

    try {
      await send(message, smtpServer);
      return true;
    } catch (e) {
      print('Error sending bug report: $e');
      return false;
    }
  }
}