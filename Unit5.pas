unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.Win.ADODB, Math, Vcl.ExtCtrls, System.UITypes,
  Data.DB;

type
  TEditItemForm = class(TForm)
    MemoNotes: TMemo;
    QryUpdateItem: TADOQuery;
    Label6: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    EditCostUSD: TEdit;
    EditQuantity: TEdit;
    EditPriceUSD: TEdit;
    EditItemName: TEdit;
    EditItemCode: TEdit;
    ButtonSave: TButton;
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);


  private
    { Private declarations }
  public
    ADOConnection: TADOConnection;
    procedure LoadItemDetails(ItemCode: Integer; ItemName: string; PriceUSD: Double; Quantity: Integer; CostUSD: Double; Notes: string);
  end;

var
  EditItemForm: TEditItemForm;

implementation

{$R *.dfm}
 uses Unit1;







procedure TEditItemForm.ButtonDeleteClick(Sender: TObject);
var
  ItemCodeToDelete: Integer;
begin
  // 1. «· Õﬁﬁ „‰ «·« ’«·
  if not Assigned(ADOConnection) or not ADOConnection.Connected then
  begin
    ShowMessage('Œÿ√: «·« ’«· »ﬁ«⁄œ… «·»Ì«‰«  €Ì— ‰‘ÿ. ·« Ì„ﬂ‰ «·Õ–›.');
    Exit;
  end;

  // 2. Ã·» —„“ «·’‰›
  if not TryStrToInt(EditItemCode.Text, ItemCodeToDelete) then
  begin
    ShowMessage('—„“ «·’‰› €Ì— ’«·Õ ··Õ–›. ·« Ì„ﬂ‰ «·„ «»⁄….');
    Exit;
  end;

  // 3. —”«·… «· √ﬂÌœ «·‰Â«∆Ì… (≈Ã—«¡ Õ”«”)
  if MessageDlg('Â· √‰  „ √ﬂœ  „«„« „‰ Õ–› «·’‰›: ' + EditItemName.Text + 'ø' + sLineBreak +
                '„·«ÕŸ…: ·« Ì„ﬂ‰ «· —«Ã⁄ ⁄‰ Â–« «·≈Ã—«¡.',
                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // *****************************************************
    // 4.  ÿ»Ìﬁ ¬·Ì«  «·„⁄«„·«  Ê«· ‰›Ì– «·ﬁ”—Ì ··Õ–›
    // *****************************************************
    try
      // √. »œ¡ «·„⁄«„·…
      ADOConnection.BeginTrans;

      // ». ≈⁄œ«œ «” ⁄·«„ «·Õ–›
      QryUpdateItem.Connection := ADOConnection;
      QryUpdateItem.SQL.Clear;

      // ‰” Œœ„ CDbl() ·÷„«‰ √‰ „Ê›— Excel Ì ⁄«„· „⁄ «·Õﬁ· ﬂ—ﬁ„ ··„ﬁ«—‰…
      QryUpdateItem.SQL.Add('DELETE FROM [Inventory$] WHERE CDbl(ItemCode) = :Code');

      QryUpdateItem.Parameters.ParamByName('Code').Value := ItemCodeToDelete;

      // Ã.  ‰›Ì– «·Õ–›
      QryUpdateItem.ExecSQL;

      // œ. «·«· “«„ «·ﬁ”—Ì »«·Õ›Ÿ (Commit)
      ADOConnection.CommitTrans;

      ShowMessage(' „ Õ–› «·’‰› »‰Ã«Õ!');

      // 5.  ÕœÌÀ «·Ê«ÃÂ… «·—∆Ì”Ì… (Form1)
      if Assigned(Form1) and Assigned(Form1.QryInventorySearch) then
      begin
        Form1.QryInventorySearch.Close;
        Form1.QryInventorySearch.Open;
      end;

      // 6. ≈€·«ﬁ «·‰„Ê–Ã »⁄œ «·‰Ã«Õ
      Self.Close;

    except
      on E: Exception do
      begin
        // Â‹. «· —«Ã⁄ ⁄‰ «·⁄„·Ì… ›Ì Õ«· «·›‘·
        ADOConnection.RollbackTrans;
        ShowMessage('Œÿ√ √À‰«¡ Õ–› «·’‰›: ' + E.Message + '.  „ «· —«Ã⁄ ⁄‰ «·⁄„·Ì….');
      end;
    end;
  end;
end;

procedure TEditItemForm.ButtonSaveClick(Sender: TObject);
var
  ItemCode: Integer;
  ItemName: string;
  PriceUSD, CostUSD: Double;
  Quantity: Integer;
  Notes: string;
begin
  // 1. «· Õﬁﬁ „‰ «·„œŒ·«  Ê—”«·… «· √ﬂÌœ (Ì»ﬁÏ ﬂ„« ÂÊ)
  if (EditItemName.Text = '') or (EditPriceUSD.Text = '') or (EditQuantity.Text = '') or (EditCostUSD.Text='') then
  begin
    ShowMessage('«·—Ã«¡  ⁄»∆… Ã„Ì⁄ «·ÕﬁÊ· «·≈·“«„Ì….');
    Exit;
  end;

  if MessageDlg(' Â· «‰  „ √ﬂœ „‰ Â–« «· ⁄œÌ· ⁄·Ï: '+ EditItemName.Text + 'ø', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  // 2. ﬁ—«¡… Ê ÕÊÌ· «·»Ì«‰« 
  ItemCode := StrToIntDef(EditItemCode.Text, 0);
  ItemName := Trim(EditItemName.Text);
  PriceUSD := StrToFloatDef(EditPriceUSD.Text, 0.0);
  Quantity := StrToIntDef(EditQuantity.Text, 0);
  CostUSD := StrToFloatDef(EditCostUSD.Text, 0.0);
  Notes := Trim(MemoNotes.Text);

  // 3. «· Õﬁﬁ „‰ «·« ’«·
  if not Assigned(ADOConnection) or not ADOConnection.Connected then
  begin
    ShowMessage('Œÿ√: «·« ’«· »ﬁ«⁄œ… «·»Ì«‰«  €Ì— ‰‘ÿ.');
    Exit;
  end;

  // *****************************************************
  // 4.  ÿ»Ìﬁ ¬·Ì«  «·„⁄«„·«  (Transactions)
  // *****************************************************
  try
    // √. »œ¡ «·„⁄«„·… (Start Transaction)
    ADOConnection.BeginTrans;

    // ». »‰«¡ «” ⁄·«„ UPDATE
    QryUpdateItem.Connection := ADOConnection;
    QryUpdateItem.SQL.Clear;

    QryUpdateItem.SQL.Add('UPDATE [Inventory$] SET');
    // ‰” Œœ„ «·»«—«„ —«  ·ﬂ· „‰ ItemName Ê Notes · Ã‰» „‘«ﬂ· ⁄·«„«  «· ‰’Ì’
    QryUpdateItem.SQL.Add('ItemName = :Name,');
    QryUpdateItem.SQL.Add('PriceUSD = :Price,');
    QryUpdateItem.SQL.Add('Quantity = :Qty,');
    QryUpdateItem.SQL.Add('CostUSD = :Cost,');
    QryUpdateItem.SQL.Add('Notes = :Notes');
    // ‰” Œœ„ CDbl(ItemCode) ·÷„«‰ «· ⁄«„· „⁄Â ﬂ—ﬁ„ ›Ì Excel
    QryUpdateItem.SQL.Add('WHERE CDbl(ItemCode) = :Code');

    // Ã.  ⁄ÌÌ‰ «·»«—«„ —« 
    QryUpdateItem.Parameters.ParamByName('Code').Value := ItemCode;
    QryUpdateItem.Parameters.ParamByName('Name').Value := ItemName; //  „ «· ⁄œÌ·
    QryUpdateItem.Parameters.ParamByName('Price').Value := PriceUSD;
    QryUpdateItem.Parameters.ParamByName('Qty').Value := Quantity;
    QryUpdateItem.Parameters.ParamByName('Cost').Value := CostUSD;
    QryUpdateItem.Parameters.ParamByName('Notes').Value := Notes; //  „ «· ⁄œÌ·

    // œ.  ‰›Ì– «·«” ⁄·«„
    QryUpdateItem.ExecSQL;

    // Â‹. «·«· “«„ «·ﬁ”—Ì »«·Õ›Ÿ (Commit)
    ADOConnection.CommitTrans;

    ShowMessage(' „  ⁄œÌ· «·’‰› »‰Ã«Õ!');

    // Ê.  ÕœÌÀ «” ⁄·«„ «·»ÕÀ ›Ì «·Ê«ÃÂ… «·—∆Ì”Ì… (Form1)
    if Assigned(Form1) and Assigned(Form1.QryInventorySearch) then
    begin
      Form1.QryInventorySearch.Close;
      Form1.QryInventorySearch.Open;
    end;

    Self.Close; // ≈€·«ﬁ ‰„Ê–Ã «· ⁄œÌ· »⁄œ «·‰Ã«Õ

  except
    on E: Exception do
    begin
      // “. «· —«Ã⁄ ⁄‰ «·⁄„·Ì… ›Ì Õ«· «·›‘·
      ADOConnection.RollbackTrans;
      ShowMessage('Œÿ√ ›Ì  ⁄œÌ· «·’‰›: ' + E.Message + '.  „ «· —«Ã⁄ ⁄‰ «·⁄„·Ì….');
    end;
  end;
end;

procedure TEditItemForm.LoadItemDetails(ItemCode: Integer; ItemName: string; PriceUSD: Double; Quantity: Integer; CostUSD: Double; Notes: string);
begin
  Self.Caption := ' ⁄œÌ· „⁄·Ê„«  «·’‰›: ' + ItemName;
  EditItemCode.Text := IntToStr(ItemCode);
  EditItemCode.ReadOnly := True; // „‰⁄  ⁄œÌ· —„“ «·’‰›

  EditItemName.Text := ItemName;
  EditPriceUSD.Text := FormatFloat('0.##', PriceUSD);
  EditQuantity.Text := IntToStr(Quantity);
  EditCostUSD.Text := FormatFloat('0.##', CostUSD);
  MemoNotes.Text := Notes;
end;
end.
