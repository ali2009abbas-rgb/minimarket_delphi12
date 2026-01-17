unit Unit3;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, ComObj;

type
  TProfitReportForm = class(TForm)
    DTPStart: TDateTimePicker;
    DTPEnd: TDateTimePicker;
    ButtonGenerateReport: TButton;
    DBGReport: TDBGrid;
    EditTotalProfit: TEdit;
    QryProfit: TADOQuery;
    DataSource1: TDataSource;
    QryProfitInvoiceID: TWideStringField;
    QryProfitSaleDate: TWideStringField;
    QryProfitCustomerName: TWideStringField;
    QryProfitItemName: TWideStringField;
    QryProfitQuantity: TWideStringField;
    QryProfitUnitPriceSYP: TWideStringField;
    QryProfitLineTotalSYP: TWideStringField;
    QryProfitUnitCostUSD: TWideStringField;
    QryProfitLineProfitUSD: TWideStringField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ButtonExport: TButton;
    SaveDialog1: TSaveDialog;
    QryProfitPriceUSD: TWideStringField;
    Edit1: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure ButtonGenerateReportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ButtonExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProfitReportForm: TProfitReportForm;

implementation
uses Unit1;
{$R *.dfm}

procedure TProfitReportForm.ButtonExportClick(Sender: TObject);
const
  // ÌÃ» √‰ ÌﬂÊ‰  — Ì» «·√”„«¡ Â‰« „ÿ«»ﬁ« · — Ì» «·√⁄„œ… ›Ì QryProfit
  ArabicHeaders: array[0..9] of string = (
    ' «—ÌŒ «·»Ì⁄',
     '«”„ «·“ÌÊ‰',
    '«”„ «·’‰›',
    '«·ﬂ„Ì… «·„»«⁄…',
    '”⁄— «·ﬁÿ⁄… »«··Ì—… «·”Ê—Ì…',
    '«·”⁄— «·ﬂ·Ì »«··Ì—… «·”Ê—Ì…',
    '”⁄— «·‘—«¡ »«·œÊ·«—',
    'ﬁÌ„… «·—»Õ »«·œÊ·«—',
    '—ﬁ„ «·›« Ê—…',
    '”⁄— «·»Ì⁄ »«·œÊ·«—'
  );
var
  ExcelApp: OleVariant;
  Workbook: OleVariant;
  Worksheet: OleVariant;
  i, j: Integer;
