object ProfitReportForm: TProfitReportForm
  Left = 0
  Top = 0
  Caption = 'ProfitReportForm'
  ClientHeight = 590
  ClientWidth = 1112
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 393
    Top = 264
    Width = 49
    Height = 15
    Caption = 'InvoiceID'
  end
  object Label2: TLabel
    Left = 599
    Top = 494
    Width = 281
    Height = 32
    Caption = #1573#1580#1605#1575#1604#1610' '#1575#1604#1585#1576#1581' '#1575#1604#1589#1575#1601#1610' '#1576#1575#1604#1583#1608#1604#1575#1585
    Color = clFuchsia
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 729
    Top = 8
    Width = 115
    Height = 32
    Caption = #1578#1575#1585#1610#1582' '#1575#1604#1576#1583#1575#1610#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 337
    Top = 8
    Width = 115
    Height = 32
    Caption = #1578#1575#1585#1610#1582' '#1575#1604#1606#1607#1575#1610#1577
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 598
    Top = 547
    Width = 220
    Height = 32
    Caption = #1573#1580#1605#1575#1604#1610' '#1575#1604#1605#1576#1610#1593' '#1576#1575#1604#1587#1608#1585#1610
    Color = clFuchsia
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label6: TLabel
    Left = 383
    Top = 503
    Width = 32
    Height = 21
    Caption = #1583#1608#1604#1575#1585
    Color = clFuchsia
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label7: TLabel
    Left = 345
    Top = 556
    Width = 70
    Height = 21
    Caption = #1604#1610#1585#1577' '#1587#1608#1585#1610#1577
    Color = clFuchsia
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object DTPStart: TDateTimePicker
    Left = 689
    Top = 42
    Width = 186
    Height = 29
    Date = 45965.000000000000000000
    Time = 0.823185972221836000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object DTPEnd: TDateTimePicker
    Left = 305
    Top = 42
    Width = 186
    Height = 29
    Date = 45963.000000000000000000
    Time = 0.823280196760606500
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object ButtonGenerateReport: TButton
    Left = 393
    Top = 77
    Width = 417
    Height = 50
    Caption = #1606#1578#1610#1580#1577' '#1575#1604#1585#1576#1581' '#1576#1610#1606' '#1575#1604#1578#1575#1585#1610#1582#1610#1606' '#1575#1604#1605#1581#1583#1583#1610#1606
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = ButtonGenerateReportClick
  end
  object DBGReport: TDBGrid
    Left = 200
    Top = 126
    Width = 904
    Height = 363
    DataSource = DataSource1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taCenter
        BiDiMode = bdRightToLeft
        Expanded = False
        FieldName = 'SaleDate'
        Title.Alignment = taCenter
        Width = 125
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'CustomerName'
        Title.Alignment = taCenter
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ItemName'
        Title.Alignment = taCenter
        Width = 200
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Quantity'
        Title.Alignment = taCenter
        Width = 50
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'UnitPriceSYP'
        Visible = False
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'LineTotalSYP'
        Visible = False
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'UnitCostUSD'
        Title.Alignment = taCenter
        Title.Caption = #1587#1593#1585' '#1575#1604#1588#1585#1575#1569' '#1576#1575#1604#1583#1608#1604#1575#1585
        Width = 100
        Visible = True
      end
      item
        Alignment = taCenter
        BiDiMode = bdRightToLeft
        Expanded = False
        FieldName = 'LineProfitUSD'
        Title.Alignment = taCenter
        Width = 100
        Visible = True
      end
      item
        Alignment = taCenter
        BiDiMode = bdRightToLeft
        Expanded = False
        FieldName = 'InvoiceID'
        Title.Alignment = taCenter
        Title.Caption = #1585#1602#1605' '#1575#1604#1601#1575#1578#1608#1585#1577
        Width = 60
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'PriceUSD'
        Title.Alignment = taCenter
        Title.Caption = #1587#1593#1585' '#1575#1604#1605#1576#1610#1593' '#1576#1575#1604#1583#1608#1604#1575#1585
        Width = 100
        Visible = True
      end>
  end
  object EditTotalProfit: TEdit
    Left = 416
    Top = 490
    Width = 180
    Height = 45
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
  object ButtonExport: TButton
    Left = 50
    Top = 448
    Width = 144
    Height = 57
    Caption = #1575#1604#1578#1589#1583#1610#1585' '#1573#1604#1609' '#1580#1583#1608#1604
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = ButtonExportClick
  end
  object Edit1: TEdit
    Left = 416
    Top = 543
    Width = 179
    Height = 45
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
  end
  object QryProfit: TADOQuery
    Connection = Form1.ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT *  FROM [Sales$];')
    Left = 81
    Top = 176
    object QryProfitSaleDate: TWideStringField
      DisplayLabel = #1578#1575#1585#1610#1582' '#1575#1604#1576#1610#1593
      FieldName = 'SaleDate'
      Size = 255
    end
    object QryProfitCustomerName: TWideStringField
      DisplayLabel = #1575#1587#1605' '#1575#1604#1586#1576#1608#1606
      FieldName = 'CustomerName'
      Size = 255
    end
    object QryProfitItemName: TWideStringField
      DisplayLabel = #1575#1587#1605' '#1575#1604#1576#1590#1575#1593#1577
      FieldName = 'ItemName'
      Size = 255
    end
    object QryProfitQuantity: TWideStringField
      DisplayLabel = #1575#1604#1603#1605#1610#1577
      FieldName = 'Quantity'
      Size = 255
    end
    object QryProfitUnitPriceSYP: TWideStringField
      FieldName = 'UnitPriceSYP'
      Size = 255
    end
    object QryProfitLineTotalSYP: TWideStringField
      FieldName = 'LineTotalSYP'
      Size = 255
    end
    object QryProfitUnitCostUSD: TWideStringField
      DisplayLabel = #1578#1603#1604#1601#1577' '#1575#1604#1608#1581#1583#1577' ($)'
      FieldName = 'UnitCostUSD'
      Size = 255
    end
    object QryProfitLineProfitUSD: TWideStringField
      DisplayLabel = #1575#1604#1585#1576#1581' '#1575#1604#1589#1575#1601#1610' ($)'
      FieldName = 'LineProfitUSD'
      Size = 255
    end
    object QryProfitInvoiceID: TWideStringField
      FieldName = 'InvoiceID'
      Size = 255
    end
    object QryProfitPriceUSD: TWideStringField
      FieldName = 'PriceUSD'
      Size = 255
    end
  end
  object DataSource1: TDataSource
    DataSet = QryProfit
    Left = 217
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'xlsx'
    Filter = 'Excel Files (*.xlsx)'
    Left = 73
    Top = 32
  end
end
