public with sharing class AccountController {

    public static Decimal calculateAverageMonthlyVolume(Decimal annualAmount) {
        if (annualAmount == 0) {
            return 0;
        }
        return annualAmount / 12;
    }
    
    @AuraEnabled
    public static String AverageMonthlyVolume(String accountId, Integer daysAgo, Boolean isUpdate){
        Response res = new Response();
        Decimal volumeCurrency = 0.0;
        
        if(daysAgo == null) daysAgo = 365;
        
        String queryStr = 'SELECT Id, Name, AverageMonthlyVolume__c,Tier__c,'+
            ' (select Id, CreatedDate, DailyTransaction__c FROM Volumes__r WHERE CreatedDate >= N_DAYS_AGO: ' + daysAgo + ' ) FROM Account ';
        if(String.isNotEmpty(accountId)) queryStr += 'WHERE Id = \''+accountId+'\' ';
        
        try {
        List<Account> accounts = (List<Account>)Database.query(queryStr);
        System.debug('AverageMonthlyVolume accounts: ' + accounts);
        List<Account> accountsToUpdate = new List<Account>();
            res.accountDetails = new List<AccountDetails>();
            for (Account acc : accounts) {
                AccountDetails accDetails = new AccountDetails();
                volumeCurrency = 0.0;
                
                for (Volume__c volume : acc.Volumes__r) {
                    volumeCurrency += volume.DailyTransaction__c;
                }
                
                Decimal averageMonthlyVolume = calculateAverageMonthlyVolume(volumeCurrency);
                acc.AverageMonthlyVolume__c = averageMonthlyVolume;
                
                accDetails.volumeCurrency = volumeCurrency;
                accDetails.avgVolumeCurrency = averageMonthlyVolume;
                accDetails.Name = acc.Name;
                
                res.accountDetails.add(accDetails);
                System.debug('AverageMonthlyVolume accDetails: ' + accDetails);
                accountsToUpdate.add(acc);
            }
            
            if (!accountsToUpdate.isEmpty() && isUpdate) {
                update accountsToUpdate;
                res.status = 'Success';
                res.message = 'Average monthly volume updated';
                
            }

        } catch (Exception ex) {
            System.debug('AccountController: err ' + ex.getMessage());
            res.status = 'Error: ';
            res.message = ex.getMessage();
        }
        System.debug('AverageMonthlyVolume res: ' + res);
        return JSON.serialize(res);
    }
    
    @TestVisible
    private class Response {
        private String status;
        private String message;
        private List<AccountDetails> accountDetails;
    }
    
    private class AccountDetails {
        private Decimal volumeCurrency;
        private Decimal avgVolumeCurrency;
        private String name;
    }
    
}