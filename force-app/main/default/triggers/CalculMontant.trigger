trigger CalculMontant on Order (before update) {
    
    Order newOrder= [SELECT NetAmount__c, TotalAmount,ShipmentCost__c FROM ORDER where Id in : Trigger.new];
    if (newOrder.TotalAmount != null ){
    newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
    update newOrder;
    }
}