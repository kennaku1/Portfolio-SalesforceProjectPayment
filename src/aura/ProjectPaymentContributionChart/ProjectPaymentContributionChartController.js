({
	 doInit : function(component, event, helper) {
	    let action = component.get('c.init');
	    let recordId = component.get('v.recordId'); 
	    console.log('recordId ', recordId);
	    action.setParams({
	        projectId : recordId
	    });
	    action.setCallback(this, function(response) {
	        let state = response.getState();
	        if (state === 'SUCCESS') {
	            component.set('v.UIResponse', response.getReturnValue());
	        } else {
	            alert('error: ','Failed to retrive data');
	        }
	    });
	    $A.enqueueAction(action);
	},
    newPayment: function (component) {
        let createRecordEvent = $A.get('e.force:createRecord');
        let currentWindowHash = window.location.hash;
        createRecordEvent.setParams({
            'entityApiName': 'Payment__c',
            'defaultFieldValues': {
                'Project__c' : component.get('v.recordId')
            },
            "panelOnDestroyCallback": function(event) {
                window.location.hash = currentWindowHash;
            }              
        });
        createRecordEvent.fire();
    },
    
    deletePayment: function (component, event, helper) {
	    let action = component.get('c.deleteProjectPayment');
	    let recordId = event.target.getAttribute('data-sfid');
	    action.setParams({
	        recordId : recordId
	    });
	    action.setCallback(this, function(response) {
	        let state = response.getState();
	        if (state === 'SUCCESS') {
	            helper.navigateToRecord(component, component.get("v.recordId"));
	        } else {
	            alert('error: ','Failed to delete record');
	        }
	    });
	    $A.enqueueAction(action);        
    }, 
    
    updatePayment: function (component, event, helper) {
	    let action = component.get('c.updateProjectPayment');
	    let recordId = event.target.id;
	    let element = document.getElementById(recordId);
	    let newAmount =  element.value;
	    action.setParams({
	        recordId : recordId,
	        newAmount : newAmount
	    });
	    action.setCallback(this, function(response) {
	        let state = response.getState();
	        if (state === 'SUCCESS') {
	            helper.navigateToRecord(component, component.get("v.recordId"));
	        } else {
	            alert('error: Failed to update record');
	        }
	    });
	    if (parseFloat(newAmount) === NaN) alert('error: Invalid Number :' + parseFloat(newAmount));
	    else $A.enqueueAction(action);        
    },     
    
    navigateToPayment: function (component, event, helper) {
        helper.navigateToRecord(component, event.target.getAttribute('data-sfid'));
    }
})