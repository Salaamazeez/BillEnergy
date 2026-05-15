// table 50501 "Store Requisition Line2"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Document No."; Code[60]) { }
//         field(2; "Line No."; Integer)
//         {
//             AutoIncrement = true;
//         }
//         field(3; "Stock Code"; Code[50])
//         {
//             TableRelation = IF (Type = FILTER(Asset)) "Fixed Asset"."No."
//             ELSE
//             IF (Type = FILTER(Stock)) Item.No.
//                                                                  ELSE IF (Type=FILTER(Service)) "G/L Account".No.;
//                                                    OnValidate=BEGIN
//                                                                 TestStatusOpenLine;

//                                                                 IF (Type =Type::Stock) THEN BEGIN
//                                                                   IF Item.GET("Stock Code") THEN
//                                                                   VALIDATE(Description,Item.Description);
//                                                                   VALIDATE("Unit Price",Item."Unit Cost");
//                                                                   "Unit of Issue" := Item."Base Unit of Measure";
//                                                                   Item.CALCFIELDS(Inventory);
//                                                                   "Qty in Store at Request" := Item.Inventory;

//                                                                 END ELSE BEGIN
//                                                                   Description := '';
//                                                                   "Unit Price" := 0;
//                                                                   "Unit of Issue" := '';
//                                                                   Value := 0;
//                                                                   "Qty in Store at Request" := 0;
//                                                                  END;

//                                                                 IF (Type =Type::Asset)  THEN BEGIN
//                                                                    IF FA.GET("Stock Code") THEN
//                                                                      VALIDATE(Description,FA.Description);
//                                                                      VALIDATE("Location Code",FA."Location Code");
//                                                                 END;

//                                                                 IF (Type = Type::Service) THEN BEGIN
//                                                                   IF "g/lacc".GET("Stock Code") THEN
//                                                                     VALIDATE(Description,"g/lacc".Name);
//                                                                 END;



//                                                                 {IF (Type =Type::Stock) THEN BEGIN
//                                                                    IF Item.GET("Stock Code") THEN
//                                                                      VALIDATE(Description,Item.Description);
//                                                                      VALIDATE("Unit Price",Item."Unit Cost");
//                                                                      "Unit of Issue" := Item."Base Unit of Measure";
//                                                                      Item.CALCFIELDS(Inventory);
//                                                                     "Qty in Store at Request" := Item.Inventory;

//                                                                  END ELSE BEGIN
//                                                                      Description := '';
//                                                                      "Unit Price" := 0;
//                                                                      "Unit of Issue" := '';
//                                                                      Value := 0;
//                                                                     "Qty in Store at Request" := 0;
//                                                                  END;}
//                                                                 //IF Vendor.GET("No.") THEN
//                                                                 //  Description := Vendor.Name;
//                                                               END;
//                                                                }
// //   field(4 ;Description ;Text[50])
// //   {
// //     Editable=false; 
// //     }
// //    field( 5 ;"Unit of Issue" ;Code[50])
// //    {
// //      Editable=No;
// //     }
// //    field( 6  ;Requested Qty. ;Decimal)
// //   trigger OnValidate
// //   BEGIN
// //                                                                 TestStatusOpenLine;
// //                                                                 TESTFIELD("Location Code");
// //                                                                 Item.SETCURRENTKEY("No.");
// //                                                                 Item.SETRANGE("No.","Stock Code");
// //                                                                 Item.SETFILTER("Location Filter",'%1',"Location Code");
// //                                                                 IF Item.FINDFIRST THEN BEGIN
// //                                                                   Item.CALCFIELDS("Net Change");
// //                                                                   "Qty in Store at Request" := Item."Net Change";
// //                                                                   "Qty in Store at the moment" := Item."Net Change";
// //                                                                   IF Item."Net Change" < "Requested Qty." THEN
// //                                                                     MESSAGE(Text001);
// //                                                                 END;

