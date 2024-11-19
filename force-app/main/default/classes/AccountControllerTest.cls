@isTest
private class AccountControllerTest {
    
    @isTest
    static void testCalculateAverageMonthlyVolume() {
        Decimal result = AccountController.calculateAverageMonthlyVolume(0);
        System.assertEquals(0, result, 'The average monthly volume should be 0 when the annualAmount is 0');
        
        result = AccountController.calculateAverageMonthlyVolume(120);
        System.assertEquals(10, result, 'The average monthly volume should be 10 when the annualAmount is 120');
    }
    
    @isTest
    static void testAverageMonthlyVolume() {
        String result = AccountController.AverageMonthlyVolume(null, null, true);
        System.assertNotEquals(null, result);
        
        // Prepare test data
        Account acc1 = new Account(Name = 'Account 1');
        insert acc1;
        
        Volume__c volume1 = new Volume__c(Account__c = acc1.Id, DailyTransaction__c = 100);
        Volume__c volume2 = new Volume__c(Account__c = acc1.Id, DailyTransaction__c = 200);
        insert new List<Volume__c>{ volume1, volume2 };
        
        
        // Check that the result is not null and contains the expected data
        result = AccountController.AverageMonthlyVolume(null, null, true);
        System.assertNotEquals(null, result);
        System.assert(result.contains('Average monthly volume updated'));
        
        // Fetch the updated account to verify the update
        Account updatedAccount = [SELECT AverageMonthlyVolume__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(25, updatedAccount.AverageMonthlyVolume__c, 'The average monthly volume should be 25 (sum of 100+200 divided by 12)');
        
        result = AccountController.AverageMonthlyVolume(acc1.Id, 15, false);
        System.assertNotEquals(null, result);
        System.assertEquals(false,result.contains('Average monthly volume updated'));
        
        
        result = AccountController.AverageMonthlyVolume('throwEx', null, false);
        System.assertNotEquals(null, result);
        System.assertEquals(true,result.contains('Error'));
    }
    
    
    
}