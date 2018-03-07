/**
 * Created by charlottew on 8/8/2017.
 */
({
    doInitAndRedirect : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:camping",
            componentAttributes: {
                "recordId" : component.get("v.recordId")
            }
        });
        evt.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})