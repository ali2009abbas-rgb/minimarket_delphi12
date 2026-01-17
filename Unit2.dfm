object PrintPreviewForm: TPrintPreviewForm
  Left = 0
  Top = 0
  Caption = 'PrintPreviewForm'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 15
  object ButtonPrint: TButton
    Left = 248
    Top = 377
    Width = 75
    Height = 25
    Caption = #1591#1576#1575#1593#1577
    TabOrder = 0
    OnClick = ButtonPrintClick
  end
  object ButtonClose: TButton
    Left = 248
    Top = 408
    Width = 75
    Height = 25
    Caption = #1575#1594#1604#1575#1602' '#1575#1604#1591#1576#1575#1593#1577
    TabOrder = 1
    OnClick = ButtonCloseClick
  end
  object MemoReport: TRichEdit
    Left = 72
    Top = 8
    Width = 425
    Height = 363
    Alignment = taRightJustify
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'MemoReport')
    ParentFont = False
    TabOrder = 2
  end
  object PrintDialog1: TPrintDialog
    Collate = True
    Left = 464
    Top = 360
  end
end
