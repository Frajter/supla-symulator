inherited ImpulsCounterFrame: TImpulsCounterFrame
  Height = 170
  ExplicitHeight = 170
  object SendBtn: TButton
    Left = 151
    Top = 8
    Width = 40
    Height = 25
    Caption = 'Send'
    TabOrder = 1
    OnClick = SendBtnClick
  end
  object CurrencyEdit: TLabeledEdit
    Left = 157
    Top = 90
    Width = 30
    Height = 21
    EditLabel.Width = 34
    EditLabel.Height = 13
    EditLabel.Caption = 'Waluta'
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
    TabOrder = 2
  end
  object Button1: TButton
    Left = 8
    Top = 78
    Width = 27
    Height = 25
    Caption = '>>'
    TabOrder = 0
    OnClick = Button1Click
  end
  object UnitEdit: TLabeledEdit
    Left = 157
    Top = 117
    Width = 60
    Height = 21
    EditLabel.Width = 49
    EditLabel.Height = 13
    EditLabel.Caption = 'Jednostka'
    LabelPosition = lpLeft
    TabOrder = 5
  end
  object ImpPerUnitEdit: TLabeledEdit
    Left = 157
    Top = 144
    Width = 60
    Height = 21
    EditLabel.Width = 110
    EditLabel.Height = 13
    EditLabel.Caption = 'Impuls'#243'w na jednostk'#281
    LabelPosition = lpLeft
    TabOrder = 6
  end
  object CounterEdit: TLabeledEdit
    Left = 293
    Top = 117
    Width = 76
    Height = 21
    TabStop = False
    EditLabel.Width = 30
    EditLabel.Height = 13
    EditLabel.Caption = 'Licznik'
    LabelPosition = lpLeft
    ReadOnly = True
    TabOrder = 10
  end
  object ValueEdit: TLabeledEdit
    Left = 293
    Top = 144
    Width = 76
    Height = 21
    TabStop = False
    EditLabel.Width = 40
    EditLabel.Height = 13
    EditLabel.Caption = 'Warto'#347#263
    LabelPosition = lpLeft
    ReadOnly = True
    TabOrder = 11
  end
  object GroupBox1: TGroupBox
    Left = 240
    Top = 3
    Width = 139
    Height = 69
    Caption = 'Timer'
    TabOrder = 7
    object TimerOnBox: TCheckBox
      Left = 10
      Top = 18
      Width = 97
      Height = 17
      Caption = 'Za'#322#261'cz'
      TabOrder = 0
      OnClick = TimerOnBoxClick
    end
    object TimerIntervalEdit: TLabeledEdit
      Left = 63
      Top = 41
      Width = 60
      Height = 21
      EditLabel.Width = 39
      EditLabel.Height = 13
      EditLabel.Caption = 'Interva'#322
      LabelPosition = lpLeft
      TabOrder = 1
      Text = '1000'
    end
  end
  object Add1Btn: TButton
    Left = 240
    Top = 78
    Width = 49
    Height = 25
    Caption = '+1'
    TabOrder = 8
    OnClick = Add10BtnClick
  end
  object Add10Btn: TButton
    Left = 303
    Top = 78
    Width = 49
    Height = 25
    Caption = '+10'
    TabOrder = 9
    OnClick = Add10BtnClick
  end
  object Button2: TButton
    Left = 192
    Top = 8
    Width = 42
    Height = 25
    Caption = 'Zapisz'
    TabOrder = 12
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 78
    Top = 8
    Width = 67
    Height = 25
    Caption = 'SendShort'
    TabOrder = 13
    OnClick = Button3Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 224
    Top = 128
  end
end
