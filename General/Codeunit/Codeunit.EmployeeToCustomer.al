codeunit 50644 "Employee to Customer Mgt."
{
    procedure ConvertEmployeeToCustomer(var Employee: Record Employee): Code[20]
    var
        Customer: Record Customer;
        EmployeeName: Text[100];
    begin
        Employee.TestField("No.");
        Employee.TestField("First Name");
        Employee.TestField("Last Name");

        if Employee."Customer No." <> '' then begin
            if not Customer.Get(Employee."Customer No.") then
                Error(CustomerLinkNotFoundErr, Employee."No.", Employee."Customer No.");
            if Customer."Employee No." <> Employee."No." then
                Error(CustomerLinkConflictErr, Employee."No.", Customer."No.");
            if Customer.Type <> Customer.Type::Staff then
                Error(CustomerNotStaffErr, Customer."No.");
            exit(Customer."No.");
        end;

        Customer.SetRange("Employee No.", Employee."No.");
        if Customer.FindFirst() then begin
            if Customer.Next() <> 0 then
                Error(MultipleCustomersErr, Employee."No.");

            Employee.Validate("Customer No.", Customer."No.");
            exit(Customer."No.");
        end;

        Customer.Reset();
        Customer.SetRange(Type, Customer.Type::Staff);
        Customer.SetRange("No. 2", Employee."No.");
        if Customer.FindFirst() then begin
            if Customer.Next() <> 0 then
                Error(MultipleCustomersErr, Employee."No.");
            if Customer."Employee No." <> '' then
                Error(CustomerLinkConflictErr, Employee."No.", Customer."No.");

            Customer.Validate("Employee No.", Employee."No.");
            Customer.Modify(true);
            Employee.Validate("Customer No.", Customer."No.");
            Employee.Modify(true);
            exit(Customer."No.");
        end;

        EmployeeName := GetEmployeeName(Employee);
        Customer.Init();
        Customer."No." := '';
        Customer.Validate(Name, EmployeeName);
        Customer.Validate(Type, Customer.Type::Staff);
        Customer.Validate("Employee No.", Employee."No.");
        Customer.Validate(Address, Employee.Address);
        Customer.Validate("Address 2", Employee."Address 2");
        Customer.Validate(City, Employee.City);
        Customer.Validate(County, Employee.County);
        Customer.Validate("Post Code", Employee."Post Code");
        Customer.Validate("Country/Region Code", Employee."Country/Region Code");
        Customer.Validate(Contact, EmployeeName);
        Customer.Validate("Phone No.", Employee."Phone No.");
        Customer.Validate("Mobile Phone No.", Employee."Mobile Phone No.");
        Customer.Validate("E-Mail", Employee."E-Mail");
        Customer.Insert(true);
        Employee.Validate("Customer No.", Customer."No.");
        Employee.Modify(true);

        exit(Customer."No.");
    end;

    local procedure GetEmployeeName(Employee: Record Employee): Text[100]
    var
        EmployeeName: Text[100];
    begin
        EmployeeName := Employee."First Name";
        if Employee."Middle Name" <> '' then
            EmployeeName := CopyStr(EmployeeName + ' ' + Employee."Middle Name", 1, MaxStrLen(EmployeeName));
        if Employee."Last Name" <> '' then
            EmployeeName := CopyStr(EmployeeName + ' ' + Employee."Last Name", 1, MaxStrLen(EmployeeName));

        exit(EmployeeName);
    end;

    var
        CustomerLinkConflictErr: Label 'Employee %1 cannot be converted because customer %2 already exists and is not linked to this employee.', Comment = '%1 = Employee No.; %2 = Customer No.';
        CustomerLinkNotFoundErr: Label 'Employee %1 is linked to customer %2, but that customer does not exist.', Comment = '%1 = Employee No.; %2 = Customer No.';
        CustomerNotStaffErr: Label 'Customer %1 is linked to an employee but is not classified as Staff.', Comment = '%1 = Customer No.';
        MultipleCustomersErr: Label 'Customer is linked to employee %1.', Comment = '%1 = Employee No.';
}
