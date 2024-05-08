public with sharing class ContactTriggerHandler extends TriggerHandler{

    private List<Contact> newContList;
    private List<Contact> oldContList;

    public ContactTriggerHandler() {
        this.newContList = (List<Contact>) Trigger.new;
        this.oldContList = (List<Contact>) Trigger.old;
    }

    public override void beforeInsert() {
        // When a contact is inserted
        for (Contact cont : newContList) {
            // if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
            if (cont.DummyJSON_Id__c == null) {
                cont.DummyJSON_Id__c = String.valueOf(Math.roundToLong(Math.random()*100));
            }

            // if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
            if (Integer.valueOf(cont.DummyJSON_Id__c) <= 100 && !System.IsFuture()) {
                DummyJSONCallout.getDummyJSONUserFromId(cont.DummyJSON_Id__c);
            }
        }
    }

    public override void beforeUpdate() {
        //When a contact is updated
		for (Contact cont : newContList) {
            // if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
			if (Integer.valueOf(cont.DummyJSON_Id__c) > 100 && !System.IsFuture()) {
				DummyJSONCallout.postCreateDummyJSONUser(cont.Id);
			}
		}
    }
}