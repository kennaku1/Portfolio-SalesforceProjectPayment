@isTest
public class ProjectPaymentServiceTest {
    
    public static testMethod void testCreatePayment() {
        Project__c testProject = new Project__c(Name = 'Test');
        insert testProject;
        test.startTest();
            Project__c currentProjectIndex = [SELECT Id, Name FROM Project__c WHERE Id = : testProject.Id];
            System.assertNotEquals(currentProjectIndex, null, 'project was not inserted');
            Account testAccount = new Account(Name = 'Test Data Account');
            insert testAccount;
            
            Contact testContact = new Contact(FirstName = 'Ken', LastName = 'Naku');
            insert testContact;
            
            Payment__c testPayment = new Payment__c(Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 300);
            insert testPayment;
            //Verify Total_Payments__c it updated
            currentProjectIndex =  [SELECT Id, Name, Total_Payments__c, (SELECT Id FROM Payments__r) FROM Project__c WHERE Id = : testProject.Id];
            System.assertEquals(currentProjectIndex.Total_Payments__c, 300);
            System.assertNotEquals(currentProjectIndex.Payments__r.size(), 0);
        test.stopTest();
    }
    
    public static testMethod void testDeletePayment() {
        Project__c testProject = new Project__c(Name = 'Test');
        insert testProject;
        test.startTest();
            Project__c currentProjectIndex = [SELECT Id, Name FROM Project__c WHERE Id = : testProject.Id];
            System.assertNotEquals(currentProjectIndex, null, 'project was not inserted');
            
            Account testAccount = new Account(Name = 'Test Data Account');
            insert testAccount;
            
            Contact testContact = new Contact(FirstName = 'Ken', LastName = 'Naku');
            insert testContact;
            
            Payment__c testPayment = new Payment__c(Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 300);
            insert testPayment;
            
            currentProjectIndex =  [SELECT Id, Name, Total_Payments__c, (SELECT Id FROM Payments__r) FROM Project__c WHERE Id = : testProject.Id];
            System.assertEquals(currentProjectIndex.Total_Payments__c, 300);
            System.assertNotEquals(currentProjectIndex.Payments__r.size(), 0);
            //Deleting after insert
            delete testPayment;
            currentProjectIndex =  [SELECT Id, Name, Total_Payments__c, (SELECT Id FROM Payments__r) FROM Project__c WHERE Id = : testProject.Id];
            System.assertEquals(currentProjectIndex.Total_Payments__c, 0);
            System.assertEquals(currentProjectIndex.Payments__r.size(), 0);            
        test.stopTest();
    }
    
    public static testMethod void testUpdatePayment() {
        Project__c testProject = new Project__c(Name = 'Test');
        insert testProject;
        test.startTest();
            Project__c currentProjectIndex = [SELECT Id, Name FROM Project__c WHERE Id = : testProject.Id];
            System.assertNotEquals(currentProjectIndex, null, 'project was not inserted');
            
            Account testAccount = new Account(Name = 'Test Data Account');
            insert testAccount;
            
            Contact testContact = new Contact(FirstName = 'Ken', LastName = 'Naku');
            insert testContact;
            
            Payment__c testPayment = new Payment__c(Project__c = testProject.Id, Contact__c = testContact.Id, Amount__c = 300);
            insert testPayment;
            
            currentProjectIndex =  [SELECT Id, Name, Total_Payments__c, (SELECT Id FROM Payments__r) FROM Project__c WHERE Id = : testProject.Id];
            System.assertEquals(currentProjectIndex.Total_Payments__c, 300);
            System.assertNotEquals(currentProjectIndex.Payments__r.size(), 0);
            //Deleting after insert
            testPayment.Amount__c = 1000;
            update testPayment;
            currentProjectIndex =  [SELECT Id, Name, Total_Payments__c, (SELECT Id FROM Payments__r) FROM Project__c WHERE Id = : testProject.Id];
            System.assertEquals(currentProjectIndex.Total_Payments__c, 1000);
            System.assertEquals(currentProjectIndex.Payments__r.size(), 1);            
        test.stopTest();
    }    

}