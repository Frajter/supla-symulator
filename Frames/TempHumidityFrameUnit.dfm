inherited TempHumidityFrame: TTempHumidityFrame
  Height = 84
  ExplicitHeight = 84
  object TempValLabel: TLabel
    Left = 88
    Top = 10
    Width = 18
    Height = 16
    Caption = '0.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object HumiValLabel: TLabel
    Left = 88
    Top = 45
    Width = 18
    Height = 16
    Caption = '0.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ChTypeLabel: TLabel
    Left = 136
    Top = 65
    Width = 18
    Height = 16
    Caption = '0.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object TempTrackBar: TTrackBar
    Left = 126
    Top = 5
    Width = 171
    Height = 45
    Max = 1000
    Min = -200
    PageSize = 100
    Frequency = 100
    TabOrder = 0
    OnChange = TempTrackBarChange
  end
  object HumiTrackBar: TTrackBar
    Left = 126
    Top = 36
    Width = 171
    Height = 45
    Max = 1000
    PageSize = 100
    Frequency = 100
    TabOrder = 1
    OnChange = TempTrackBarChange
  end
end
