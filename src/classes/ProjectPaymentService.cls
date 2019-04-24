public class ProjectPaymentService {
    public static final Double startingAmount = 0.00;
    public Enum PaymentAction { AddPayment, DeletePayment, UpdatePayment }
    public final Map<Id, Payment__c> payments { get; private set; }
    public final Map<Id, Payment__c> oldPayments { get; private set; }
    public Set<Id> projectIds { get; private set; }
    
    public ProjectPaymentService(final Map<Id, Payment__c> payments, PaymentAction action) { //Constructor for AddPayment and DeletePayment
        this.payments = payments;
        this.projectIds = new Set<Id>();
        for(Payment__c payment : this.payments.values()){
            if (payment.Project__c != null) this.projectIds.add(payment.Project__c);        
        }
        
        if (action == PaymentAction.AddPayment) { //trigger.isInsert insert
            addPayments();        
        } else if (action == PaymentAction.DeletePayment) { //trigger.isDelete action
            removePayments(); 
        } else {
            system.debug('Invalid Action for Contructor');
            //handle error here.example: throw new PaymentException('Incorrect constructor'); 
        }
    }
    
    public ProjectPaymentService(final Map<Id,Payment__c> newPayments, final Map<Id,Payment__c> oldPayments, PaymentAction action) { //trigger.isUpdate 
        if (action != PaymentAction.UpdatePayment) return; //Handle error here
        this.payments = newPayments;
        this.oldPayments = oldPayments;
        this.projectIds = new Set<Id>();
        for(Payment__c payment : this.payments.values()) {
            if (payment.Project__c != null) this.projectIds.add(payment.Project__c);        
        }
        
        if (action == PaymentAction.UpdatePayment) {
            updatePayments();        
        } else {
            system.debug('Invalid Action for Contructor');
            //handle error here.example: throw new PaymentException('Incorrect constructor'); 
        }
    }    
    
    private void addPayments() { //When new records are inserted 
        if (this.validatePaymentProcess()) return;
        Map<Id, Project__c> projects =  getProjects();
        for(Payment__c payment : this.payments.values()) {
            if (payment.Amount__c != null && payment.Project__c != null) {
                if (projects.containsKey(payment.Project__c)) {
                    Project__c projectInContext = projects.get(payment.Project__c);
                    if (projectInContext.Total_Payments__c == null) projectInContext.Total_Payments__c = startingAmount;
                    projectInContext.Total_Payments__c += payment.Amount__c;
                    projects.put(
                        payment.Project__c,
                        projectInContext
                    );
                }                
            } else {
                //Handle records without projects defined..
            }
        }
        
        if (projects.size() > 0) update projects.values();
    }
    
    private void removePayments() { //When records are deleted
        if (this.validatePaymentProcess()) return;
        Map<Id, Project__c> projects = getProjects();
        for(Payment__c payment : this.payments.values()) {
            if (payment.Amount__c != null && payment.Project__c != null) {
                if (projects.containsKey(payment.Project__c)) {
                    Project__c projectInContext = projects.get(payment.Project__c);
                    projectInContext.Total_Payments__c -= payment.Amount__c;
                    projects.put(
                        payment.Project__c,
                        projectInContext
                    );
                }                
            } else {
                //Handle records without projects defined..
            }
        } 
        
        if (projects.size() > 0) update projects.values();
    }
    
    private void updatePayments() { //When new records are inserted 
        if (this.validatePaymentProcess()) return;
        Map<Id, Project__c> projects =  getProjects();
        for(Payment__c payment : this.payments.values()) {
            if (payment.Amount__c != null && payment.Project__c != null) {
                if (projects.containsKey(payment.Project__c) && payment.Amount__c != oldPayments.get(payment.Id).Amount__c) {
                    Project__c projectInContext = projects.get(payment.Project__c);
                    if (projectInContext.Total_Payments__c == null) projectInContext.Total_Payments__c = startingAmount;
                    projectInContext.Total_Payments__c -= oldPayments.get(payment.Id).Amount__c; //Subtract original amount
                    projectInContext.Total_Payments__c += payment.Amount__c; //Add new amount
                    projects.put(
                        payment.Project__c,
                        projectInContext
                    );
                }                
            } else {
                //Handle records without projects defined..
            }
        }
        
        if (projects.size() > 0) update projects.values();
    }  
    
    private Map<Id, Project__c> getProjects() {
        if (this.projectIds == null) return new Map<Id, Project__c>();
        return new Map<Id, Project__c>(
            [SELECT Id, Name, Total_Payments__c 
                FROM Project__c 
                WHERE Id IN : this.projectIds]
        );
    }    
    
    private boolean validatePaymentProcess() {
        return this.payments == null || this.payments.size() == 0 || this.projectIds == null || this.projectIds.size() == 0;
    }
}