using my.company as db from '../db/EmailList';

service PurchaseApproval @(path: 'PurchaseApproval') {
  entity Requests @(odata.draft.enabled: true) as projection on db.Requests{
    *,
    requestitems,
    case status
            when 'P' then 'Pending'
            when 'N' then 'New'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
            end as status : String(10),
        case status
            when 'P' then 2
            when 'N' then 2
            when 'A' then 3
            when 'X' then 1
            end as ColorCode : Integer,
  }
        actions{
        action sendforapproval();
        action responsefrombpa();
    };
  action datafrombpa (requestid: String, status: String);
  action approveRequest (requestid: String);
  action rejectRequest (requestid: String);
  //function getOrderDefaults() returns Requests;
  entity RequestItems as projection on db.RequestItems;
  entity EmailList as projection on db.EmailList;
  function approverSelection(totalPrice: Integer) returns array of EmailList;
}
