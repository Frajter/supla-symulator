unit TempHumidityFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.ExtCtrls,
  supla_proto, progCfgUnit, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TTempHumidityFrame = class(TBaseFrame)
    TempTrackBar: TTrackBar;
    TempValLabel: TLabel;
    HumiTrackBar: TTrackBar;
    HumiValLabel: TLabel;
    ChTypeLabel: TLabel;
    procedure TempTrackBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); override;
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;
  end;

implementation

{$R *.dfm}

procedure TTempHumidityFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  ChVal.ChannelNumber := mChannelNr;
  ChVal.value.setAsDouble(TempTrackBar.Position / 10.0);
end;

procedure TTempHumidityFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  inherited;
  SetResorcePic('HUMIDITY');
  ChTypeLabel.Caption := ChannelTypeList.getTypeName(ChCfg.ChannelType);
end;

procedure TTempHumidityFrame.TempTrackBarChange(Sender: TObject);
var
  w: double;
  h: double;
  ChVal: TDS_SuplaDeviceChannelValue;
begin
  inherited;
  w := TempTrackBar.Position / 10.0;
  h := HumiTrackBar.Position / 10.0;
  TempValLabel.Caption := Format('%.1f', [w]);
  HumiValLabel.Caption := Format('%.1f%%', [h]);
  ChVal.ChannelNumber := mChannelNr;
  ChVal.value.setInt_1(trunc(1000 * w));
  ChVal.value.setInt_2(trunc(1000 * h));
  SendNewValue(ChVal);
end;

end.
