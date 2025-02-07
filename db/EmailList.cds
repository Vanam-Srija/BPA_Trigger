namespace my.company;

entity EmailList {
    key ID : Integer;
    email : String;
    name : String;
    approvalValue : Integer;
}

entity Requests {
    key requestid  : Integer;
    requestno      : String;
    requestdesc    : String;
    requestby      : String;
    totalprice     : Integer @readonly;
    status         : String;
    requestitems   : Composition of many RequestItems on requestitems.Request = $self;
}


entity RequestItems {
    key ItemNo     : Integer;
    ItemDesc       : String;
    Quantity       : Integer;
    ItemPrice      : Integer;
    Material       : String;
    Plant          : String;
    Request        : Association to Requests;
}
