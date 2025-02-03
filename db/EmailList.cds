namespace my.company;

entity EmailList {
    key ID : Integer;
    email : String;
    name : String;
    approvalValue : Integer;
}

entity Requests {
    key requestid  : String;
    requestno      : String;
    requestdesc    : String;
    requestby      : String;
    totalprice     : Integer;
    requestitems   : Composition of many RequestItems on requestitems.Request = $self;
}


entity RequestItems {
    key ItemNo     : String;
    ItemDesc       : String;
    Quantity       : Integer;
    ItemPrice      : Integer;
    Material       : String;
    Plant          : String;
    Request        : Association to Requests;
}
