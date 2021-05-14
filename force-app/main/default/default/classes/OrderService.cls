/**
 * Classe de service pour l'objet Order dans lequel est défini la méthode 
 * 			updateChiffreAffairesAccount : Mise àjour chiffre d'affaires des comptes pour lesquels une commande(orders) est repris dans la liste des orders passés en paramètre
 * 
 * @Author: Catherine AUBLE
 * @Date : 08/05/2021
 */
public class OrderService {
    public static void updateChiffreAffairesAccount(Set<Id> orderIds) {

        // Verifification de la validité des paramètres
        if ( orderIds == null || orderIds.size() == 0) 
            throw new OrderServiceException ('Aucun orders ');
   	 	
        Set<Id> accountIds = new Set<Id>();
    	for (Order ord : [SELECT AccountId FROM Order where id in:orderIds and status='Ordered']) {
        	accountIds.add(ord.AccountId);
    	}

        if (accountIds == null || AccountIds.size() == 0)
            throw new OrderServiceException ('Aucun compte');
       
        accountService.UpdateChiffreAffaires(AccountIds);
    }
    public class OrderServiceException extends Exception {}
}