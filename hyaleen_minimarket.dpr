program hyaleen_minimarket;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {PrintPreviewForm},
  Unit3 in 'Unit3.pas' {ProfitReportForm},
  Unit4 in 'Unit4.pas' {AddItemForm},
  Unit5 in 'Unit5.pas' {EditItemForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPrintPreviewForm, PrintPreviewForm);
  Application.CreateForm(TProfitReportForm, ProfitReportForm);
  Application.CreateForm(TAddItemForm, AddItemForm);
  Application.CreateForm(TEditItemForm, EditItemForm);
  Application.Run;
end.
