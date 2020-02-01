unit RelayFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  supla_proto, ProgCfgUnit, System.ImageList, Vcl.ImgList, Vcl.StdCtrls;

type
  TRelayFrame = class(TBaseFrame)
    OnBtn: TButton;
    OffBtn: TButton;
    OffTimer: TTimer;
    ComboBox1: TComboBox;
    ShutterTimer: TTimer;
    ShutterLabel: TLabel;
    procedure OnBtnClick(Sender: TObject);
    procedure OffBtnClick(Sender: TObject);
    procedure OffTimerTimer(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ShutterTimerTimer(Sender: TObject);
  private
    powerOn: boolean;
    shutterProcent: double;
    shutterGoDown: boolean;
    shutterGoUp: boolean;
    durationMS: integer;
    time_goDn: integer;
    time_goUp: integer;

    procedure SetState(q: boolean);
    procedure SetShutterState(b: byte; duration: integer);

    procedure LoadImage;
    procedure HideShowBtn;

  public
    procedure SetNewValue(NewVal: TSD_SuplaChannelNewValue); override;
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); override;
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;
  end;

implementation

{$R *.dfm}

const
  SHUTTER = 4;

procedure TRelayFrame.SetState(q: boolean);
var
  SendDt: TDS_SuplaDeviceChannelValue;
begin
  inherited;
  powerOn := q;
  LoadImage;
  getValue(SendDt);
  SendNewValue(SendDt);
end;

procedure TRelayFrame.SetShutterState(b: byte; duration: integer);
begin
  time_goDn := 100 * (duration and $FFFF);
  time_goUp := 100 * ((duration shr 16) and $FFFF);
  Wr(Format('TmUP=%.1f  TmDN=%.1f', [time_goUp / 1000.0, time_goDn / 1000.0]));

  shutterGoUp := (b = 110) or (b = 1); // ((b and $02) <> 0);
  shutterGoDown := (b = 10) or (b = 2); // ((b and $01) <> 0);
  ShutterTimer.Enabled := shutterGoDown or shutterGoUp;
end;

procedure TRelayFrame.ShutterTimerTimer(Sender: TObject);
var
  ChVal: TDS_SuplaDeviceChannelValue;
  chg: boolean;
begin
  inherited;
  chg := false;
  if shutterGoDown then
  begin
    if shutterProcent > 0 then
    begin
      shutterProcent := shutterProcent - 100 * (250 / time_goUp);
      if shutterProcent < 0 then
        shutterProcent := 0;
      chg := true;
    end;
  end;

  if shutterGoUp then
  begin
    if shutterProcent < 100 then
    begin
      shutterProcent := shutterProcent + 100 * (250 / time_goDn);
      if shutterProcent >100 then
        shutterProcent := 100;
      chg := true;
    end;
  end;
  if chg then
  begin
    ShutterLabel.Caption := Format('%.1f%%', [shutterProcent]);
    getValue(ChVal);
    SendNewValue(ChVal);
  end;

end;

procedure TRelayFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  inherited;
  ComboBox1.ItemIndex := mChannelCfg.ChannelFun;
  ShutterLabel.Visible := (mChannelCfg.ChannelFun = SHUTTER);
  HideShowBtn;
  LoadImage;
end;

procedure TRelayFrame.HideShowBtn;
const
  setVis: set of byte = [5, 6];
var
  q: boolean;
begin
  q := mChannelCfg.ChannelFun in setVis;
  OnBtn.Visible := q;
  OffBtn.Visible := q;
end;

procedure TRelayFrame.OffTimerTimer(Sender: TObject);
begin
  inherited;
  OffTimer.Enabled := false;
  SetState(false);
end;

procedure TRelayFrame.OnBtnClick(Sender: TObject);
begin
  inherited;
  SetState(true);
end;

procedure TRelayFrame.OffBtnClick(Sender: TObject);
begin
  inherited;
  SetState(false);
end;

procedure TRelayFrame.SetNewValue(NewVal: TSD_SuplaChannelNewValue);
begin
  inherited;
  if mChannelCfg.ChannelFun <> SHUTTER then
    SetState(NewVal.value.dt[0] <> 0)
  else
    SetShutterState(NewVal.value.dt[0], NewVal.durationMS);
  durationMS := NewVal.durationMS;
  if durationMS <> 0 then
  begin
    OffTimer.Interval := durationMS;
    OffTimer.Enabled := true;
  end;
end;

procedure TRelayFrame.ComboBox1Change(Sender: TObject);
begin
  inherited;
  mChannelCfg.ChannelFun := ComboBox1.ItemIndex;
  LoadImage;
end;

procedure TRelayFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  inherited;
  if mChannelCfg.ChannelFun <> SHUTTER then
    ChVal.value.dt[0] := byte(powerOn)
  else
    ChVal.value.dt[0] := trunc(shutterProcent);
end;

procedure TRelayFrame.LoadImage;
type
  TDbString = record
    OffStr: string;
    OnStr: string;
  end;
const
  TabPic: array [0 .. 7] of TDbString = ( //
    (OffStr: 'GATEALT1CLOSED'; OnStr: 'GATEALT1OPEN'), //
    (OffStr: 'GATEWAYCLOSED'; OnStr: 'GATEWAYOPEN'), //
    (OffStr: 'GARAGEDOORCLOSED'; OnStr: 'GARAGEDOOROPEN'), //
    (OffStr: 'DOORCLOSED'; OnStr: 'DOOROPEN'), //
    (OffStr: 'ROLLERSHUTTERCLOSED'; OnStr: 'ROLLERSHUTTEROPEN'), //
    (OffStr: 'POWEROFF'; OnStr: 'POWERON'), //
    (OffStr: 'LIGHTOFF'; OnStr: 'LIGHTON'), //
    (OffStr: 'STAIRCASETIMEROFF'; OnStr: 'STAIRCASETIMERON')); //

begin
  if Assigned(mChannelCfg) then
  begin
    if powerOn then
      SetResorcePic(TabPic[mChannelCfg.ChannelFun].OnStr)
    else
      SetResorcePic(TabPic[mChannelCfg.ChannelFun].OffStr)
  end;
end;

end.
