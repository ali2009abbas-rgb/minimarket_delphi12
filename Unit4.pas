unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls, Math;

type
  TAddItemForm = class(TForm)
    EditItemCode: TEdit;
    EditItemName: TEdit;
    EditPriceUSD: TEdit;
    EditQuantity: TEdit;
    EditCostUSD: TEdit;
    MemoNotes: TMemo;
    ButtonSave: TButton;
    QryMaxID: TADOQuery;
    QryInsertItem: TADOQuery;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure GetNextItemCode;
//    procedure getnameitems;
  public
    { Public declarations }
    ADOConnection: TADOConnection; // خاصية لربط الاتصال
    IsEditing: Boolean; // خاصية جديدة لتحديد وضع التعديل (True/False)
    EditingItemCode: Integer; // لتخزين رمز الصنف الذي يتم تعديله

  end;

var

 AddItemForm: TAddItemForm;


implementation

{$R *.dfm}
uses Unit1; // للوصول إلى Form1


procedure TAddItemForm.ButtonSaveClick(Sender: TObject);
var
  ItemCode: Integer;
  ItemName: string;
  PriceUSD, CostUSD: Double;
  Quantity: Integer;
  Notes: string;
begin

  // 1. التحقق من صحة المدخلات ورسالة التأكيد (يبقى كما هو)
  if (EditItemName.Text = '') or (EditPriceUSD.Text = '') or (EditQuantity.Text = '') or (EditCostUSD.Text='') then
  begin
    ShowMessage('الرجاء تعبئة جميع الحقول الإلزامية (اسم الصنف - سعر المبيع - الكمية - سعر الشراء)');
    Exit;
  end;

  if MessageDlg('هل أنت متأكد من إضافة هذا الصنف '+ EditItemName.Text + '؟', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  // 2. قراءة وتحويل البيانات
  ItemCode := StrToIntDef(EditItemCode.Text, 0);
  ItemName := Trim(EditItemName.Text);
  PriceUSD := StrToFloatDef(EditPriceUSD.Text, 0.0);
  Quantity := StrToIntDef(EditQuantity.Text, 0);
  CostUSD := StrToFloatDef(EditCostUSD.Text, 0.0);
  Notes := Trim(MemoNotes.Text);

  // 3. التحقق من الاتصال
  if not Assigned(ADOConnection) or not ADOConnection.Connected then
  begin
    ShowMessage('خطأ: الاتصال بقاعدة البيانات غير نشط.');
    Exit;
  end;

  // *****************************************************
  // 4. منطق المعاملات والتنفيذ (الجزء المعدل)
  // *****************************************************
  try
    // أ. بدء المعاملة
    ADOConnection.BeginTrans;

    // ب. إعداد الاستعلام
    QryInsertItem.Connection := ADOConnection;
    QryInsertItem.SQL.Clear;

    QryInsertItem.SQL.Add('INSERT INTO [Inventory$] (ItemCode, ItemName, PriceUSD, Quantity, CostUSD, Notes)');
    // يفضل استخدام البارامترات لكل القيم لتجنب مشاكل علامات التنصيص
    QryInsertItem.SQL.Add('VALUES (:Code, :Name, :Price, :Qty, :Cost, :Notes)');

    // ج. تعيين البارامترات (استخدم البارامتر لـ ItemName و Notes أيضاً)
    QryInsertItem.Parameters.ParamByName('Code').Value := ItemCode;
    QryInsertItem.Parameters.ParamByName('Name').Value := ItemName; // تم التعديل
    QryInsertItem.Parameters.ParamByName('Price').Value := PriceUSD;
    QryInsertItem.Parameters.ParamByName('Qty').Value := Quantity;
    QryInsertItem.Parameters.ParamByName('Cost').Value := CostUSD;
    QryInsertItem.Parameters.ParamByName('Notes').Value := Notes; // تم التعديل

    // د. تنفيذ الاستعلام
    QryInsertItem.ExecSQL;

    // هـ. الالتزام القسري بالحفظ (لن يتم حفظ البيانات بشكل دائم في Excel إلا عند هذا السطر)
    ADOConnection.CommitTrans;

    // و. رسائل النجاح وتنظيف الواجهة
    ShowMessage('تمت إضافة الصنف الجديد بنجاح! رمز الصنف: ' + IntToStr(ItemCode));
    EditItemName.Clear;
    EditPriceUSD.Clear;
    EditQuantity.Clear;
    EditCostUSD.Clear;
    MemoNotes.Clear;
    GetNextItemCode; // جلب الرقم التسلسلي الجديد

    // ز. تحديث استعلام البحث في الواجهة الرئيسية (Form1)
    if Assigned(Form1) and Assigned(Form1.QryInventorySearch) then
    begin
      Form1.QryInventorySearch.Close;
      // لا تحتاج لإضافة جملة SQL هنا، يكفي فتحها مرة أخرى
      Form1.QryInventorySearch.Open;
    end;

  except
    on E: Exception do
    begin
      // ح. التراجع عن العملية في حال الفشل
      ADOConnection.RollbackTrans;
      ShowMessage('خطأ في حفظ الصنف: ' + E.Message + '. تم التراجع عن العملية.');
    end;
  end;
end;

procedure TAddItemForm.FormCreate(Sender: TObject);
begin
MemoNotes.Clear;
end;

procedure TAddItemForm.FormShow(Sender: TObject);
begin
  // تأكد من تهيئة الاتصال قبل جلب الرقم
  if Assigned(ADOConnection) and ADOConnection.Connected then
    GetNextItemCode
  else
    ShowMessage('خطأ: الاتصال بقاعدة البيانات غير نشط.');
end;






procedure TAddItemForm.GetNextItemCode;
var
  MaxID: Integer;
  MaxIDStr: string;
begin
  QryMaxID.Connection := ADOConnection;
  QryMaxID.SQL.Clear;
  // جلب أكبر رقم ItemCode
  QryMaxID.SQL.Add('SELECT MAX(CDbl(ItemCode)) AS MaxID FROM [Inventory$]');

  try
    try
      QryMaxID.Open;
      if not QryMaxID.IsEmpty and not QryMaxID.FieldByName('MaxID').IsNull then
        MaxIDStr := QryMaxID.FieldByName('MaxID').AsString // قراءة القيمة كنص
      else
        MaxIDStr := '0'; // البدء من الصفر إذا كان الجدول فارغاً


        MaxID := StrToIntDef(MaxIDStr, 0);
      // تعيين رقم الصنف الجديد
      EditItemCode.Text := IntToStr(MaxID + 1);

    except
      on E: Exception do
      begin
        ShowMessage('خطأ في جلب رقم الصنف: ' + E.Message);
        EditItemCode.Text := '1';
      end;
    end;
  finally
    QryMaxID.Close;
  end;
end;




{procedure TAddItemForm.getnameitems;
var
  MaxID: Integer;
  MaxIDStr: string;
begin
  QryMaxID.Connection := ADOConnection;
  QryMaxID.SQL.Clear;
  // جلب أكبر رقم ItemCode
  QryMaxID.SQL.Add('SELECT MAX(CDbl(ItemCode)) AS MaxID FROM [Inventory$]');

  try
    try
      QryMaxID.Open;
      if not QryMaxID.IsEmpty and not QryMaxID.FieldByName('MaxID').IsNull then
        MaxIDStr := QryMaxID.FieldByName('MaxID').AsString // قراءة القيمة كنص
      else
        MaxIDStr := '0'; // البدء من الصفر إذا كان الجدول فارغاً


        MaxID := StrToIntDef(MaxIDStr, 0);
      // تعيين رقم الصنف الجديد
      EditItemCode.Text := IntToStr(MaxID + 1);

    except
      on E: Exception do
      begin
        ShowMessage('خطأ في جلب رقم الصنف: ' + E.Message);
        EditItemCode.Text := '1';
      end;
    end;
  finally
    QryMaxID.Close;
  end;
end; }


end.
