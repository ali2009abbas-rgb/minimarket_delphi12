object PrintPreviewForm: TPrintPreviewForm
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  Caption = 'PrintPreviewForm'
  ClientHeight = 483
  ClientWidth = 713
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBiDiMode = False
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object ButtonPrint: TButton
    Left = 320
    Top = 417
    Width = 75
    Height = 25
    Caption = #1591#1576#1575#1593#1577
    TabOrder = 0
    OnClick = ButtonPrintClick
  end
  object ButtonClose: TButton
    Left = 320
    Top = 448
    Width = 75
    Height = 25
    Caption = #1575#1594#1604#1575#1602' '#1575#1604#1591#1576#1575#1593#1577
    TabOrder = 1
    OnClick = ButtonCloseClick
  end
  object MemoReport: TRichEdit
    Left = 8
    Top = 8
    Width = 681
    Height = 403
    BiDiMode = bdRightToLeftReadingOnly
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'MemoReport')
    ParentBiDiMode = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object PrintDialog1: TPrintDialog
    Collate = True
    Left = 464
    Top = 360
  end
end
