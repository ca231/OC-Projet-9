@isTest
private class testUpdateAccountCA {
		/**
	 	* Classe de test pour le trigger UpdateAccountCA 
		* 			test : Méthode qui teste de façon unitaire les fonctions d'update et de delete d'order, ce qui déclenche
        *                  des recalculs du chiffre d'affaires stocké dans l'account
        * 			testmasse : Méthode qui teste des mises à jour des orders de façon massive pour vérifier que le chiffre d'affaires calculé sur le compte demeure correct
 		* 
 		* @Author: Catherine AUBLE
 		* @Date : 08/05/2021
 		*/    
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
		system.debug('Id ORDER : '+ o1.id );
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        system.debug('Id ORDERITEM1 : '+ o1.id );
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2; 
            
        Test.startTest();
        List<Boolean> exceptions = new List<Boolean>();
        List<Account> accts = [SELECT chiffre_d_affaire__c FROM Account WHERE Name ='Test Account 1'];
    	System.assertEquals(accts[0].chiffre_d_affaire__c, 0,'Was expecting to find 0');
        
        try {
            delete o1;
        } catch (Exception e){
            system.debug('Exception remontée sur delete order Draft'+ e);
            exceptions.add(true);
        }
		system.assertNotEquals(null, exceptions, 'Au moins une exception attendue');
        for (Boolean b : exceptions) {
                system.assert(b, 'Aucun compte');
        }
            
        o1.Status = 'Ordered';
        update o1;
        accts = [SELECT chiffre_d_affaire__c FROM Account WHERE Name ='Test Account 1'];
    	system.assertEquals(accts[0].chiffre_d_affaire__c, 21500,'Was expecting to find 21500');
        
		Test.stopTest();     
    }

    
        @isTest static void testmasse() {
             
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
            
            
       		Account acc1 = new Account(Name = 'Test Account 1');
            insert acc1;
            
            List<Order> orders = new List<Order>();
            
            for ( Integer j=1;j<150; j++){
                Order order = new Order(AccountId = acc1.id,
                                        Name = 'Order numero ' + j,
                                        EffectiveDate=date.parse('13/05/2021'),
                                        Status='Draft',
                                        Pricebook2Id=Test.getStandardPricebookId());  
                orders.add(order);	
            }
            insert orders;
            List<OrderItem> orderItems = new List<OrderItem>();

            for (Order ord : orders) {
                OrderItem ordItem1 = new OrderItem ( OrderId=ord.Id,PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
                OrderItem ordItem2 =  new OrderItem (OrderId=ord.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
                orderItems.add(ordItem1);
                orderItems.add(ordItem2);
            }
            insert orderItems;
            

        Test.startTest();
        List<Order> updateOrders = new List<Order>();
        List<Account> accts = [SELECT chiffre_d_affaire__c FROM Account WHERE Name ='Test Account 1'];

    	System.assertEquals(accts[0].chiffre_d_affaire__c, 0,'Attendu 0');
        Integer j=0;
        for (Order ord : orders){
            if (j < 40 ) {
                   ord.Status = 'Ordered';
                   system.debug('Numero du ordered '+ j + ord.Name);
                   updateOrders.add(ord);
                   j++;
            }
        }
        upsert updateOrders;
        accts = [SELECT chiffre_d_affaire__c FROM Account WHERE Name ='Test Account 1']; 
        system.debug('Chiffre affaires :'  + accts[0].chiffre_d_affaire__c);
        System.assertEquals(accts[0].chiffre_d_affaire__c,860000,'Was expecting to find 430000');
        
		Test.stopTest();     
    }
}