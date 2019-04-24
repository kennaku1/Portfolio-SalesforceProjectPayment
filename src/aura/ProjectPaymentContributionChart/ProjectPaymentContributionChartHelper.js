({
	navigateToRecord : function(component, recordId) {
        let sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": recordId,
            "slideDevName": 'related'
        });
        sObjectEvent.fire();
	}
})