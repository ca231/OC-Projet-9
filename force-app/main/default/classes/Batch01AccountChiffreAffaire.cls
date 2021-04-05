global class Batch01AccountChiffreAffaire implements  Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT accountid from order where status=\'Ordered\')');

   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){ 
       list<Account> ListAccUpdate = new List<Account>();    
       for (Account acct : scope){
       		AggregateResult[] totalCA =  [SELECT SUM(TotalAmount) sum FROM Order WHERE  AccountId = :acct.Id and status = 'Ordered'];
       		//if (acct.chiffre_d_affaire__c != (Decimal)totalCA[0].get('sum')) {
           		acct.chiffre_d_affaire__c = (Decimal)totalCA[0].get('sum');
           		ListAccUpdate.add(acct);
           // }
       }
       update ListAccUpdate;
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}