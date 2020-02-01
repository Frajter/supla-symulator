inherited InputFrame: TInputFrame
  object ChTypeLabel: TLabel
    Left = 78
    Top = 2
    Width = 73
    Height = 16
    Caption = 'ChTypeLabel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Bit0ToggleSwitch: TToggleSwitch
    Left = 78
    Top = 22
    Width = 72
    Height = 20
    TabOrder = 0
    OnClick = Bit0ToggleSwitchClick
  end
  object ComboBox1: TComboBox
    Left = 78
    Top = 48
    Width = 211
    Height = 24
    Style = csDropDownList
    DropDownCount = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = ComboBox1Change
    Items.Strings = (
      'Brak'
      'Czujnik otwarcia furtki'
      'Czujnik otwarcia bramy wjazdowej'
      'Czujnik otwarcia bramy gara'#380'owej'
      'Czujnik otwarcia drzwi'
      'Czujnik braku cieczy'
      'Czujnik otwarcia rolet'
      'Czujnik otwarcia okna'
      'Czujnik poczty')
  end
end
