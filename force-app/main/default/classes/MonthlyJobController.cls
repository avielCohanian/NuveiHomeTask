public with sharing class MonthlyJobController implements Schedulable {
    Integer YEAR = 365;
    
    public void execute(SchedulableContext context) {
        System.debug('The scheduled job is running on the 10th of the month!');
        AccountController.AverageMonthlyVolume('', YEAR, true);
    }
    
    
    public static void abortScheduledJob() {
        List<CronTrigger> monthlyJobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'MonthlyJobOneInMonth' LIMIT 1];
        
        if (!monthlyJobs.isEmpty()) {
            System.abortJob(monthlyJobs[0].Id);
            System.debug('Scheduled job with ID ' + monthlyJobs[0].Id + ' has been aborted.');
        } else {
            System.debug('No scheduled job found with the name: ' + 'MonthlyJobOneInMonth');
        }
    }
    
    public static void scheduleJob() {
        List<CronTrigger> existingJobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'MonthlyJobOneInMonth' LIMIT 1];
        
        if (existingJobs.isEmpty()) {
            String cronExpression = '0 0 10 * * ?';
            System.schedule('MonthlyJobOneInMonth', cronExpression, new MonthlyJobController());
            System.debug('Job scheduled to run on the 10th of the month!');
        } else {
            System.debug('Job already exists. No new job scheduled.');
        }
    }
}