public class ScheduleMajAccount implements Schedulable {

   public void execute(SchedulableContext SC)
    {

      //Execute Batch Job Under Scheduled Apex
        Batch01AccountChiffreAffaire a = new Batch01AccountChiffreAffaire();
        string jobid= Database.executeBatch(a);
        system.debug('jobid');
        
    }
}