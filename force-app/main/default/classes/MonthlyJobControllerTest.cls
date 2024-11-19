@isTest
private class MonthlyJobControllerTest {
    
    @isTest
    static void testExecuteMethod() {
        Test.startTest();
        
        MonthlyJobController jobController = new MonthlyJobController();
        jobController.execute(null);
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testAbortScheduledJob() {
        // CronTrigger cronTrigger = new CronTrigger(
        //     CronJobDetailName = 'MonthlyJobOneInMonth',
        // State = 'WAITING'
        //     );
        
        // insert cronTrigger;
        
        MonthlyJobController.scheduleJob();
        List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'MonthlyJobOneInMonth'];
        System.assertEquals(1, scheduledJobs.size(), 'The job should be scheduled.');


        MonthlyJobController.abortScheduledJob();
        
        
        List<CronTrigger> cronTriggers = [SELECT Id, State FROM CronTrigger WHERE CronJobDetail.Name = 'MonthlyJobOneInMonth'];
        System.assertEquals(0, cronTriggers.size(), 'There should be one CronTrigger with this name.');
        // System.assertEquals('ABORTED', cronTriggers[0].State, 'The job should be aborted.');
        
        

    }
    
    
}