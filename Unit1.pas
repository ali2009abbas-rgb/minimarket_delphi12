unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Xml.xmldom,
  Xml.XmlTransform,Unit2, Unit3, Vcl.ComCtrls, Math;

type
  TForm1 = class(TForm)
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
    QryExchangeRate: TADOQuery;
    EditExchangeRate: TEdit;
    EditSearchItemName: TEdit;
    QryInventorySearch: TADOQuery;
    EditItemPriceSYP: TEdit;
    EditItemQuantity: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ButtonAdd: TButton;
    SalesGrid: TStringGrid;
    EditItemQuantityTaken: TEdit;
    EditGrandTotal: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListBoxSuggestions: TListBox;
    Label7: TLabel;
    ButtonCompleteSale: TButton;
    QryInventoryUpdate: TADOQuery;
    EditCustomerName: TEdit;
    QrySalesInsert: TADOQuery;
    XMLTransform1: TXMLTransform;
    Label9: TLabel;
    ButtonShowReport: TButton;
    Panel1: TPanel;
    Timer1: TTimer;
    ButtonDeleteRow: TButton;
    MemoItemNotes: TMemo;
    Label8: TLabel;
    Edit2: TEdit;
    Label10: TLabel;
    ButtonAddItem: TButton;
    ButtonEditItem: TButton;
    ButtonEditRate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EditSearchItemNameChange(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ListBoxSuggestionsClick(Sender: TObject);
    procedure ButtonCompleteSaleClick(Sender: TObject);
    procedure ButtonShowReportClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonDeleteRowClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonAddItemClick(Sender: TObject);
    procedure ButtonEditItemClick(Sender: TObject);
    procedure ButtonEditRateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

procedure PreparePrintReport(InvoiceID: Integer; CustomerName: string; GrandTotal: Double; SalesGrid: TStringGrid);

  //procedure UpdateItemDetails(const ItemName: string);
  //procedure AddSaleToGrid;
  //procedure UpdateGrandTotal;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  CurrentExchangeRate: Double;
  GrandTotalSYP: Double;
  LastInvoiceID: Integer = 0;

implementation

{$R *.dfm}

uses Unit4, Unit5;

// افترض أن لدينا TADOQuery باسم 'QryExchangeRate' موصول بـ 'ADOConnection1'

procedure TForm1.ButtonAddClick(Sender: TObject);
var
  ItemName: string;
  UnitPriceSYP: Double;
  RequestedQty: Integer;
  AvailableQty: Integer;
  LineTotal: Double;
  NewRowIndex: Integer;
  ItemCostUSD: Double; // تكلفة الوحدة بالدولار
  NewAvailableQty: Integer;
begin
  // 1. التحقق من صحة المدخلات
  if (EditItemPriceSYP.Text = '') or (EditItemQuantityTaken.Text = '') then
  begin
    ShowMessage('يجب البحث عن السلعة وتحديد الكمية المأخوذة.');
    Exit;
  end;

  // 2. قراءة القيم
  ItemName := EditSearchItemName.Text;
  UnitPriceSYP := StrToFloatDef(EditItemPriceSYP.Text, 0);
  RequestedQty := StrToIntDef(EditItemQuantityTaken.Text, 0);
  AvailableQty := StrToIntDef(EditItemQuantity.Text, 0);

  if RequestedQty <= 0 then
  begin
    ShowMessage('الرجاء إدخال كمية مأخوذة صالحة.');
    Exit;
  end;

  if RequestedQty > AvailableQty then
  begin
    ShowMessage('الكمية المطلوبة (' + IntToStr(RequestedQty) + ') تتجاوز الكمية المتوفرة (' + IntToStr(AvailableQty) + ').');
    Exit;
  end;

  // 3. **الخطوة الحاسمة: قراءة التكلفة بالدولار**
  // إضافة الأقواس لحل مشكلة 'string' and 'Boolean'
  if QryInventorySearch.Active and
     (QryInventorySearch.FieldByName('ItemName').AsString = ItemName) then
  begin
    // قراءة تكلفة الوحدة بالدولار مباشرة من الاستعلام المفتوح
    ItemCostUSD := QryInventorySearch.FieldByName('CostUSD').AsFloat;
  end
  else
  begin
    ItemCostUSD := 0;
    // ShowMessage('تحذير: فشل قراءة تكلفة الوحدة. سيتم استخدام قيمة 0 للأرباح.');
  end;

  // 4. الحسابات
  LineTotal := RequestedQty * UnitPriceSYP;

  // 5. إضافة سطر جديد إلى شبكة المبيعات (SalesGrid)
  NewRowIndex := SalesGrid.RowCount;
  SalesGrid.RowCount := NewRowIndex + 1;

  // حفظ البيانات المرئية (الأعمدة 0-3)
  SalesGrid.Cells[0, NewRowIndex] := ItemName;
  SalesGrid.Cells[1, NewRowIndex] := FormatFloat('0.00', UnitPriceSYP);
  SalesGrid.Cells[2, NewRowIndex] := IntToStr(RequestedQty);
  SalesGrid.Cells[3, NewRowIndex] := FormatFloat('0.00', LineTotal);

  // 6. **الخطوة الأهم: حفظ ItemCostUSD في العمود 4 المخفي**
  // هذا يضمن أن ButtonCompleteSaleClick سيجد القيمة لاحقاً لحساب الربح
  SalesGrid.Cells[4, NewRowIndex] := FormatFloat('0.00', ItemCostUSD);

  // 7. **إكمال الكود: تحديث الإجمالي الكلي (الأجزاء المفقودة)**
  GrandTotalSYP := GrandTotalSYP + LineTotal;
  EditGrandTotal.Text := FormatFloat('0.00', GrandTotalSYP);
  // ------------------------------------------------------------------
  // 8. **الخطوة الحاسمة: تحديث الكمية المعروضة محلياً**
  // ------------------------------------------------------------------

  // حساب الكمية الجديدة المتبقية في المخزون الحالي
  NewAvailableQty := AvailableQty - RequestedQty;

  // تحديث الحقل المعروض للكمية المتاحة
  EditItemQuantity.Text := IntToStr(NewAvailableQty);

  // ------------------------------------------------------------------
  // 9. **إكمال الكود: مسح حقول الإدخال للسلعة التالية**
  EditSearchItemName.Clear;
  EditItemPriceSYP.Clear;
  Edit2.Clear;
  EditItemQuantity.Clear;
  EditItemQuantityTaken.Clear;
  // ----------------------------------------------------
  // 10. **الخطوة الحاسمة: إعادة تهيئة استعلام البحث**
  // ----------------------------------------------------

  // إغلاق الاستعلام المفتوح
  QryInventorySearch.Close;

  // إعادة فتح الاستعلام لضمان قراءة البيانات المحدثة من ملف Excel
  // هذا يضمن أن البحث الجديد سيعرض حالة المخزون الحقيقية
  QryInventorySearch.Open;

  // ----------------------------------------------------
  SalesGrid.ColWidths[4] := -1;
end;

procedure TForm1.ButtonAddItemClick(Sender: TObject);
begin
  // 1. إنشاء النموذج إذا لم يكن موجوداً
  if not Assigned(AddItemForm) then
    AddItemForm := TAddItemForm.Create(Application);

  // 2. تمرير كائن الاتصال إلى النموذج الجديد
  AddItemForm.ADOConnection := ADOConnection1;

  // 3. عرض النموذج
  AddItemForm.ShowModal;
  EditSearchItemName.Clear;
  EditItemPriceSYP.Clear;
  Edit2.Clear;
  EditItemQuantity.Clear;
  EditItemQuantityTaken.Clear;
  // 4. (اختياري) إذا استخدمت ShowModal، يمكن تدميره بعد الإغلاق
  // AddItemForm.Free; // إذا وضعت Action := caFree في FormClose
end;

procedure TForm1.ButtonCompleteSaleClick(Sender: TObject);
var
  i: Integer;
  ItemName: string;
  QuantitySold: Integer;
  UnitPrice: Double;
  LineTotal: Double;
  CustomerName: string;
  CurrentInvoiceID: Integer;
  // المتغيرات الجديدة الخاصة بالربح
  UnitCostUSD: Double;
  SalePriceUSD: Double;
  LineProfitUSD: Double;
  GrandTotal: Double; // لجمع الإجمالي الكلي للطباعة
begin



  // ********* أولاً: التحقق والتهيئة *********

  CustomerName := EditCustomerName.Text;

  // التحقق من وجود بنود في الشبكة
  if SalesGrid.RowCount <= 1 then
  begin
    ShowMessage('يجب إضافة بنود إلى الفاتورة أولاً.');
    Exit;
  end;

  // عرض مربع حوار التأكيد مع الإجمالي الكلي
  if MessageDlg('هل أنت متأكد من إتمام هذه الفاتورة بقيمة إجمالية: ' + EditGrandTotal.Text + ' ل.س؟',
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    Exit; // الخروج من الإجراء إذا اختار المستخدم "لا"
  end;

  try
    // 1. بدء المعاملة (Start Transaction)
    ADOConnection1.BeginTrans;


      // توليد رقم الفاتورة التالي (وزيادة المتغير العام)
      LastInvoiceID := LastInvoiceID + 1;
      CurrentInvoiceID := LastInvoiceID;

      // قراءة الإجمالي الكلي المحسوب
      GrandTotal := StrToFloatDef(EditGrandTotal.Text, 0.0);


      // ********* ثانياً: تحديث المخزون وحفظ سجلات المبيعات *********

      for i := 1 to SalesGrid.RowCount - 1 do
      begin
        // 1. قراءة بيانات السطر من الشبكة
        ItemName     := trim(SalesGrid.Cells[0, i]);
        UnitPrice    := StrToFloatDef(SalesGrid.Cells[1, i], 0);    // سعر الوحدة ل.س
        QuantitySold := StrToIntDef(SalesGrid.Cells[2, i], 0);      // الكمية المباعة
        LineTotal    := StrToFloatDef(SalesGrid.Cells[3, i], 0);    // الإجمالي الجزئي ل.س

        // 1.1 قراءة تكلفة الوحدة المخزنة مؤقتاً (من العمود المخفي 4)
        UnitCostUSD := StrToFloatDef(SalesGrid.Cells[4, i], 0); // التكلفة بالدولار

        // 2. حساب قيمة الربح بالدولار
        if CurrentExchangeRate > 0 then
          SalePriceUSD := UnitPrice / CurrentExchangeRate
        else
          SalePriceUSD := 0;

        // الربح = (سعر البيع بالدولار - تكلفة الشراء بالدولار) * الكمية المباعة
        LineProfitUSD := (SalePriceUSD - UnitCostUSD) * QuantitySold;
        LineProfitUSD := SimpleRoundTo(LineProfitUSD, -2);
        QryInventoryUpdate.Connection := ADOConnection1;
        if (ItemName <> '') and (QuantitySold > 0) then
        begin
          // 2.1: تحديث المخزون (Inventory)
          QryInventoryUpdate.SQL.Clear;
          // نطرح الكمية المباعة من الكمية الحالية
          QryInventoryUpdate.SQL.Add('UPDATE [Inventory$] SET Quantity = Quantity - :Qty WHERE ItemName = :Item');
          QryInventoryUpdate.Parameters.ParamByName('Qty').Value := QuantitySold;
          QryInventoryUpdate.Parameters.ParamByName('Item').Value := ItemName;

          try
            QryInventoryUpdate.ExecSQL;

          except
            on E: Exception do
            begin
              ShowMessage('خطأ في تحديث المخزون للسلعة: ' + ItemName + '. الخطأ: ' + E.Message);
            end;
          end;
          QrySalesInsert.Connection := ADOConnection1;
          // 2.2: حفظ سجل المبيعات (Sales Records)
          QrySalesInsert.SQL.Clear;
          //QrySalesInsert.SQL.Add('INSERT INTO [Sales$] (InvoiceID, SaleDate, CustomerName, ItemName, Quantity, UnitPriceSYP, LineTotalSYP, UnitCostUSD, LineProfitUSD, PriceUSD)');
          //QrySalesInsert.SQL.Add('VALUES (:ID, :Date, :CustName, :Item, :Qty, :UnitP, :LineT, :Cost, :Profit,:SalePriceUSD)');

          QrySalesInsert.SQL.Add('INSERT INTO [Sales$] (InvoiceID, SaleDate, CustomerName, ItemName, Quantity, UnitPriceSYP, LineTotalSYP, UnitCostUSD, LineProfitUSD, PriceUSD)');
          QrySalesInsert.SQL.Add('VALUES (:ID, :Date, ' + QuotedStr(CustomerName) + ', ' + QuotedStr(ItemName) + ', :Qty, :UnitP, :LineT, :Cost, :Profit,:SalePriceUSD)');

          QrySalesInsert.Parameters.ParamByName('ID').Value := CurrentInvoiceID;
          QrySalesInsert.Parameters.ParamByName('Date').Value := Date;
        //  QrySalesInsert.Parameters.ParamByName('CustName').Value := CustomerName;
        //  QrySalesInsert.Parameters.ParamByName('Item').Value := ItemName;
          QrySalesInsert.Parameters.ParamByName('Qty').Value := QuantitySold;
          QrySalesInsert.Parameters.ParamByName('UnitP').Value := UnitPrice;
          QrySalesInsert.Parameters.ParamByName('LineT').Value := LineTotal;
          QrySalesInsert.Parameters.ParamByName('Cost').Value := UnitCostUSD;
          QrySalesInsert.Parameters.ParamByName('Profit').Value := LineProfitUSD;
        QrySalesInsert.Parameters.ParamByName('SalePriceUSD').Value := SalePriceUSD;

      try
        QrySalesInsert.ExecSQL;

      except
        on E: Exception do
        begin
          ShowMessage('خطأ في حفظ سجل المبيعات للسلعة: ' + ItemName + '. الخطأ: ' + E.Message);
        end;
      end;

    end;
    EditSearchItemName.SetFocus;
  end; // نهاية حلقة For


  // ********* ثالثاً: طباعة التقرير وتصفير الواجهة *********

  // 3.1: تجهيز وطباعة التقرير (إذا كانت الدالة موجودة)
  PreparePrintReport(CurrentInvoiceID, CustomerName, GrandTotal, SalesGrid);

  // 3.2: مسح الشبكة وإعادة التصفير
  SalesGrid.RowCount := 1;
  EditGrandTotal.Text := '0.00';
  EditCustomerName.Clear;
  GrandTotalSYP:=0;

 //***********************تعديلي انا
  // إغلاق الاستعلام المفتوح
  QryInventorySearch.Close;

  // إعادة فتح الاستعلام لضمان قراءة البيانات المحدثة من ملف Excel
  // هذا يضمن أن البحث الجديد سيعرض حالة المخزون الحقيقية
  QryInventorySearch.Open;
//****************اغلاف تغديلي


  // 3. إجبار الحفظ (Commit Transaction)
    ADOConnection1.CommitTrans;

  ShowMessage('تمت عملية البيع بنجاح. رقم الفاتورة: ' + IntToStr(CurrentInvoiceID));
  except
    on E: Exception do
    begin
      // 4. التراجع عن كل شيء إذا حدث أي خطأ
      ADOConnection1.RollbackTrans;
      ShowMessage('فشل في عملية التخزين. تم التراجع عن العملية. الخطأ: ' + E.Message);
    end;
  end;
end;

procedure TForm1.ButtonDeleteRowClick(Sender: TObject);
var
  SelectedRowIndex: Integer;
  LineTotalSYP: Double;
  ItemNameToDelete: string; // المتغير الجديد لاسم البضاعة
  i: Integer;
begin
  // 1. التحقق من وجود صفوف بيانات
  if SalesGrid.RowCount <= 1 then
  begin
    ShowMessage('لا توجد بنود لحذفها.');
    Exit;
  end;

  // 2. تحديد السطر المختار (يجب أن يكون >= 1)
  SelectedRowIndex := SalesGrid.Row;

  if SelectedRowIndex < 1 then
  begin
    ShowMessage('الرجاء تحديد سطر البضاعة الذي تريد حذفه.');
    Exit;
  end;

  // ----------------------------------------------------
  // **الخطوة الحاسمة: قراءة اسم البضاعة وعرض رسالة التأكيد**
  // ----------------------------------------------------

  // قراءة اسم البضاعة من العمود 0 للسطر المختار
  ItemNameToDelete := SalesGrid.Cells[0, SelectedRowIndex];

  // عرض مربع حوار التأكيد
  if MessageDlg('هل أنت متأكد من حذف الصنف: ' + ItemNameToDelete + '؟', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    Exit; // الخروج من الإجراء إذا اختار المستخدم "لا"
  end;

  // ----------------------------------------------------

  // 3. قراءة الإجمالي الجزئي للسطر المحذوف (العمود 3)
  LineTotalSYP := StrToFloatDef(SalesGrid.Cells[3, SelectedRowIndex], 0);

  // 4. حذف السطر (عن طريق نقل الصفوف للأعلى)
  if SelectedRowIndex < SalesGrid.RowCount - 1 then
  begin
    // نقل جميع الصفوف التي تلي السطر المحذوف إلى الأعلى
    for i := SelectedRowIndex to SalesGrid.RowCount - 2 do
    begin
      SalesGrid.Cells[0, i] := SalesGrid.Cells[0, i + 1];
      SalesGrid.Cells[1, i] := SalesGrid.Cells[1, i + 1];
      SalesGrid.Cells[2, i] := SalesGrid.Cells[2, i + 1];
      SalesGrid.Cells[3, i] := SalesGrid.Cells[3, i + 1];
      SalesGrid.Cells[4, i] := SalesGrid.Cells[4, i + 1];
    end;
  end;

  // 5. تقليل عدد الصفوف بواحد
  SalesGrid.RowCount := SalesGrid.RowCount - 1;

  // 6. تحديث الإجمالي الكلي
  GrandTotalSYP := GrandTotalSYP - LineTotalSYP;
  EditGrandTotal.Text := FormatFloat('0.00', GrandTotalSYP);

  // 7. فحص حالة القائمة وتعيين المؤشر
  if SalesGrid.RowCount = 1 then
  begin
    SalesGrid.Row := 0;
    ShowMessage('القائمة فارغة الآن');
  end
  else
  begin
    if SelectedRowIndex > SalesGrid.RowCount - 1 then
      SalesGrid.Row := SalesGrid.RowCount - 1
    else
      SalesGrid.Row := SelectedRowIndex;
  end;
end;

// في Unit1.pas

procedure TForm1.ButtonEditItemClick(Sender: TObject);
var
  ItemCode: Integer;
  ItemName: string;
  PriceUSD, CostUSD: Double;
  Quantity: Integer;
  Notes: string;
begin

  if EditSearchItemName.Text='' then
  begin
    ShowMessage('الرجاء اختيار صنف من قائمة المخزون أولاً لتعديله.');
    Exit;
  end;


  // 1. التحقق من وجود سجل نشط في استعلام المخزون
  if QryInventorySearch.Active and (not QryInventorySearch.IsEmpty) then
  begin
  // 2. قراءة بيانات الصنف المحدد
  // تأكد من أن جملة SELECT لـ QryInventorySearch تحتوي على ItemCode, ItemName, PriceUSD, Quantity, CostUSD, Notes
    try
      ItemCode := QryInventorySearch.FieldByName('ItemCode').AsInteger;
      ItemName := QryInventorySearch.FieldByName('ItemName').AsString;
      PriceUSD := QryInventorySearch.FieldByName('PriceUSD').AsFloat;
      Quantity := QryInventorySearch.FieldByName('Quantity').AsInteger;

      // التعامل الآمن مع الحقول التي قد تكون فارغة
      CostUSD := QryInventorySearch.FieldByName('CostUSD').AsFloat;
      Notes := QryInventorySearch.FieldByName('Notes').AsString;

    except
      ShowMessage('خطأ في قراءة بيانات الصنف. تأكد من وجود جميع الأعمدة في استعلام البحث.');
      Exit;
    end;


    // 3. إنشاء النموذج الجديد وتمرير الاتصال
    if not Assigned(EditItemForm) then
      EditItemForm := TEditItemForm.Create(Application);

      // 🚨 تمرير الاتصال الرئيسي إلى النموذج الفرعي
    EditItemForm.ADOConnection := ADOConnection1;

    // 4. تحميل البيانات وفتح النموذج
    EditItemForm.LoadItemDetails(ItemCode, ItemName, PriceUSD, Quantity, CostUSD, Notes);

    EditItemForm.ShowModal;
    EditSearchItemName.Clear;
    EditItemPriceSYP.Clear;
    Edit2.Clear;
    EditItemQuantity.Clear;
    EditItemQuantityTaken.Clear;
    end
    else
    begin
      ShowMessage('الرجاء اختيار صنف من قائمة المخزون أولاً لتعديله.');
    end;
end;

procedure TForm1.ButtonEditRateClick(Sender: TObject);
var
  OldRate, NewRate: Double;
  RateStr: string;
  TodayDate: string;
begin
  // 1. جلب تاريخ اليوم بصيغة مناسبة (يبقى كما هو)
  TodayDate := FormatDateTime('dd/mm/yyyy', Date);

  // 2. قراءة القيمة الحالية من ورقة Excel (يبقى كما هو)
  QryExchangeRate.Close;
  QryExchangeRate.SQL.Clear;
  QryExchangeRate.SQL.Add('SELECT RateSYP FROM [ExchangeRate$] WHERE [nameDate] = #' + TodayDate + '#');
  QryExchangeRate.Open;

  if QryExchangeRate.IsEmpty then
  begin
    ShowMessage('لا توجد قيمة سعر صرف مسجلة لهذا اليوم.');
    Exit;
  end;

  OldRate := QryExchangeRate.FieldByName('RateSYP').AsFloat;
  QryExchangeRate.Close; // إغلاق الاستعلام بعد القراءة

  // 3. رسالة تأكيد للمستثمر (يبقى كما هو)
  if MessageDlg('القيمة الحالية لسعر الصرف هي: ' + FormatFloat('0.00', OldRate) +
                 ' ل.س.' + sLineBreak +
                 'هل أنت متأكد أنك تريد تعديلها؟',
                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // 4. طلب القيمة الجديدة من المستخدم (يبقى كما هو)
    if InputQuery('تعديل سعر الصرف', 'أدخل القيمة الجديدة لسعر الصرف:', RateStr) then
    begin
      if TryStrToFloat(RateStr, NewRate) and (NewRate > 0) then
      begin

        // *****************************************************
        // 5. تطبيق المعاملات والتحديث القسري
        // *****************************************************
        try
          // أ. بدء المعاملة
          ADOConnection1.BeginTrans;

          // ب. تحديث القيمة في ملف Excel
          QryExchangeRate.SQL.Clear;
          QryExchangeRate.SQL.Add('UPDATE [ExchangeRate$] SET RateSYP = :R WHERE [nameDate] = :D');
          QryExchangeRate.Parameters.ParamByName('R').Value := NewRate;
          QryExchangeRate.Parameters.ParamByName('D').Value := FormatDateTime('dd/mm/yyyy', Date);
          QryExchangeRate.ExecSQL;

          // ج. الالتزام القسري بالحفظ (Commit)
          ADOConnection1.CommitTrans;

          // د. تحديث الواجهة ورسالة النجاح
          ShowMessage('تم تعديل سعر الصرف بنجاح إلى: ' + FormatFloat('0.00', NewRate) + ' ل.س.');
          CurrentExchangeRate := NewRate;
          EditExchangeRate.Text := FormatFloat('0.00', CurrentExchangeRate);
          Panel1.Caption := 'قيمة سعر الصرف اليوم: ' + EditExchangeRate.Text;
          Panel1.Visible:=true;
          Timer1.Enabled:= true;

        except
          on E: Exception do
          begin
            // هـ. التراجع عن العملية في حال الفشل
            ADOConnection1.RollbackTrans;
            ShowMessage('خطأ في تعديل سعر الصرف: ' + E.Message + '. تم التراجع عن العملية.');
          end;
        end;
        // *****************************************************

      end
      else
        ShowMessage('القيمة المدخلة غير صالحة. يجب أن تكون رقمية موجبة.');
    end;
  end;
end;


procedure TForm1.ButtonShowReportClick(Sender: TObject);
begin
  // 1. إنشاء النموذج إذا لم يكن موجوداً
  // هذا يضمن أن يتم إنشاء النموذج مرة واحدة فقط
  if not Assigned(ProfitReportForm) then
    ProfitReportForm := TProfitReportForm.Create(Application);

  // 2. عرض النموذج كنافذة منبثقة (Modal) أو كشكل عادي (Show)
  // يفضل استخدام ShowModal للتقارير لتركيز المستخدم
  ProfitReportForm.ShowModal;

  // 3. (اختياري) إذا استخدمت ShowModal: يمكنك إزالته من الذاكرة هنا
  // بما أننا وضعنا Action := caFree; في حدث OnClose للنموذج، فهذه الخطوة اختيارية
  // لكنها تبقى للتأكيد على تصفير المتغير
  ProfitReportForm := nil;
end;

procedure TForm1.EditSearchItemNameChange(Sender: TObject);
var
  SearchPrefix: string;
begin


  MemoItemNotes.Visible:=false;
  Label8.Visible:= false;
  SearchPrefix := EditSearchItemName.Text;

  // 1. مسح قائمة الاقتراحات وإخفائها
  ListBoxSuggestions.Clear;
  ListBoxSuggestions.Visible := False;
  Label7.Visible := False;
  EditItemPriceSYP.Text := '';
  Edit2.Text :='';
  EditItemQuantity.Text := '';

  // 2. إيقاف الفلتر إذا كان موجوداً
  QryInventorySearch.Filtered := False;

  if Length(SearchPrefix) < 1 then // لا تظهر الاقتراحات إلا بعد كتابة حرف واحد على الأقل
    Exit;

  // 3. تأكد أن الاستعلام مفتوح ويحتوي على كل الأعمدة
  if not QryInventorySearch.Active then
  begin
    // يجب فتح الاستعلام بجميع الأعمدة المطلوبة مرة واحدة
    QryInventorySearch.SQL.Clear;
    // يجب أن تشمل هذه الجملة كل الأعمدة التي سنحتاجها لاحقاً
    QryInventorySearch.SQL.Add('SELECT ItemCode, ItemName, Quantity, PriceUSD, CostUSD,Notes FROM [Inventory$]');
    QryInventorySearch.Open;
  end;

  // 4. تطبيق الفلتر لعرض الاقتراحات
  // نستخدم Filter بدلاً من إعادة فتح الاستعلام لتجنب مشكلة البارامتر
  QryInventorySearch.Filter := 'ItemName LIKE ' + QuotedStr(SearchPrefix + '*');
  QryInventorySearch.Filtered := True;

  // 5. ملء قائمة الاقتراحات بالنتائج المفلترة
  if not QryInventorySearch.IsEmpty then
  begin
    ListBoxSuggestions.Visible := True;
    Label7.Visible := True;

    QryInventorySearch.First;
    while not QryInventorySearch.Eof do
    begin
      // إضافة اسم البضاعة إلى قائمة الاقتراحات
      ListBoxSuggestions.Items.Add(QryInventorySearch.FieldByName('ItemName').AsString);
      QryInventorySearch.Next;
    end;

    // ضبط حجم القائمة ليتناسب مع عدد العناصر
    //if ListBoxSuggestions.Items.Count > 0 then
     // ListBoxSuggestions.Height := (ListBoxSuggestions.Items.Count * 25) + 5;
  end;
end;



procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// 🔑 هذه الخطوة تضمن تفريغ (Flush) جميع عمليات INSERT/UPDATE/DELETE
  // التي لم يتم حفظها بشكل دائم في ملف Excel قبل إنهاء البرنامج
  if ADOConnection1.Connected then
  begin
    ADOConnection1.Connected := False;
    // لا نحتاج لإعادة فتحه، لأن البرنامج سيغلق
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  UserName, Password: String;
  TodayDate: string;
  RateStr: string;
  RateValue: Double;
  Qry: TADOQuery;
begin
  // 1. التحقق الأمني
  if not FileExists('C:\Program Files\widos\tree.txt') then
  begin
    ShowMessage('يرجى الاتصال بالمصدر');
    Application.Terminate;
    Exit;
  end;

  // 2. إخفاء العناصر
  MemoItemNotes.Visible := False;
  Label8.Visible := False;
  Label6.Visible := False;
  ListBoxSuggestions.Visible := False;
  Label7.Visible := False;

  // 3. تسجيل الدخول
//  if InputQuery('تسجيل الدخول', 'اسم المستخدم:', UserName) and
//     InputQuery('تسجيل الدخول', 'كلمة المرور:', Password) then
//  begin
//    if (UserName = '') and (Password = '') then
 //   begin
      try
        ADOConnection1.Connected := True;

        // 4. منطق سعر الصرف
        QryExchangeRate.Connection := ADOConnection1;
        TodayDate := FormatDateTime('dd/mm/yyyy', Date);

        try
          QryExchangeRate.SQL.Clear;
          QryExchangeRate.SQL.Add('SELECT RateSYP FROM [ExchangeRate$] WHERE [nameDate] = #' + TodayDate + '#');
          QryExchangeRate.Open;

          if QryExchangeRate.IsEmpty then
          begin
            if InputQuery('سعر الصرف اليوم', 'أدخل سعر الصرف:', RateStr) then
            begin
              if TryStrToFloat(RateStr, RateValue) and (RateValue > 0) then
              begin
                QryExchangeRate.Close;
                QryExchangeRate.SQL.Clear;
                QryExchangeRate.SQL.Add('INSERT INTO [ExchangeRate$] ([nameDate], RateSYP) VALUES (:D, :R)');
                QryExchangeRate.Parameters.ParamByName('D').Value := FormatDateTime('dd/mm/yyyy', Date);
                QryExchangeRate.Parameters.ParamByName('R').Value := RateValue;
                QryExchangeRate.ExecSQL;

                ShowMessage(sLineBreak + sLineBreak + sLineBreak + sLineBreak +
                sLineBreak + sLineBreak + 'تم حفظ سعر الصرف لهذا اليوم بنجاح.'+ FloatToStr(RateValue));
              end
              else
              begin
                ShowMessage('قيمة غير صالحة. سيتم إغلاق البرنامج.');
                Application.Terminate;
              end;
            end
            else
            begin
              ShowMessage('لم يتم إدخال سعر الصرف. سيتم إغلاق البرنامج.');
              Application.Terminate;
            end;
          end
          else
          begin
            RateValue := QryExchangeRate.FieldByName('RateSYP').AsFloat;
            ShowMessage(sLineBreak + sLineBreak + sLineBreak + sLineBreak + sLineBreak + sLineBreak +
            sLineBreak +'تم تحميل سعر الصرف لهذا اليوم.'+FloatToStr(RateValue) +
             sLineBreak + sLineBreak + sLineBreak + sLineBreak + sLineBreak + sLineBreak);
          end;

          CurrentExchangeRate := RateValue;
          EditExchangeRate.Text := FormatFloat('0.00', CurrentExchangeRate);
          Panel1.Caption := 'قيمة سعر الصرف اليوم: ' + EditExchangeRate.Text;
          Panel1.Font.Size := 26;
          Panel1.Font.Color := clRed;
          Timer1.Enabled := True;

        except
          on E: Exception do
          begin
            ShowMessage('خطأ في معالجة سعر الصرف: ' + E.Message);
            Application.Terminate;
          end;
        end;

        // 5. آخر فاتورة
        Qry := TADOQuery.Create(nil);
        try
          Qry.Connection := ADOConnection1;
          Qry.SQL.Text := 'SELECT MAX(CDbl(InvoiceID)) AS MaxID FROM [Sales$]';
          Qry.Open;

          if not Qry.IsEmpty and not Qry.FieldByName('MaxID').IsNull then
            LastInvoiceID := Qry.FieldByName('MaxID').AsInteger
          else
            LastInvoiceID := 0;
        except
          on E: Exception do
          begin
            ShowMessage('خطأ في قراءة آخر فاتورة: ' + E.Message);
            LastInvoiceID := 0;
          end;
        end;
        Qry.Free;

        // 6. تهيئة Grid
        SalesGrid.Cells[0, 0] := 'اسم البضاعة';
        SalesGrid.Cells[1, 0] := 'سعر الوحدة (ل.س)';
        SalesGrid.Cells[2, 0] := 'الكمية';
        SalesGrid.Cells[3, 0] := 'الإجمالي الجزئي';

        SalesGrid.ColWidths[0] := 325;
        SalesGrid.ColWidths[1] := 150;
        SalesGrid.ColWidths[2] := 150;
        SalesGrid.ColWidths[3] := 150;

      except
        on E: Exception do
        begin
          ShowMessage('فشل الاتصال بقاعدة البيانات: ' + E.Message);
          Application.Terminate;
        end;
      end;
 {   end
    else
    begin
      ShowMessage('اسم المستخدم أو كلمة المرور غير صحيحة.');
      Application.Terminate;
    end;
  end
  else
    Application.Terminate;}
end;



procedure TForm1.FormShow(Sender: TObject);
begin
//PostMessage(EditSearchItemName.Handle, WM_SETFOCUS, 0, 0);
end;

procedure TForm1.ListBoxSuggestionsClick(Sender: TObject);
var
  SelectedItemName: string;
  ItemPriceUSD: Double; // السعر من قاعدة البيانات
  ItemCostUSD: Double;  // التكلفة من قاعدة البيانات
  UnitPriceSYP: Double; // السعر المحسوب بالليرة السورية
  UnitbuySYP: Double;
  ItemNotes: string; // المتغير الجديد لمحتوى الملاحظات
begin
  if ListBoxSuggestions.ItemIndex >= 0 then
  begin
    SelectedItemName := ListBoxSuggestions.Items[ListBoxSuggestions.ItemIndex];

    // 1. تحديث حقل البحث وإخفاء القائمة
    EditSearchItemName.Text := SelectedItemName;
    ListBoxSuggestions.Visible := False;
    Label7.Visible := False;

    // **مسح حقل الملاحظات أولاً**
    MemoItemNotes.Clear;

    // 2. البحث عن الصنف باستخدام Locate (يجب أن يكون الاستعلام مفتوحاً من EditSearchItemNameChange)
    QryInventorySearch.Filtered := False; // نوقف الفلتر لنتمكن من البحث في جميع البيانات

    // **القراءة والتأكيد على الموقف الصحيح**
    if QryInventorySearch.Locate('ItemName', SelectedItemName, []) then
    begin
      // 3. قراءة البيانات وحساب السعر بالليرة
      ItemPriceUSD  := QryInventorySearch.FieldByName('PriceUSD').AsFloat;
      ItemCostUSD   := QryInventorySearch.FieldByName('CostUSD').AsFloat;
      ItemNotes     := QryInventorySearch.FieldByName('Notes').AsString;
      // حساب السعر بالليرة السورية
      // **تأكد أن CurrentExchangeRate لديه قيمة غير صفرية (يتم قراءتها عند بدء البرنامج)**
      if CurrentExchangeRate > 0 then
      begin
        UnitPriceSYP := ItemPriceUSD * CurrentExchangeRate;
        UnitbuySYP := ItemCostUSD * CurrentExchangeRate;
      end
      else
      begin
        UnitPriceSYP := 0;
        UnitbuySYP :=0;
      end;
      // 4. عرض البيانات في حقول الإدخال
      EditItemPriceSYP.Text := FormatFloat('0.00', UnitPriceSYP); // <-- السعر بالليرة السورية
      EditItemQuantity.Text := IntToStr(QryInventorySearch.FieldByName('Quantity').AsInteger);
      Edit2.Text := FormatFloat('0.00', UnitbuySYP);;
      // **ملاحظة:** لا حاجة لحفظ CostUSD هنا. سيتم حفظها في ButtonAddClick.

      // 5. **الخطوة الحاسمة: قراءة وعرض محتوى عمود Notes**

      // قراءة محتوى عمود Notes
      if ItemNotes <> '' then
      begin
        MemoItemNotes.Text := ItemNotes;
        MemoItemNotes.Visible := True; // يمكنك إظهاره إذا كان مخفياً بشكل افتراضي
          Label8.Visible:= true;
      end
      else
      begin
         MemoItemNotes.Visible := False; // إخفاؤه إذا لم تكن هناك ملاحظات
           Label8.Visible:= false;
      end;


    end
    else
    begin
      // في حالة فشل Locate
      ShowMessage('لم يتم العثور على الصنف المختار في البيانات الحالية.');
    end;
  end;
end;



procedure TForm1.PreparePrintReport(InvoiceID: Integer; CustomerName: string; GrandTotal: Double; SalesGrid: TStringGrid);
var
  i: Integer;
begin
  // ********** 1. ضمان وجود النموذج في الذاكرة **********
  // هذا يحل مشكلة Access Violation (الذاكرة) التي تحدث بعد طباعة الفاتورة الأولى.
  // إذا تم تدمير النموذج (بسبب OnClose + caFree)، نقوم بإنشائه مرة أخرى.
  if not Assigned(PrintPreviewForm) then
  begin
    // تأكد أن TPrintPreviewForm هو اسم النموذج في Unit2
    Application.CreateForm(TPrintPreviewForm, PrintPreviewForm);
  end;

  // ********** 2. تجهيز محتوى الطباعة في MemoReport **********

  // مسح المحتوى القديم للطباعة
  PrintPreviewForm.MemoReport.Lines.Clear;

  // تنسيق رأس الفاتورة
  PrintPreviewForm.MemoReport.Lines.Add('          فاتورة متجر حيالين      ');
  PrintPreviewForm.MemoReport.Lines.Add('**************************************');
  PrintPreviewForm.MemoReport.Lines.Add('رقم الفاتورة: ' + IntToStr(InvoiceID));
  PrintPreviewForm.MemoReport.Lines.Add('التاريخ: ' + FormatDateTime('yyyy-mm-dd', Date));
  PrintPreviewForm.MemoReport.Lines.Add('اسم الزبون: ' + CustomerName);
  PrintPreviewForm.MemoReport.Lines.Add('--------------------------------------');

  // تنسيق جدول البنود (البضاعة، الكمية، الإجمالي)
  PrintPreviewForm.MemoReport.Lines.Add(Format('%10s %6s %-20s', ['البضاعة', 'الكمية', 'الإجمالي (ل.س)']));
  PrintPreviewForm.MemoReport.Lines.Add('--------------------------------------');

  // إضافة البنود من SalesGrid
  for i := 1 to SalesGrid.RowCount - 1 do
  begin
    // Column 0: ItemName, Column 2: Quantity, Column 3: LineTotalSYP
    PrintPreviewForm.MemoReport.Lines.Add(
      Format('%-20s %6s %10s',
        [SalesGrid.Cells[0, i], SalesGrid.Cells[2, i], SalesGrid.Cells[3, i]]
      )
    );
  end;

  // تنسيق الذيل والإجمالي
  PrintPreviewForm.MemoReport.Lines.Add('--------------------------------------');
  PrintPreviewForm.MemoReport.Lines.Add(Format('%-20s %6s %10s', ['الإجمالي الكلي:', '', FormatFloat('0.00', GrandTotal)]));
  PrintPreviewForm.MemoReport.Lines.Add('**************************************');

  // ********** 3. عرض النموذج **********
  // إيقاف البرنامج مؤقتاً حتى يغلق المستخدم نافذة المعاينة
  PrintPreviewForm.ShowModal;

  // بما أن FormClose في PrintPreviewForm تحتوي على Action := caFree;،
  // فإن النموذج يدمر نفسه ذاتياً بعد الإغلاق.
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
Panel1.Visible:=false;
Label6.Visible:=true;
Label6.Caption:='سعر الصرف ليوم ' + DateToStr(date);
Timer1.Enabled:=false;
EditSearchItemName.SetFocus;
end;


end.
