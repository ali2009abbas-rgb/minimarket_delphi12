object EditItemForm: TEditItemForm
  Left = 0
  Top = 0
  Caption = #1608#1575#1580#1607#1577' '#1575#1604#1578#1593#1583#1610#1604' '#1593#1604#1609' '#1575#1604#1576#1590#1575#1593#1577
  ClientHeight = 446
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label6: TLabel
    Left = 455
    Top = 281
    Width = 78
    Height = 30
    Caption = #1605#1604#1575#1581#1592#1575#1578
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 455
    Top = 123
    Width = 162
    Height = 30
    Caption = #1587#1593#1585' '#1575#1604#1588#1585#1575#1569' '#1576#1575#1604#1583#1608#1604#1575#1585
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 455
    Top = 220
    Width = 53
    Height = 30
    Caption = #1575#1604#1603#1605#1610#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 455
    Top = 175
    Width = 169
    Height = 30
    Caption = #1587#1593#1585'  '#1575#1604#1605#1576#1610#1593' '#1576#1575#1604#1583#1608#1604#1575#1585
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 455
    Top = 67
    Width = 109
    Height = 30
    Caption = #1575#1587#1605' '#1575#1604#1576#1590#1575#1593#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 455
    Top = 22
    Width = 102
    Height = 30
    Caption = #1585#1605#1586' '#1575#1604#1576#1590#1575#1593#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MemoNotes: TMemo
    Left = 48
    Top = 262
    Width = 401
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
    TabOrder = 0
  end
  object EditCostUSD: TEdit
    Left = 48
    Top = 104
    Width = 401
    Height = 46
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
  object EditQuantity: TEdit
    Left = 48
    Top = 209
    Width = 401
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
  object EditPriceUSD: TEdit
    Left = 48
    Top = 156
    Width = 401
    Height = 47
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
  object EditItemName: TEdit
    Left = 48
    Top = 51
    Width = 401
    Height = 48
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
  object EditItemCode: TEdit
    Left = 48
    Top = 6
    Width = 401
    Height = 41
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
  end
  object ButtonSave: TButton
    Left = 104
    Top = 366
    Width = 345
    Height = 76
    Caption = #1578#1593#1583#1610#1604' '#1605#1593#1604#1608#1605#1575#1578' '#1575#1604#1576#1590#1575#1593#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = ButtonSaveClick
  end
  object QryUpdateItem: TADOQuery
    Parameters = <>
    Left = 32
    Top = 294
  end
end
