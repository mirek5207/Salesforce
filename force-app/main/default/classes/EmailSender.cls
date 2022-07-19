public with sharing class EmailSender {
    public static void sendEmail(String subject, String body, String receiverEmail) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{receiverEmail});
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}