// //                                                                 "Requested Value" := "Unit Price" * "Requested Qty.";
// //                                                               END;

// //                                                    DecimalPlaces=0:0;
// //                                                    BlankZero=Yes }
// //    field( 7  ;"Issued Qty."  ;Decimal)
// //    {
// //      trigger OnValidate()
// //      BEGIN
// //  TESTFIELD("Location Code");
// //                                                                 ItemQty := "Issued Qty.";

// //                                                                 Item.SETCURRENTKEY("No.");
// //                                                                 Item.SETRANGE("No.","Stock Code");
// //                                                                 Item.SETFILTER("Location Filter",'%1',"Location Code");
// //                                                                 IF Item.FINDFIRST THEN BEGIN
// //                                                                   Item.CALCFIELDS("Net Change");
// //                                                                   IF Item."Net Change" < ItemQty THEN
// //                                                                     ERROR(Text001);
// //                                                                 END;
// //                                                                   IF "Issued Qty." > "Requested Qty." THEN
// //                                                                     ERROR('ISSUE QUANTITY CANNOT BE GREATER THAN REQUESTED QUANTITY');

// //                                                                 Value := "Unit Price" * "Issued Qty.";
// //                                                                 //"Requested Value" := "Unit Price" * "Requested Qty.";
// //                                                               END;

// //                                                    DecimalPlaces=0:0;
// //                                                    BlankZero=false; }
// //    field( 8  ;Unit Price   ;Decimal)
// //    {     
// //      BlankZero=true;
// //         Editable=false; 
// //   }
// //    field( 9 ;Value   ;Decimal){    BlankZero=true; }
// //  field(10 ;"Location Code" ;Code[50])
// //  {
// //    TableRelation=Location.Code
// //    }
// //    field(11  ;"Qty in Store at Request";Decimal)
// //    {Editable=false; }
// //   field( 12 ;"Qty in Store at the moment";Decimal)
// //   {FieldClass=FlowField;
// //    CalcFormula=Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Stock Code),
// //                                                                                                        Location Code=FIELD(Location Code)));
// //                                                    Editable=false; }
// //    field( 13  ;Account Type        ;Option        ;DataClassification=ToBeClassified;
// //                                                    OptionCaptionML=ENU=G/L Account,Bank;
// //                                                    OptionString=G/L Account,Bank }
// //     field( 14 ;"Account No."   ;Code[20]   ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account".No. WHERE (Blocked=FILTER(No),
// //                                                                                                                                Account Type=CONST(Posting))
// //                                                                                                                                ELSE IF (Account Type=CONST(Bank)) "Bank Account".No. WHERE (Blocked=CONST(No));
// //                                                    OnValidate=BEGIN

