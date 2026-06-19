codeunit 50643 "Portal Mgt"
{
    procedure SendEmployeeToHRMS(Employee: Record Employee)
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        JsonObject: JsonObject;
        RequestBody: Text;
        BaseUrl: Text[200];
        PortalSetup: Record "Portal Mgt";
        JsonString: Text;
        ResponseText: Text;
    begin
        PortalSetup.Get();
        BaseUrl := PortalSetup."Base Url" + PortalSetup."Employee Url";
        Employee.TestField("E-Mail");
        Employee.TestField("First Name");
        Employee.TestField("Last Name");
        JsonObject.Add('employeeNo', Employee."No.");
        JsonObject.Add('firstName', Employee."First Name");
        JsonObject.Add('lastName', Employee."Last Name");
        JsonObject.Add('email', Employee."E-Mail");
        JsonObject.Add('phoneNo', Employee."Mobile Phone No.");
        JsonObject.Add('department', Employee."Global Dimension 1 Code");
        JsonObject.Add('branchCode', Employee."Global Dimension 2 Code");
        // JsonObject.Add('engagementType', Employee.);
        JsonObject.Add('gender', Format(Employee.Gender));
        JsonObject.Add('dateOfEmployment', Format(Employee."Employment Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        JsonObject.WriteTo(RequestBody);
        Message(RequestBody);
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(BaseUrl);
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpHeaders.Add('X-BC-Webhook-Key', PortalSetup."Authorization Key");
        HttpRequestMessage.Content(HttpContent);
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            JsonString := '';
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(JsonString);
                Message(JsonString);
            end else
                HttpResponseMessage.Content.ReadAs(ResponseText);
            Message(ResponseText);
            // Error('Failed to sync employee to HRMS: %1', HttpResponseMessage.ReasonPhrase());
        end;
    end;


    procedure SendVendorToHRMS(Vendor: Record Vendor)
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        JsonObject: JsonObject;
        RequestBody: Text;
        BaseUrl: Text[200];
        PortalSetup: Record "Portal Mgt";
        JsonString: Text;
        ResponseText: Text;
    begin
        PortalSetup.Get();
        BaseUrl := PortalSetup."Base Url" + PortalSetup."Vendor Url";
        JsonObject.Add('no', Vendor."No.");
        JsonObject.Add('name', Vendor.Name);
        // JsonObject.Add('accountNo', Vendor.);
        JsonObject.Add('genBusPostingGroup', Vendor."Gen. Bus. Posting Group");
        JsonObject.Add('currencyCode', Vendor."Currency Code");
        JsonObject.Add('email', Vendor."E-Mail");
        // JsonObject.Add('category', Vendor.);
        JsonObject.Add('shortcutDimension1Code', Vendor."Global Dimension 1 Code");
        JsonObject.Add('phoneNo', Vendor."Phone No.");
        JsonObject.WriteTo(RequestBody);
        //Message(RequestBody);
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(BaseUrl);
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpHeaders.Add('X-BC-Webhook-Key', PortalSetup."Authorization Key");
        HttpRequestMessage.Content(HttpContent);
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            JsonString := '';
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(JsonString);
                Message(JsonString);
            end else
                HttpResponseMessage.Content.ReadAs(ResponseText);
            Message(ResponseText);
            // Error('Failed to sync employee to HRMS: %1', HttpResponseMessage.ReasonPhrase());
        end;
    end;

    procedure UpdateEmployeeStatusToHRMS(Employee: Record Employee)
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        JsonObject: JsonObject;
        RequestBody: Text;
        BaseUrl: Text[200];
        PortalSetup: Record "Portal Mgt";
        JsonString: Text;
        ResponseText: Text;
    begin
        PortalSetup.Get();
        BaseUrl := PortalSetup."Base Url" + PortalSetup."Update Employee Status Url";
        JsonObject.Add('employeeNo', Employee."No.");
        if Employee.Status = Employee.Status::Active then begin
            JsonObject.Add('action', 'enable');
            JsonObject.Add('reason', 'Reinstated')
        end else begin
            JsonObject.Add('action', 'disable');
            JsonObject.Add('reason', 'Terminated')
        end;
        JsonObject.WriteTo(RequestBody);
        //Message(RequestBody);
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(BaseUrl);
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpHeaders.Add('X-BC-Webhook-Key', PortalSetup."Authorization Key");
        HttpRequestMessage.Content(HttpContent);
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            JsonString := '';
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(JsonString);
                Message(JsonString);
            end else
                HttpResponseMessage.Content.ReadAs(ResponseText);
            Message(ResponseText);
            // Error('Failed to sync employee to HRMS: %1', HttpResponseMessage.ReasonPhrase());
        end;
    end;


}