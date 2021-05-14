public class AccountChiffreAffairesController {
 @AuraEnabled
  public static List<AggregateResult> getCumulCAByOwner(){
      return [SELECT owner.name collaborateur, SUM(chiffre_d_affaire__c) montant 
              FROM account 
              WHERE owner.name != 'Automated Process' 
              GROUP BY owner.name];
  }      
}