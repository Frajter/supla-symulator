object NewChannelDlg: TNewChannelDlg
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Definicja kana'#322'u'
  ClientHeight = 444
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    368
    444)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 21
    Width = 63
    Height = 16
    Caption = 'Typ kana'#322'u'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object TypeComboBox: TComboBox
    Left = 24
    Top = 40
    Width = 309
    Height = 24
    Style = csDropDownList
    DropDownCount = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object ChannelTypePageControl: TPageControl
    Left = 20
    Top = 88
    Width = 340
    Height = 297
    ActivePage = UniParamSheet
    TabOrder = 1
    object UniParamSheet: TTabSheet
      Caption = 'Uni'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 8
        Top = 98
        Width = 32
        Height = 16
        Caption = 'Value'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object FuncListEdit: TLabeledEdit
        Left = 64
        Top = 6
        Width = 89
        Height = 24
        EditLabel.Width = 46
        EditLabel.Height = 16
        EditLabel.Caption = 'FuncList'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -13
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        LabelPosition = lpLeft
        ParentFont = False
        TabOrder = 0
      end
      object DefaultEdit: TLabeledEdit
        Left = 64
        Top = 40
        Width = 89
        Height = 24
        EditLabel.Width = 40
        EditLabel.Height = 16
        EditLabel.Caption = 'Default'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -13
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        LabelPosition = lpLeft
        ParentFont = False
        TabOrder = 1
      end
      object ValueModePageControl: TPageControl
        Left = 3
        Top = 120
        Width = 326
        Height = 137
        ActivePage = TabSheet3
        TabOrder = 2
        object TabSheet3: TTabSheet
          Caption = 'Bytes'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Byte0Edit: TLabeledEdit
            Left = 3
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '0:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = '00'
          end
          object Byte1Edit: TLabeledEdit
            Left = 40
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '1:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Text = '00'
          end
          object Byte2Edit: TLabeledEdit
            Left = 78
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '2:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Text = '00'
          end
          object Byte3Edit: TLabeledEdit
            Left = 115
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '3:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Text = '00'
          end
          object Byte7Edit: TLabeledEdit
            Left = 266
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '7:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 7
            Text = '00'
          end
          object Byte6Edit: TLabeledEdit
            Left = 228
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '6:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            Text = '00'
          end
          object Byte5Edit: TLabeledEdit
            Left = 190
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '5:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Text = '00'
          end
          object Byte4Edit: TLabeledEdit
            Left = 153
            Top = 46
            Width = 32
            Height = 24
            EditLabel.Width = 12
            EditLabel.Height = 16
            EditLabel.Caption = '4:'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            Text = '00'
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'Double'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object DoubleEdit: TLabeledEdit
            Left = 71
            Top = 14
            Width = 89
            Height = 24
            EditLabel.Width = 51
            EditLabel.Height = 16
            EditLabel.Caption = 'Warto'#347#263' '
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            LabelPosition = lpLeft
            ParentFont = False
            TabOrder = 0
          end
        end
        object TabSheet2: TTabSheet
          Caption = '2xInteger'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Integer0Edit: TLabeledEdit
            Left = 79
            Top = 22
            Width = 89
            Height = 24
            EditLabel.Width = 62
            EditLabel.Height = 16
            EditLabel.Caption = 'Warto'#347#263' 1 '
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            LabelPosition = lpLeft
            ParentFont = False
            TabOrder = 0
          end
          object Integer1Edit: TLabeledEdit
            Left = 79
            Top = 62
            Width = 89
            Height = 24
            EditLabel.Width = 62
            EditLabel.Height = 16
            EditLabel.Caption = 'Warto'#347#263' 2 '
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -13
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            LabelPosition = lpLeft
            ParentFont = False
            TabOrder = 1
          end
        end
      end
    end
    object RelayParamSheet: TTabSheet
      Caption = 'Relay'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Bit0Box: TCheckBox
        Left = 24
        Top = 16
        Width = 201
        Height = 17
        Caption = 'CONTROLLINGTHEGATEWAYLOCK'
        TabOrder = 0
      end
      object Bit1Box: TCheckBox
        Left = 24
        Top = 39
        Width = 185
        Height = 17
        Caption = 'CONTROLLINGTHEGATE'
        TabOrder = 1
      end
      object Bit2Box: TCheckBox
        Left = 24
        Top = 62
        Width = 185
        Height = 17
        Caption = 'CONTROLLINGTHEGARAGEDOOR'
        TabOrder = 2
      end
      object Bit3Box: TCheckBox
        Left = 24
        Top = 85
        Width = 185
        Height = 17
        Caption = 'CONTROLLINGTHEDOORLOCK'
        TabOrder = 3
      end
      object Bit4Box: TCheckBox
        Left = 24
        Top = 108
        Width = 201
        Height = 17
        Caption = 'CONTROLLINGTHEROLLERSHUTTER'
        TabOrder = 4
      end
      object Bit5Box: TCheckBox
        Left = 24
        Top = 131
        Width = 97
        Height = 17
        Caption = 'POWERSWITCH'
        TabOrder = 5
      end
      object Bit6Box: TCheckBox
        Left = 24
        Top = 154
        Width = 97
        Height = 17
        Caption = 'LIGHTSWITCH'
        TabOrder = 6
      end
      object Bit7Box: TCheckBox
        Left = 24
        Top = 177
        Width = 97
        Height = 17
        Caption = 'STAIRCASETIMER'
        TabOrder = 7
      end
    end
  end
  object OkBtn: TButton
    Left = 20
    Top = 410
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 116
    Top = 410
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
