using my.company as db from '../db/EmailList';

service PurchaseApproval @(path: 'PurchaseApproval') {
  entity Requests @(odata.draft.enabled: true) as projection on db.Requests
        actions{
        action sendforapproval();
    };
  entity RequestItems as projection on db.RequestItems;
  entity EmailList as projection on db.EmailList;
  function chooseApprover(totalPrice: Integer) returns array of EmailList;
}
