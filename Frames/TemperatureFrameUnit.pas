unit TemperatureFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, supla_proto, progCfgUnit, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TTemperatureFrame = class(TBaseFrame)
    TrackBar: TTrackBar;
    ValLabel: TLabel;
    ChTypeLabel: TLabel;
    procedure TrackBarChange(Sender: TObject);
  private
    divid: double;
    divid2: double;
  public
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); override;
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;

  end;

implementation

{$R *.dfm}

procedure TTemperatureFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  inherited;
  ChVal.ChannelNumber := mChannelNr;
  ChVal.value.setAsDouble(TrackBar.Position / divid);
end;

procedure TTemperatureFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  inherited;
  ChTypeLabel.Caption := ChannelTypeList.getTypeName(ChCfg.ChannelType);
  divid := 10.0;
  divid2 := 1;
  case ChCfg.ChannelType of
    SUPLA_CHANNELTYPE_THERMOMETERDS18B20, SUPLA_CHANNELTYPE_THERMOMETER:
      begin
        SetResorcePic('THERMOMETER');
        TrackBar.Min := -200;
        TrackBar.Max := 1000;
        divid := 10.0;
      end;

    SUPLA_CHANNELTYPE_WINDSENSOR:
      begin
        SetResorcePic('WIND');
        TrackBar.Min := 0;
        TrackBar.Max := 1000;
      end;
    SUPLA_CHANNELTYPE_RAINSENSOR:
      begin
        SetResorcePic('RAIN');
        TrackBar.Min := 0;
        TrackBar.Max := 100;
        divid := 0.01;
        divid2 := 1000;
      end;
    SUPLA_CHANNELTYPE_PRESSURESENSOR:
      begin
        SetResorcePic('PRESSURE');
        TrackBar.Max := 10500;
        TrackBar.Min := 9500;
      end;

    SUPLA_CHANNELTYPE_WEIGHTSENSOR:
      begin
        SetResorcePic('WEIGHT');
        TrackBar.Min := 0;
        TrackBar.Max := 2000;
        divid := 0.01;
        divid2 := 1000;
      end;
    SUPLA_CHANNELTYPE_DISTANCESENSOR:
      begin
        SetResorcePic('DEPTHSENSOR');
        TrackBar.Min := 0;
        TrackBar.Max := 2000;
        divid := 1000;
        divid2 := 1;
      end;
  end;

end;

procedure TTemperatureFrame.TrackBarChange(Sender: TObject);
var
  w: double;
  SupVal: TDS_SuplaDeviceChannelValue;
begin
  inherited;
  w := TrackBar.Position / divid;
  SupVal.ChannelNumber := mChannelNr;
  SupVal.value.setAsDouble(w);
  SendNewValue(SupVal);
  ValLabel.Caption := Format('%.1f', [w / divid2]);
end;

end.
