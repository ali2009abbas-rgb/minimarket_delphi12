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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintPreviewForm: TPrintPreviewForm;

implementation

{$R *.dfm}

procedure TPrintPreviewForm.ButtonPrintClick(Sender: TObject);
var
  Title: string;
begin
  // 1. ÚÑÖ ãÑÈÚ ÍæÇÑ ÇáØÈÇÚÉ ááÓãÇÍ ááãÓÊÎÏã ÈÇáÇÎÊíÇÑ
  if PrintDialog1.Execute then
  begin
    // 2. ÅĞÇ ÖÛØ ÇáãÓÊÎÏã Úáì ãæÇİŞ (OK)¡ ÇÈÏÃ ÇáØÈÇÚÉ
    Title := 'İÇÊæÑÉ ãÈíÚÇÊ'; // ÇáÚäæÇä ÇáĞí ÓíÙåÑ İí ÑÃÓ ÕİÍÉ ÇáØÈÇÚÉ

    // **ØÈÇÚÉ ãÍÊæì MemoReport**
    // MemoReport.Print(Title) ÊÑÓá ÇáãÍÊæì Åáì ÇáØÇÈÚÉ ÇáãÍÏÏÉ İí PrintDialog1
    MemoReport.Print(Title);
  end;
end;



procedure TPrintPreviewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
PrintPreviewForm := nil;
end;

procedure TPrintPreviewForm.ButtonCloseClick(Sender: TObject);
begin
  // ÅÛáÇŞ äÇİĞÉ ÇáãÚÇíäÉ
  Close;
end;

end.
