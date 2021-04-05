@isTest
private class testUpdateAccountCA {
    @isTest static void test() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Order o1 = new Order(
            AccountId = acc1.Id,
            EffectiveDate=date.parse('21/01/2021'),
            status='Draft',
            Pricebook2Id=Test.getStandardPricebookId());
        insert o1;
		System.debug('Id ORDER : '+ o1.id );
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        System.debug('Id ORDERITEM1 : '+ o1.id );
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2; 
        
        Test.startTest();
        List<Account> accts = [SELECT chiffre_d_affaire__c FROM Account WHERE Name ='Test Account 1'];
    	system.assertEquals(accts[0].chiffre_d_affaire__c, 0,'Was expecting to find 21500');
		o1.Status = 'Ordered';
        update o1;
        accts = [SELECT chiffre_d_affaire__c FROM Account WHERE Name ='Test Account 1'];
    	system.assertEquals(accts[0].chiffre_d_affaire__c, 21500,'Was expecting to find 21500');
		Test.stopTest();
    }
}