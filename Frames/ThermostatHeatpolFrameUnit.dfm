inherited ThermostatHeatpolFrame: TThermostatHeatpolFrame
  Height = 448
  ExplicitHeight = 448
  object SendBtn: TButton
    Left = 147
    Top = 8
    Width = 39
    Height = 25
    Caption = 'Send'
    TabOrder = 0
    OnClick = SendBtnClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 78
    Width = 373
    Height = 367
    ActivePage = TabSheet3
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object TabSheet3: TTabSheet
      Caption = 'Inne'
      ImageIndex = 2
      object FieldsEdit: TLabeledEdit
        Left = 69
        Top = 15
        Width = 60
        Height = 21
        EditLabel.Width = 57
        EditLabel.Height = 13
        EditLabel.Caption = 'Fields (HEX)'
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 42
        Width = 185
        Height = 127
        Caption = 'Time'
        TabOrder = 1
        object TimeSecEdit: TLabeledEdit
          Left = 82
          Top = 18
          Width = 60
          Height = 21
          EditLabel.Width = 17
          EditLabel.Height = 13
          EditLabel.Caption = 'Sec'
          LabelPosition = lpLeft
          TabOrder = 0
        end
        object TimeMinEdit: TLabeledEdit
          Left = 82
          Top = 45
          Width = 60
          Height = 21
          EditLabel.Width = 16
          EditLabel.Height = 13
          EditLabel.Caption = 'Min'
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object TimeHourEdit: TLabeledEdit
          Left = 82
          Top = 72
          Width = 60
          Height = 21
          EditLabel.Width = 23
          EditLabel.Height = 13
          EditLabel.Caption = 'Hour'
          LabelPosition = lpLeft
          TabOrder = 2
        end
        object TimeDofWEdit: TLabeledEdit
          Left = 82
          Top = 99
          Width = 60
          Height = 21
          EditLabel.Width = 57
          EditLabel.Height = 13
          EditLabel.Caption = 'dayOfWeek'
          LabelPosition = lpLeft
          TabOrder = 3
        end
      end
      object ScheduleTypeBox: TRadioGroup
        Left = 3
        Top = 186
        Width = 168
        Height = 66
        Caption = 'ScheduleType'
        ItemIndex = 1
        Items.Strings = (
          'TYPE_TEMPERATURE'
          'TYPE_PROGRAM')
        TabOrder = 2
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Temp/Preset'
      DesignSize = (
        365
        339)
      object TempGrid: TStringGrid
        Left = 3
        Top = 3
        Width = 359
        Height = 333
        Anchors = [akLeft, akTop, akBottom]
        ColCount = 4
        DefaultColWidth = 30
        DefaultRowHeight = 20
        RowCount = 11
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 0
        ColWidths = (
          30
          83
          84
          148)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Flags/Value'
      ImageIndex = 1
      DesignSize = (
        365
        339)
      object FlagsGrid: TStringGrid
        Left = 11
        Top = 6
        Width = 351
        Height = 333
        Anchors = [akLeft, akTop, akBottom]
        ColCount = 4
        DefaultColWidth = 30
        DefaultRowHeight = 20
        RowCount = 9
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 0
        ColWidths = (
          30
          58
          47
          198)
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Schedule'
      ImageIndex = 3
      object SchedulePaintBox: TPaintBox
        Left = 0
        Top = 0
        Width = 365
        Height = 339
        Align = alClient
        OnMouseDown = SchedulePaintBoxMouseDown
        OnPaint = SchedulePaintBoxPaint
        ExplicitLeft = 184
        ExplicitTop = 64
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
  object Button2: TButton
    Left = 187
    Top = 8
    Width = 42
    Height = 25
    Caption = 'Zapisz'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 78
    Top = 8
    Width = 67
    Height = 25
    Caption = 'SendShort'
    TabOrder = 3
    OnClick = Button3Click
  end
end
