codeunit 50643 "Portal Mgt"
{
    procedure SendEmployeeToHRMS(var Employee: Record Employee)
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
        JsonResponse: JsonObject;
        MessageValue: JsonToken;
    begin
        PortalSetup.Get();
        BaseUrl := PortalSetup."Base Url" + PortalSetup."Employee Url";
        // Employee.TestField("E-Mail");
        // Employee.TestField("First Name");
        // Employee.TestField("Last Name");
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
        if PortalSetup."Print Payload" then
            Message(RequestBody + ' ' + BaseUrl);
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(BaseUrl);
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpHeaders.Add('X-BC-Webhook-Key', PortalSetup."Authorization Key");
        HttpRequestMessage.Content(HttpContent);
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                JsonResponse.ReadFrom(ResponseText);
                if PortalSetup."Print Payload" then
                    Message(ResponseText);
                if JsonResponse.Get('data', MessageValue) then begin
                    if MessageValue.IsObject then begin
                        JsonObject := MessageValue.AsObject();
                        if JsonObject.Get('message', MessageValue) then;
                    end;
                    Message('Message: %1', MessageValue.AsValue().AsText())
                end;
                Employee."Pushed to the Post" := true;
                Employee.Modify()
            end else
                Message('Request failed: %1', HttpResponseMessage.ReasonPhrase());
        end;

    end;


    procedure SendVendorToHRMS(var Vendor: Record Vendor)
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
        JsonResponse: JsonObject;
        MessageValue: JsonToken;
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
        if PortalSetup."Print Payload" then
            Message(RequestBody + ' ' + BaseUrl);
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(BaseUrl);
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpHeaders.Add('X-BC-Webhook-Key', PortalSetup."Authorization Key");
        HttpRequestMessage.Content(HttpContent);
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                JsonResponse.ReadFrom(ResponseText);
                if PortalSetup."Print Payload" then
                    Message(ResponseText);
                if JsonResponse.Get('data', MessageValue) then begin
                    if MessageValue.IsObject then begin
                        JsonObject := MessageValue.AsObject();
                        if JsonObject.Get('message', MessageValue) then;
                    end;
                    Message('Message: %1', MessageValue.AsValue().AsText())
                end;
                Vendor."Pushed to the Post" := true;
                Vendor.Modify()
            end else
                Message('Request failed: %1', HttpResponseMessage.ReasonPhrase());
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
        JsonResponse: JsonObject;
        MessageValue: JsonToken;
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
        if PortalSetup."Print Payload" then
            Message(RequestBody + ' ' + BaseUrl);
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(BaseUrl);
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');
        HttpHeaders.Add('X-BC-Webhook-Key', PortalSetup."Authorization Key");
        HttpRequestMessage.Content(HttpContent);
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                JsonResponse.ReadFrom(ResponseText);
                if PortalSetup."Print Payload" then
                    Message(ResponseText);
                if JsonResponse.Get('data', MessageValue) then begin
                    if MessageValue.IsObject then begin
                        JsonObject := MessageValue.AsObject();
                        if JsonObject.Get('message', MessageValue) then;
                    end;
                    Message('Message: %1', MessageValue.AsValue().AsText())
                end;
            end else
                Message('Request failed: %1', HttpResponseMessage.ReasonPhrase());
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::Employee, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterEmployeeInsert(var Rec: Record Employee)  // Your logic here end;
    begin
        if (Rec."No." <> '') and (Rec."First Name" <> '') and (Rec."Last Name" <> '') and
          (Rec."E-Mail" <> '') Then
            if not Rec."Pushed to the Post" then
                SendEmployeeToHRMS(Rec)
    end;

    [EventSubscriber(ObjectType::Table, Database::Employee, OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterEmployeeModify(var Rec: Record Employee)
    begin
        if Rec."Pushed to the Post" then
            UpdateEmployeeStatusToHRMS(Rec)
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterVendorInsert(var Rec: Record Vendor)
    begin
        if (Rec."No." <> '') and (Rec.Name <> '') and (Rec."E-Mail" <> '') Then
            if not Rec."Pushed to the Post" then
                SendVendorToHRMS(Rec)
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterModifyEvent(var Rec: Record Vendor)
    begin
        if (Rec."No." <> '') and (Rec.Name <> '') and (Rec."E-Mail" <> '') Then
            if not Rec."Pushed to the Post" then
                SendVendorToHRMS(Rec)
    end;
}