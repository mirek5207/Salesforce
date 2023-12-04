public with sharing class SaveNavExample {
    public static void noSafeNav(){
        String accountName;
        List<Account> account = [SELECT Id,Name FROM Account WHERE Name = 'Kevin' LIMIT 1];
        if(!account.isEmpty()){
            accountName = account[0].Name;
        }
        System.debug('acounts: ' + accountName);
    }
    public static void safeNav(){
        String accountName = [SELECT Id,Name FROM Account WHERE Name = 'Kevin' LIMIT 1]?.Name;
        System.debug('acounts: ' + accountName);
    }
}