// //                                                                  IF "Account No." <> '' THEN BEGIN
// //                                                                   CASE "Account Type" OF
// //                                                                   0: BEGIN
// //                                                                        "g/lacc".GET("Account No.");
// //                                                                        "Account Description" := "g/lacc".Name;
// //                                                                        StoresRequisition."Shortcut Dimension 1 Code":="g/lacc"."Global Dimension 1 Code";
// //                                                                        StoresRequisition."Shortcut Dimension 2 Code" := "g/lacc"."Global Dimension 2 Code";
// //                                                                      END;
// //                                                                 //  1,5: BEGIN
// //                                                                 //       custrec.GET("Account No.");
// //                                                                 //       "Account Description" := custrec.Name;
// //                                                                 //       "Account Description2" := custrec.Address;
// //                                                                 //       "Global Dimension 1 Code" := custrec."Global Dimension 1 Code";
// //                                                                 //       "Global Dimension 2 Code":= custrec."Global Dimension 2 Code";
// //                                                                 //
// //                                                                 //     END;
// //                                                                 //   2,6: BEGIN
// //                                                                 //      vendrec.GET("Account No.");
// //                                                                 //      "Account Description" := vendrec.Name;
// //                                                                 //      "Account Description2" := custrec.Address;
// //                                                                 //      "Global Dimension 1 Code":= vendrec."Global Dimension 1 Code";
// //                                                                 //      "Global Dimension 2 Code":= vendrec."Global Dimension 2 Code";
// //                                                                 //      END;
// //                                                                    1,5: BEGIN
// //                                                                       bankrec.GET("Account No.");
// //                                                                       "Account Description" := bankrec.Name;
// //                                                                      // "Account Description2" := custrec.Address;
// //                                                                       StoresRequisition."Shortcut Dimension 1 Code":= bankrec."Global Dimension 1 Code";
// //                                                                       StoresRequisition."Shortcut Dimension 2 Code" := bankrec."Global Dimension 2 Code";
// //                                                                      END;
// //                                                                 //   4: BEGIN
// //                                                                 //      fixedrec.GET("Account No.");
// //                                                                 //      "Account Description" := fixedrec.Description;
// //                                                                 //      "Account Description2" := custrec.Address;
// //                                                                 //      "Global Dimension 1 Code" := fixedrec."Global Dimension 1 Code";
// //                                                                 //      "Global Dimension 2 Code":=fixedrec."Global Dimension 2 Code";
// //                                                                 //      FADepBk.GET("Account No.",'MEL');
// //                                                                 //      "Depreciation Book Code" := FADepBk."Depreciation Book Code";
// //                                                                 //     END;
// //                                                                   END;
// //                                                                 END;
// //                                                               END;

// //                                                    DataClassification=ToBeClassified }
// //   field(15  ;"Account Description" ;Text[50])
// //   {
// //    trigger  OnValidate()

// //     BEGIN

// //                                                                 //"Transaction Description" := "Account Description";
// //                                                               END;
// //   }
// //                                                    DataClassification=ToBeClassified }
// //    field( 16 ;"Cash/Cheque"         ;Option){
// //      DataClassification=ToBeClassified;
// //        OptionString=Cash,Cheque }

// //   field( 18  ;   "Gen Bus. Posting Group";Code[50]){
// //     TableRelation="Gen. Business Posting Group";
// //                                                    DataClassification=ToBeClassified }
// field(22 ;Type  ;Option )
// {
//  DataClassification=ToBeClassified;
//                                                    OptionCaptionML=ENU=,Asset,Stock,Project;
//                                             OptionMembers      =,Asset,Stock,Service

//   trigger OnValidate()
// BEGIN
//                                                                 TestStatusOpenLine;
//                                                               END; }
//  field( 25   ;"Shortcut Dimension 1 Code";Code[20]){
//   //  TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1), Blocked=CONST(No));
//   //                                                trigger  OnValidate()
//   //                                                BEGIN
//   //                                                               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
//   //                                                END;

//   //                                                  DataClassification=ToBeClassified;
//   //                                                  CaptionML=ENU=Shortcut Dimension 1 Code;
//   //                                                  CaptionClass='1,2,1' }
// field(26  ;  "Shortcut Dimension 2 Code";Code[20]){
//   // TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2), Blocked=CONST(false));
//   //                                               trigger   OnValidate()
//   //                                               BEGIN
//   //                                                               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
//   //                                                             END;

//   //                                                  DataClassification=ToBeClassified;
//   //                                                  CaptionML=ENU=Shortcut Dimension 2 Code;
//   //                                                  CaptionClass='1,2,2' }
//  field(27  ;   ;Requested Value     ;Decimal       ;DataClassification=ToBeClassified }
//     }

//     keys
//     {
//         key(PK; MyField)
//         {
//             Clustered = true;
//         }
//     }

//     var
//         myInt: Integer;

//     trigger OnInsert()
//     begin

//     end;

//     trigger OnModify()
//     begin

//     end;

//     trigger OnDelete()
//     begin

//     end;

//     trigger OnRename()
//     begin

//     end;

// }