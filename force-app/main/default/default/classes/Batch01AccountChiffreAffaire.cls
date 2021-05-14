global class Batch01AccountChiffreAffaire implements Database.Batchable<sObject>{
/**
 * Classe batch qui permet de mettre à jour le chiffre d'affaires de l'ensemble des comptes
 * 
 * @Author: Catherine AUBLE
 * @Date : 08/05/2021
 */    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT accountid from order where status=\'Ordered\')');
   }
    
   public void execute(Database.BatchableContext info, List<Account> scope) { 
       Set<Id> accIds = new Set<Id>();
    
       for(Account a : scope){
           system.debug('Account à mettre à jour : '+a.Id); 
           accIds.add(a.Id);
        }
       try {
       	AccountService.UpdateChiffreAffaires(accIds);
       }catch(Exception e){ 
           system.debug('Pb exécution méthode AccountService.UpdateChiffreAffaires : '+ accIds);
       }
   }    
    
   public void finish(Database.BatchableContext info){     
       
   } 
}