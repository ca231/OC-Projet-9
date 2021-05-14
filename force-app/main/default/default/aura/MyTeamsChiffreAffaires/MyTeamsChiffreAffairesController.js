({
  doInit: function(component, event, helper) {
    var action = component.get("c.getCumulCAByOwner");
    action.setCallback(this, function(data) {
	component.set("v.Accounts", data.getReturnValue());
      console.log(data.getReturnValue());
        });
    $A.enqueueAction(action);
  }
})