public with sharing class EmailSender {
    public static void sendEmail(String subject, String body, String receiverEmail) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{receiverEmail});
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        } catch(System.EmailException ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Caught email exception: ' + ex));
        }
    }
}