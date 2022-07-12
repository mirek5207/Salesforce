public with sharing class ErrorLog {
    public static void insertErrorLog(Datetime logDateTime,String logDetail,String processName) {
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Log_Date_Time__c = logDateTime;
        errorLog.Log_Details__c = logDetail;
        errorLog.Process_Name__c = processName;
        insert errorLog;
    }
}
