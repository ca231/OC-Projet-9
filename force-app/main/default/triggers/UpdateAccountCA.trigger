trigger UpdateAccountCA on Order (after update,after delete, after undelete){   
    
    List<id> accIdList = new List<id>();
	List<id> ordIdList = new List<id>();
    
    if(Trigger.isInsert || Trigger.isUndelete|| Trigger.isUpdate){
        for(Order o : Trigger.new){
            ordIdList.add(o.Id);
        }
    }

    if(Trigger.isDelete){
        for(Order o : Trigger.old){
            ordIdList.add(o.Id);      
        }
    }
    for (Order ord : [SELECT AccountId FROM Order where id in:OrdIdList and status='Ordered']) {
        accIdList.add(ord.AccountId);
    }
    List<Account> accUpdateList = new List<Account>();
    For (Account acct : [SELECT  id, chiffre_d_affaire__c FROM Account WHERE id IN :accIdList]){
        AggregateResult[] totalCA = [SELECT SUM(TotalAmount) sum FROM Order WHERE AccountId = :acct.Id and status='Ordered'];
        
        acct.chiffre_d_affaire__c = (Decimal)totalCA[0].get('sum');
        accUpdateList.add(acct); 
    }
    try{
        update accUpdateList;
    }Catch(Exception e){
        System.debug('Exception :'+e.getMessage());
    }
}