begin
  // 1. «· Õﬁﬁ „‰ ÊÃÊœ »Ì«‰« 
  if not QryProfit.Active then
  begin
    ShowMessage('«·—Ã«¡  Ê·Ìœ «· ﬁ—Ì— √Ê·« (»«·÷€ÿ ⁄·Ï " Ê·Ìœ «· ﬁ—Ì—").');
    Exit;
  end;

  // 2. ≈⁄œ«œ «”„ «·„·› «·«› —«÷Ì
  SaveDialog1.FileName := ' ﬁ—Ì— «·—»Õ_' + FormatDateTime('yyyymmdd', Date) + '.xlsx';

  if SaveDialog1.Execute then
  begin
    ExcelApp := Null; //  ÂÌ∆… «·„ €Ì—
    try
      // 3.  ‘€Ì· Excel Ê≈÷«›… Ê—ﬁ… ⁄„· ÃœÌœ…
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False; // ≈Œ›«¡ Excel √À‰«¡ «·⁄„·
      Workbook := ExcelApp.Workbooks.Add;
      Worksheet := Workbook.Worksheets[1];

      // 4. ﬂ «»… —ƒÊ” «·√⁄„œ… («·’› «·√Ê·)
      for i := 0 to QryProfit.FieldCount - 1 do
      begin
        // «·’› 1° «·⁄„Êœ i+1
       if i <= High(ArabicHeaders) then
      Worksheet.Cells[1, i + 1] := ArabicHeaders[i] // <-- «” Œœ«„ «·«”„ «·⁄—»Ì
    else
      Worksheet.Cells[1, i + 1] := QryProfit.Fields[i].FieldName; // «·⁄Êœ… ··«”„ «·≈‰Ã·Ì“Ì ≈–« ﬂ«‰ «·⁄„Êœ ÃœÌœ«
      end;

      // 5.  ‰”Ìﬁ —ƒÊ” «·√⁄„œ… (Ã⁄·Â« »Œÿ ⁄—Ì÷)
      Worksheet.Range['A1', Worksheet.Cells[1, QryProfit.FieldCount]].Font.Bold := True;

      // 6. ﬂ «»… »Ì«‰«  «·”Ã·« 
      QryProfit.First;
      j := 2; // »œ¡ ﬂ «»… «·»Ì«‰«  „‰ «·’› «·À«‰Ì
      while not QryProfit.Eof do
      begin
        for i := 0 to QryProfit.FieldCount - 1 do
        begin
            // ﬂ «»… «·ﬁÌ„… „»«‘—… ≈·Ï «·Œ·Ì…
          if QryProfit.Fields[i].IsNull then
            // ≈–« ﬂ«‰  «·ﬁÌ„… ›«—€…° ‰÷⁄ ”·”·… ‰’Ì… ›«—€…
            Worksheet.Cells[j, i + 1] := ''
          else
            // Ê≈·«° ‰” Œœ„ «·ﬁÌ„… «·√’·Ì…
            Worksheet.Cells[j, i + 1] := QryProfit.Fields[i].AsString;
        end;
        QryProfit.Next;
        Inc(j);
      end;

      // 7.  ‰”Ìﬁ ⁄—÷ «·√⁄„œ…  ·ﬁ«∆Ì«
      Worksheet.Columns.AutoFit;

      // 8. Õ›Ÿ «·„·› »«·’Ì€… XLSX
      // «·ﬁÌ„… 51 ÂÌ «·ﬁÌ„… «·À«» … ·‹ xlOpenXMLWorkbook (xlsx)
      Workbook.SaveAs(SaveDialog1.FileName, 51);

      // 9. ≈€·«ﬁ «·„’‰›
      Workbook.Close(False);

      ShowMessage(' „  ’œÌ—  ﬁ—Ì— «·√—»«Õ »‰Ã«Õ ≈·Ï „·› XLSX.');

    except
      on E: Exception do
      begin
        ShowMessage('ÕœÀ Œÿ√ √À‰«¡ «· ’œÌ— ·‹ Excel: ' + E.Message);
      end;
    end;

    // 10. ≈€·«ﬁ  ÿ»Ìﬁ Excel ‰›”Â (›Ì ﬁ”„ finally ·÷„«‰ «· ‰›Ì–)
    if not VarIsNull(ExcelApp) then
    begin
        ExcelApp.Quit;
    end;
  end;
end;

procedure TProfitReportForm.ButtonGenerateReportClick(Sender: TObject);
var
  StartDate: TDateTime;
  EndDate: TDateTime;
  TotalProfit: Double;
  Totalsy : Double;
  QryTotal: TADOQuery; // «” ⁄·«„ „ƒﬁ  ·Õ”«» «·≈Ã„«·Ì
