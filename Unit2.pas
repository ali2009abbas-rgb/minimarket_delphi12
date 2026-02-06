unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Printers, Vcl.ComCtrls;

type
  TPrintPreviewForm = class(TForm)
    ButtonPrint: TButton;
    ButtonClose: TButton;
    PrintDialog1: TPrintDialog;
    MemoReport: TRichEdit;
    procedure ButtonPrintClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject); // ≈÷«›… ÕœÀ ⁄‰œ ≈‰‘«¡ «·‰„Ê–Ã
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintPreviewForm: TPrintPreviewForm;

implementation

{$R *.dfm}

procedure TPrintPreviewForm.FormCreate(Sender: TObject);
begin
MemoReport.WordWrap := False;
end;

procedure TPrintPreviewForm.ButtonPrintClick(Sender: TObject);
var
  Title: string;
begin
  if PrintDialog1.Execute then
  begin
    Title := '›« Ê—… „»Ì⁄«  - „ Ã— ÕÌ«·Ì‰';

    //  √ﬂÌœ «·« Ã«Â „—… √Œ—Ï ﬁ»· «·ÿ»«⁄…
    MemoReport.BiDiMode := bdRightToLeft;

    MemoReport.Print(Title);
  end;
end;

procedure TPrintPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  PrintPreviewForm := nil;
end;

procedure TPrintPreviewForm.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

end.
