object AddItemForm: TAddItemForm
  Left = 0
  Top = 0
  Caption = #1608#1575#1580#1607#1577' '#1575#1590#1575#1601#1577' '#1576#1590#1575#1593#1577
  ClientHeight = 512
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 439
    Top = 77
    Width = 128
    Height = 21
    Caption = #1585#1605#1586' '#1575#1604#1576#1590#1575#1593#1577' '#1575#1604#1580#1583#1610#1583#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 439
    Top = 130
    Width = 132
    Height = 21
    Caption = #1575#1587#1605' '#1575#1604#1576#1590#1575#1593#1577' '#1575#1604#1580#1583#1610#1583#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 436
    Top = 238
    Width = 124
    Height = 21
    Caption = #1587#1593#1585'  '#1575#1604#1605#1576#1610#1593' '#1576#1575#1604#1583#1608#1604#1575#1585
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 439
    Top = 287
    Width = 39
    Height = 21
    Caption = #1575#1604#1603#1605#1610#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 439
    Top = 181
    Width = 121
    Height = 21
    Caption = #1587#1593#1585' '#1575#1604#1588#1585#1575#1569' '#1576#1575#1604#1583#1608#1604#1575#1585
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 439
    Top = 376
    Width = 59
    Height = 21
    Caption = #1605#1604#1575#1581#1592#1575#1578
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 158
    Top = 0
    Width = 254
    Height = 32
    Caption = #1605#1593#1604#1608#1605#1575#1578' '#1575#1604#1576#1590#1575#1593#1577' '#1575#1604#1580#1583#1610#1583#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object EditItemCode: TEdit
    Left = 64
    Top = 61
    Width = 369
    Height = 50
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object EditItemName: TEdit
    Left = 64
    Top = 117
    Width = 369
    Height = 47
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object EditPriceUSD: TEdit
    Left = 64
    Top = 223
    Width = 369
    Height = 47
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object EditQuantity: TEdit
    Left = 64
    Top = 276
    Width = 369
    Height = 50
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object EditCostUSD: TEdit
    Left = 64
    Top = 170
    Width = 369
    Height = 47
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object MemoNotes: TMemo
    Left = 64
    Top = 341
    Width = 369
    Height = 89
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    Lines.Strings = (
      'MemoNotes')
    ParentFont = False
    TabOrder = 5
  end
  object ButtonSave: TButton
    Left = 112
    Top = 439
    Width = 337
    Height = 65
    Caption = #1573#1590#1575#1601#1577' '#1575#1604#1576#1590#1575#1593#1577' '#1575#1604#1580#1583#1610#1583#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = ButtonSaveClick
  end
  object QryMaxID: TADOQuery
    Parameters = <>
    Left = 64
    Top = 176
  end
  object QryInsertItem: TADOQuery
    Parameters = <>
    Left = 56
    Top = 256
  end
end