begin
  // 1.  ÕœÌœ ‰ÿ«ﬁ «· «—ÌŒ
  StartDate := DTPStart.Date;
  // ‰” Œœ„ AddDays(1) - 1/86400 (√Ê «· ÊﬁÌ  ›Ì œ·›Ì) ·÷„«‰ ‘„Ê· ‰Â«Ì… ÌÊ„ «·«‰ Â«¡ »«·ﬂ«„·
  // ··ÕŸ… «·√ŒÌ—… „‰ «·ÌÊ„ «·„Õœœ
  EndDate := DTPEnd.Date + (1 - 1/86400);

  // 2. «· Õﬁﬁ „‰ ’Õ… «· «—ÌŒ
  if StartDate > EndDate then
  begin
    ShowMessage(' «—ÌŒ «·»œ«Ì… ÌÃ» √‰ ÌﬂÊ‰ ﬁ»· √Ê Ì”«ÊÌ  «—ÌŒ «·‰Â«Ì….');
    Exit;
  end;

  // ----------------------------------------------------
  // «·Ã“¡ √: Õ”«» «·≈Ã„«·Ì «·ﬂ·Ì ··—»Õ (SUM)
  // ----------------------------------------------------

  // ‰” Œœ„ try..finally ·÷„«‰  Õ—Ì— «·–«ﬂ—… Õ Ï ·Ê ÕœÀ Œÿ√
  QryTotal := TADOQuery.Create(nil);
  QryTotal.Connection := Form1.ADOConnection1; //  √ﬂœ √‰ ADOConnection1 „—∆Ì Â‰« (⁄»— uses Unit1)

  try
    QryTotal.Close;
    QryTotal.SQL.Clear;

    // **1.  ﬂÊÌ‰ «·«” ⁄·«„ »«·ﬂ«„· √Ê·« („⁄ «·»«—«„ —«  :Start Ê :End)**
    QryTotal.SQL.Add('SELECT SUM(CDbl(LineProfitUSD)) AS TotalProfit, SUM(CDbl(LineTotalSYP)) AS Totalsy FROM [Sales$]');
    QryTotal.SQL.Add('WHERE SaleDate >= CDate(:Start) AND SaleDate <= CDate(:End)');

    // **2.  ⁄ÌÌ‰ ﬁÌ„… «·»«—«„ —«  (·Õ· „‘ﬂ·… Parameter not found)**
    QryTotal.Parameters.ParamByName('Start').Value := FormatDateTime('yyyy-mm-dd', StartDate);
    QryTotal.Parameters.ParamByName('End').Value := FormatDateTime('yyyy-mm-dd', EndDate);

    // **3. › Õ «·«” ⁄·«„ (ÌÃ» √‰ Ì√ Ì »⁄œ  ⁄ÌÌ‰ «·»«—«„ —« )**
    QryTotal.Open;

    // ﬁ—«¡… «·‰ ÌÃ…
    if not QryTotal.IsEmpty and not QryTotal.FieldByName('TotalProfit').IsNull then
    begin
      TotalProfit := QryTotal.FieldByName('TotalProfit').AsFloat;
      Totalsy := QryTotal.FieldByName('Totalsy').AsFloat;
    end
    else
    begin
      TotalProfit := 0;
      Totalsy:=0;
    end;

    // ⁄—÷ «·≈Ã„«·Ì ›Ì Õﬁ· EditTotalProfit
    EditTotalProfit.Text :=FormatFloat('0.00', TotalProfit);
    Edit1.Text := FormatFloat('0.00', Totalsy);

  finally
    QryTotal.Free; //  Õ—Ì— «·–«ﬂ—…
  end;


  // ----------------------------------------------------
  // «·Ã“¡ »: ⁄—÷  ›«’Ì· »‰Êœ «·„»Ì⁄«  ›Ì DBGrid
  // ----------------------------------------------------
QryProfit.Close;
  QryProfit.SQL.Clear;

// **1.  ﬂÊÌ‰ «·«” ⁄·«„ »«·ﬂ«„·**
  QryProfit.SQL.Add('SELECT * FROM [Sales$]');
  QryProfit.SQL.Add('WHERE SaleDate >= CDate(:Start) AND SaleDate <= CDate(:End)');

  // **2.  ⁄ÌÌ‰ ﬁÌ„… «·»«—«„ —« **
  QryProfit.Parameters.ParamByName('Start').Value := FormatDateTime('yyyy-mm-dd', StartDate);
  QryProfit.Parameters.ParamByName('End').Value := FormatDateTime('yyyy-mm-dd', EndDate);

  // **3. › Õ «·«” ⁄·«„**
  QryProfit.Open;

end;

procedure TProfitReportForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
end;

procedure TProfitReportForm.FormCreate(Sender: TObject);
begin
DTPStart.Date:=date;
DTPEnd.Date:=date;
end;

end.
