unit NewChannelDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Supla_proto, ProgCfgUnit, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TNewChannelDlg = class(TForm)
    TypeComboBox: TComboBox;
    Label1: TLabel;
    ChannelTypePageControl: TPageControl;
    UniParamSheet: TTabSheet;
    RelayParamSheet: TTabSheet;
    OkBtn: TButton;
    CancelBtn: TButton;
    FuncListEdit: TLabeledEdit;
    DefaultEdit: TLabeledEdit;
    ValueModePageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label2: TLabel;
    Byte0Edit: TLabeledEdit;
    Byte1Edit: TLabeledEdit;
    Byte2Edit: TLabeledEdit;
    Byte3Edit: TLabeledEdit;
    Byte7Edit: TLabeledEdit;
    Byte6Edit: TLabeledEdit;
    Byte5Edit: TLabeledEdit;
    Byte4Edit: TLabeledEdit;
    DoubleEdit: TLabeledEdit;
    Integer0Edit: TLabeledEdit;
    Integer1Edit: TLabeledEdit;
    Bit0Box: TCheckBox;
    Bit1Box: TCheckBox;
    Bit2Box: TCheckBox;
    Bit3Box: TCheckBox;
    Bit4Box: TCheckBox;
    Bit5Box: TCheckBox;
    Bit6Box: TCheckBox;
    Bit7Box: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    mTypeIdx: integer;
  public
    function getChannelCfg: TChannelCfg;
    procedure setChannelCfg(cfg: TChannelCfg);

  end;

var
  NewChannelDlg: TNewChannelDlg;

implementation

{$R *.dfm}



procedure TNewChannelDlg.FormCreate(Sender: TObject);
begin
  mTypeIdx := 0;
end;

procedure TNewChannelDlg.FormShow(Sender: TObject);
begin
  ChannelTypeList.LoadNames(TypeComboBox.Items);
  TypeComboBox.ItemIndex := mTypeIdx;
end;

function TNewChannelDlg.getChannelCfg: TChannelCfg;
  procedure LoadUniSheet(cfg: TChannelCfg);
  var
    db: Double;
    vv: integer;
  begin
    cfg.FuncList := MyGetInt(FuncListEdit.text);
    cfg.Default := MyGetInt(DefaultEdit.text);
    case ValueModePageControl.TabIndex of
      0:
        begin
          cfg.CurrValue.dt[0] := StrToInt('$' + Byte0Edit.text);
          cfg.CurrValue.dt[1] := StrToInt('$' + Byte1Edit.text);
          cfg.CurrValue.dt[2] := StrToInt('$' + Byte2Edit.text);
          cfg.CurrValue.dt[3] := StrToInt('$' + Byte3Edit.text);
          cfg.CurrValue.dt[4] := StrToInt('$' + Byte4Edit.text);
          cfg.CurrValue.dt[5] := StrToInt('$' + Byte5Edit.text);
          cfg.CurrValue.dt[6] := StrToInt('$' + Byte6Edit.text);
          cfg.CurrValue.dt[7] := StrToInt('$' + Byte7Edit.text);
        end;
      1:
        begin
          db := StrToFloat(DoubleEdit.text);
          cfg.CurrValue.setAsDouble(db);
        end;
      2:
        begin
          vv := MyGetInt(Integer0Edit.text);
          cfg.CurrValue.setInt_1(vv);
          vv := MyGetInt(Integer1Edit.text);
          cfg.CurrValue.setInt_2(vv);
        end;

    end;
  end;

  procedure LoadRelaySheet(cfg: TChannelCfg);
  begin
    cfg.FuncList := 0;
    cfg.Default := 0;
    cfg.CurrValue.Zero;
    if Bit0Box.Checked then
      cfg.FuncList := cfg.FuncList or $0001;
    if Bit1Box.Checked then
      cfg.FuncList := cfg.FuncList or $0002;
    if Bit2Box.Checked then
      cfg.FuncList := cfg.FuncList or $0004;
    if Bit3Box.Checked then
      cfg.FuncList := cfg.FuncList or $0008;
    if Bit4Box.Checked then
      cfg.FuncList := cfg.FuncList or $0010;
    if Bit5Box.Checked then
      cfg.FuncList := cfg.FuncList or $0020;
    if Bit6Box.Checked then
      cfg.FuncList := cfg.FuncList or $0040;
    if Bit7Box.Checked then
      cfg.FuncList := cfg.FuncList or $0080;
  end;

begin
  Result := TChannelCfg.Create;
  Result.ChannelType := ChannelTypeList.Items[TypeComboBox.ItemIndex].TypeCh;
  case ChannelTypePageControl.TabIndex of
    0:
      LoadUniSheet(Result);
    1:
      LoadRelaySheet(Result);
  end;

end;

procedure TNewChannelDlg.setChannelCfg(cfg: TChannelCfg);

  procedure SetUniSheet(cfg: TChannelCfg);
  begin
    FuncListEdit.text := '0x' + IntToHex(cfg.FuncList, 4);
    DefaultEdit.text := '0x' + IntToHex(cfg.Default, 4);
    // ByteMode
    Byte0Edit.text := IntToHex(cfg.CurrValue.dt[0], 2);
    Byte1Edit.text := IntToHex(cfg.CurrValue.dt[1], 2);
    Byte2Edit.text := IntToHex(cfg.CurrValue.dt[2], 2);
    Byte3Edit.text := IntToHex(cfg.CurrValue.dt[3], 2);
    Byte4Edit.text := IntToHex(cfg.CurrValue.dt[4], 2);
    Byte5Edit.text := IntToHex(cfg.CurrValue.dt[5], 2);
    Byte6Edit.text := IntToHex(cfg.CurrValue.dt[6], 2);
    Byte7Edit.text := IntToHex(cfg.CurrValue.dt[7], 2);
    // DoubleMode
    DoubleEdit.text := FloatToStr(cfg.CurrValue.getAsFloat);
    // 2xInteger
    Integer0Edit.text := IntToStr(cfg.CurrValue.getInt_1);
    Integer1Edit.text := IntToStr(cfg.CurrValue.getInt_2);
  end;

  procedure SetRelaySheet(cfg: TChannelCfg);
  begin
    Bit0Box.Checked := ((cfg.FuncList and $0001) <> 0);
    Bit1Box.Checked := ((cfg.FuncList and $0002) <> 0);
    Bit2Box.Checked := ((cfg.FuncList and $0004) <> 0);
    Bit3Box.Checked := ((cfg.FuncList and $0008) <> 0);
    Bit4Box.Checked := ((cfg.FuncList and $0010) <> 0);
    Bit5Box.Checked := ((cfg.FuncList and $0020) <> 0);
    Bit6Box.Checked := ((cfg.FuncList and $0040) <> 0);
    Bit7Box.Checked := ((cfg.FuncList and $0080) <> 0);
  end;

begin
  mTypeIdx := ChannelTypeList.getTypeIndex(cfg.ChannelType);
  SetUniSheet(cfg);
  SetRelaySheet(cfg);
end;

end.
