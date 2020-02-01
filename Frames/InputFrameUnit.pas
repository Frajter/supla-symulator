unit InputFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, supla_proto, ProgCfgUnit;

type
  TInputFrame = class(TBaseFrame)
    ChTypeLabel: TLabel;
    Bit0ToggleSwitch: TToggleSwitch;
    ComboBox1: TComboBox;
    procedure Bit0ToggleSwitchClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    procedure LoadImage;
  public
    procedure settype(ChannelType: integer);
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); override;


  end;

implementation

{$R *.dfm}

procedure TInputFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  inherited;
  ComboBox1.ItemIndex := mChannelCfg.ChannelFun;
  LoadImage;
end;

procedure TInputFrame.LoadImage;
const
  TabPic: array [0 .. 8] of String = ('', //
    'GATEWAYCLOSED', //
    'GATEALT1CLOSED', //
    'GARAGEDOOROPEN', //
    'DOOROPEN', //
    'NOLIQUID', //
    'ROLLERSHUTTEROPEN', //
    'WINDOWOPEN', //
    'NOMAIL');

begin
  if Assigned(mChannelCfg) then
    SetResorcePic(TabPic[mChannelCfg.ChannelFun]);
end;

procedure TInputFrame.Bit0ToggleSwitchClick(Sender: TObject);
var
  ToSendVal: TDS_SuplaDeviceChannelValue;
begin
  inherited;
  ToSendVal.value.Zero;
  if Bit0ToggleSwitch.State = tssOn then
    ToSendVal.value.dt[0] := $01;
  ToSendVal.ChannelNumber := mChannelNr;
  SendNewValue(ToSendVal);
end;

procedure TInputFrame.ComboBox1Change(Sender: TObject);
begin
  inherited;
  mChannelCfg.ChannelFun := ComboBox1.ItemIndex;
  LoadImage;
end;

procedure TInputFrame.settype(ChannelType: integer);
begin
  ChTypeLabel.Caption := ChannelTypeList.getTypeName(ChannelType);
  LoadImage;
end;

procedure TInputFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  inherited;
  if Bit0ToggleSwitch.State = tssOn then
    ChVal.value.dt[0] := $01;
end;


end.
