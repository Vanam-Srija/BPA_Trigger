const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { Requests, RequestItems } = this.entities;

  this.on('sendforapproval', async (req) => {
    const requestId = req.params[0].requestid;  

    console.log('Request ID:', requestId);

    try {
      // Fetch Request Header
      const payload_bpa_header = await SELECT.one.from(Requests).where({ requestid: requestId });
      
      if (!payload_bpa_header) {
        return req.reject(404, `Request ID ${requestId} not found`);
      }

      // Fetch Request Items (Fixing Association Filtering)
      const payload_bpa_items = await SELECT.from(RequestItems).where({ Request_requestid: requestId });

      const product_api = await cds.connect.to('WFDestination');

      let payload = {
        "definitionId": "us10.buyerportalpoc-aeew31u1.requestorder.orderProcesssing",
        "context": {
            "input": {
              "requestid": payload_bpa_header.requestid,
              "requestno": payload_bpa_header.requestno,
              "requestdesc": payload_bpa_header.requestdesc,
              "requestby": payload_bpa_header.requestby,
              "totalprice": payload_bpa_header.totalprice,
              "requestitems": payload_bpa_items.map(item => ({
                "ItemPrice": item.ItemPrice,
                "Quantity": item.Quantity,
                "Material": item.Material,
                "Plant": item.Plant,
                "ItemNo": item.ItemNo,
                "ItemDesc": item.ItemDesc
              }))
            }
        }
      };

      let oResult = await product_api.tx(req).post('/workflow/rest/v1/workflow-instances', payload);
      console.log("Workflow Response:", oResult);

      req.reply({ message: "Approval process initiated successfully!" });

    } catch (error) {
      console.error('Error triggering workflow:', error);
      req.reject({ message: `Error: ${error.message}` });
    }
  });
});
