trigger ProjectPaymentProcess on Payment__c (After Insert, After Delete, After Update) {
    //Create new instance of ProjectPaymentService 
    if(trigger.isInsert) {
        ProjectPaymentService service = new ProjectPaymentService(Trigger.newMap, ProjectPaymentService.PaymentAction.AddPayment);    
    } else if (trigger.isUpdate) {
        ProjectPaymentService service = new ProjectPaymentService(Trigger.newMap, Trigger.oldMap, ProjectPaymentService.PaymentAction.UpdatePayment);  
    } else if (trigger.isDelete) {
       ProjectPaymentService service = new ProjectPaymentService(Trigger.oldMap, ProjectPaymentService.PaymentAction.DeletePayment);   
    }
}