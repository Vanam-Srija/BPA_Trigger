using my.company as db from '../db/EmailList';
 
service PurchaseApproval @(path: 'PurchaseApproval') {
  entity Requests @(odata.draft.enabled: true) as projection on db.Requests{
    *,
    requestitems : Composition of many RequestItems on requestitems.Request_requestid = requestid,
    case status
            when 'P' then 'Pending'
            when 'N' then 'New'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
            when 'E' then 'Edited'
            end as status : String(10),
        case status
            when 'P' then 2
            when 'N' then 2
            when 'A' then 3
            when 'X' then 1
            when 'E' then 4
            end as ColorCode : Integer,
  }
        actions{
        action sendforapproval();
        action responsefrombpa();
    };
  entity RequestItems as projection on db.RequestItems;
  action datafrombpa (requestid: Integer, status: String);
  action approveRequest (requestid: Integer);
  action rejectRequest (requestid: Integer);
  action updateRequestItems(
    requestid: Integer,
    status: String,
    //requestitems:  Array of RequestItems,
    requestitems:  Array of {
        ItemNo: Integer;
        ItemDesc: String;
        Quantity: Integer;
        ItemPrice: Integer;
        Material: String;
        Plant: String;
    }
) returns {
    requestid: Integer;
    status: String;
    //requestitems:  Array of RequestItems;
    requestitems: Array of {
        ItemNo: Integer;
      //Request_requestid: Integer;
        ItemDesc: String;
        Quantity: Integer;
        ItemPrice: Integer;
        Material: String;
        Plant: String;
    };
};
  entity EmailList as projection on db.EmailList;
  function approverSelection(totalPrice: Integer) returns array of EmailList;
}