inherited ElektrMeterFrame: TElektrMeterFrame
  Width = 391
  Height = 472
  ExplicitWidth = 391
  ExplicitHeight = 472
  object Button1: TButton
    Left = 96
    Top = 8
    Width = 55
    Height = 25
    Caption = 'SendShort'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PGrid: TStringGrid
    Left = 3
    Top = 114
    Width = 373
    Height = 120
    Anchors = [akLeft, akTop, akRight]
    ColCount = 4
    DefaultColWidth = 120
    DefaultRowHeight = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    ColWidths = (
      120
      72
      68
      59)
  end
  object MeasTabControl: TTabControl
    Left = 3
    Top = 240
    Width = 378
    Height = 229
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Tabs.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5')
    TabIndex = 0
    OnChange = MeasTabControlChange
    OnChanging = MeasTabControlChanging
    DesignSize = (
      378
      229)
    object MGrid: TStringGrid
      Left = 3
      Top = 51
      Width = 363
      Height = 171
      Anchors = [akLeft, akTop, akRight]
      ColCount = 4
      DefaultColWidth = 120
      DefaultRowHeight = 20
      RowCount = 8
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      ColWidths = (
        120
        62
        70
        65)
    end
    object FreqEdit: TLabeledEdit
      Left = 56
      Top = 24
      Width = 65
      Height = 21
      EditLabel.Width = 41
      EditLabel.Height = 13
      EditLabel.Caption = 'Cz'#281'stot.'
      LabelPosition = lpLeft
      TabOrder = 1
    end
  end
  object CurrencyEdit: TLabeledEdit
    Left = 42
    Top = 87
    Width = 30
    Height = 21
    EditLabel.Width = 34
    EditLabel.Height = 13
    EditLabel.Caption = 'Waluta'
    LabelPosition = lpLeft
    TabOrder = 3
  end
  object TotalCostEdit: TLabeledEdit
    Left = 157
    Top = 39
    Width = 60
    Height = 21
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'TotalCost'
    LabelPosition = lpLeft
    TabOrder = 4
  end
  object PricePerUnitEdit: TLabeledEdit
    Left = 157
    Top = 63
    Width = 60
    Height = 21
    EditLabel.Width = 58
    EditLabel.Height = 13
    EditLabel.Caption = 'PricePerUnit'
    LabelPosition = lpLeft
    TabOrder = 5
  end
  object MeasuredValueEdit: TLabeledEdit
    Left = 157
    Top = 87
    Width = 60
    Height = 21
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'MeasuredVal'
    LabelPosition = lpLeft
    TabOrder = 6
  end
  object PeriodEdit: TLabeledEdit
    Left = 309
    Top = 39
    Width = 60
    Height = 21
    EditLabel.Width = 30
    EditLabel.Height = 13
    EditLabel.Caption = 'Period'
    LabelPosition = lpLeft
    TabOrder = 7
  end
  object M_CountEdit: TLabeledEdit
    Left = 309
    Top = 66
    Width = 60
    Height = 21
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'M_Count'
    LabelPosition = lpLeft
    TabOrder = 8
  end
  object SaveBtn: TButton
    Left = 301
    Top = 8
    Width = 36
    Height = 25
    Caption = 'Zapisz'
    TabOrder = 9
    OnClick = SaveBtnClick
  end
  object LoadBtn: TButton
    Left = 343
    Top = 8
    Width = 36
    Height = 25
    Caption = 'Odcz'
    TabOrder = 10
    OnClick = LoadBtnClick
  end
  object Button4: TButton
    Left = 157
    Top = 8
    Width = 55
    Height = 25
    Caption = 'Send'
    TabOrder = 11
    OnClick = Button4Click
  end
end
