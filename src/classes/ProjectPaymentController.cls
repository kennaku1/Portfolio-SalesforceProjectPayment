public class ProjectPaymentController {
    
    public class UIResponse {
        @AuraEnabled
        public String projectName;
        @AuraEnabled
        public Decimal totalAmount;  
        @AuraEnabled
        public List<ProjectContact> projectContacts;

        public UIResponse(String projectName, Double totalAmount, List<ProjectContact> projectContacts) {
            this.projectName = projectName;
            this.totalAmount = totalAmount;
            this.projectContacts = projectContacts;
            system.debug(this);
        }
    }

    public class ProjectContact {
        @AuraEnabled
        public Contact contactRecord;
        @AuraEnabled
        public List<Payment__c> payments;
        
        public ProjectContact(final Contact contactRecord, List<Payment__c> payments) {
            this.contactRecord = contactRecord;
            this.payments = payments != null ? payments : new List<Payment__c>();
        }
        
        public void addPayment(Payment__c payment){
            this.payments.add(payment);
        }
    }

    @AuraEnabled
    public static UIResponse init(Id projectId) { 
        Project__c project = [SELECT Id, Name, Total_Payments__c FROM Project__c WHERE Id = : projectId LIMIT 1];
        Map<Id, ProjectContact> contactToProjectContact = new Map<Id, ProjectContact>();
        for (Payment__c payment : [SELECT Id, Name, Contact__c, Contact__r.Id, Contact__r.Name, Amount__c, CreatedDate, Project__c, Project__r.Total_Payments__c FROM Payment__c WHERE Project__c = : projectId ORDER BY CreatedDate DESC LIMIT 50000]) {
            if(contactToProjectContact.containsKey(payment.Contact__r.Id)){
                ProjectContact pcInContext = contactToProjectContact.get(payment.Contact__r.Id);
                pcInContext.addPayment(payment);
                contactToProjectContact.put(payment.Contact__r.Id, pcInContext);
            } else {
                ProjectContact pcInContext = new ProjectContact(payment.Contact__r, new List<Payment__c>{payment});
                contactToProjectContact.put(payment.Contact__r.Id, pcInContext);                
            }
        }
        return new UIResponse(project.Name, (Double) project.Total_Payments__c, contactToProjectContact.values());
    }
    
    @AuraEnabled
    public static void updateProjectPayment(Id recordId, Double newAmount) { 
        if (recordId == null || newAmount == null) system.debug('NULL!');
        update new Payment__c(Id = recordId, Amount__c = newAmount);
    }
    
    @AuraEnabled
    public static boolean deleteProjectPayment(Id recordId) { 
        if (recordId == null) return false;
        delete new Payment__c(Id = recordId);
        return true;
    }    
}