@isTest
private class ProjectPaymentControllerTest {

	private static testMethod void init() {
	    Project__c testProject = new Project__c(Name = 'Test');
        insert testProject;
        
        Account testAccount = new Account(Name = 'Test Data Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Ken', LastName = 'Naku');
        insert testContact;
        
        Payment__c testPayment = new Payment__c(Name='Test1',Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 300);
        Payment__c testPayment2 = new Payment__c(Name='Test2',Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 500);
        insert new List<Payment__c>{testPayment, testPayment2};         
        test.startTest();
            ProjectPaymentController.UIResponse response = ProjectPaymentController.init(testProject.Id);
            System.assertEquals(response.projectName,'Test');
            System.assertEquals(response.totalAmount,800);
            System.assertEquals(response.projectContacts.size(),1);
        test.stopTest();
    
	}
	
	private static testMethod void addPayment() {
	    Project__c testProject = new Project__c(Name = 'Test');
        insert testProject;
        
        Account testAccount = new Account(Name = 'Test Data Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Ken', LastName = 'Naku');
        insert testContact;
        
        Payment__c testPayment = new Payment__c(Name='Test1',Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 300);
        Payment__c testPayment2 = new Payment__c(Name='Test2',Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 500);
        insert new List<Payment__c>{testPayment, testPayment2};         
        test.startTest();
            ProjectPaymentController.UIResponse response = ProjectPaymentController.init(testProject.Id);
            System.assertEquals(response.projectName,'Test');
            System.assertEquals(response.totalAmount,800);
            System.assertEquals(response.projectContacts.size(),1);
        test.stopTest();
	}
	
	private static testMethod void deletePayment() {
	    Project__c testProject = new Project__c(Name = 'Test');
        insert testProject;
        
        Account testAccount = new Account(Name = 'Test Data Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Ken', LastName = 'Naku');
        insert testContact;
        
        Payment__c testPayment = new Payment__c(Name='Test1',Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 300);
        insert testPayment;    
        
        test.startTest();
            Boolean response = ProjectPaymentController.deleteProjectPayment(testPayment.Id);
            System.assertEquals(response, true);
        test.stopTest();
	}	
	
	
	private static testMethod void updatePayment() {
	    Project__c testProject = new Project__c(Name = 'Test');
        insert testProject;
        
        Account testAccount = new Account(Name = 'Test Data Account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Ken', LastName = 'Naku');
        insert testContact;
        
        Payment__c testPayment = new Payment__c(Name='Test1',Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 300);
        insert testPayment;    
        
        test.startTest();
            ProjectPaymentController.updateProjectPayment(testPayment.Id, 8000);
            System.assertEquals([SELECT Id, Name, Amount__c FROM Payment__c WHERE Id = : testPayment.Id].Amount__c, 8000);
        test.stopTest();
	}	
}