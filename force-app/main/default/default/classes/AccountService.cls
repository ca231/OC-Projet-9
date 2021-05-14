public class AccountService {
    /**
	* Classe de service pour l'objet Account dans lequel est défini la méthode 
    * 			updateChiffreAffaires : Permet de recalculer le chiffre d'affaires du compte
    * 
 	* @Author: Catherine AUBLE
 	* @Date : 08/05/2021
 	*/
    public static void UpdateChiffreAffaires(Set<Id> accountIds) {
		/**
        * Le chiffre d'affaires d'un compte est égal à la somme des commandes avec le statut 'ordered' et enregistrées sur ce compte.
        * Vérifification de la validité des paramètres
        */
        
        if ( accountIds == null || accountIds.size() == 0) 
            throw new AccountServiceException ('Aucun Compte fourni');
   	 	      
        List<Account> acctToUpdateList = new List <Account>();
        
        System.debug('Account 1'+accountIds);

        for (string accountId : accountIds )  {
        	AggregateResult[] totalCA = [SELECT SUM(TotalAmount) sum FROM Order WHERE AccountId = :accountId and status='Ordered' GROUP BY AccountId];
            Account updateAccount = new Account();
            updateAccount.chiffre_d_affaire__c = (Decimal)totalCA[0].get('sum');
            updateAccount.Id = accountId;
            System.debug('Account 2'+ updateAccount);
        	acctToUpdateList.add(updateAccount); 
    	}
    	try{
            System.debug('Account 3'+acctToUpdateList);
        	upsert acctToUpdateList;

    	}Catch(Exception e){
        	System.debug('Exception :'+e.getMessage());
    	} 
    }
    public class AccountServiceException extends Exception {}
}