program SuplaSym;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Supla_proto in 'Supla_proto.pas',
  SuplaDevDrvUnit in 'SuplaDevDrvUnit.pas',
  SuplaDevUnit in 'SuplaDevUnit.pas' {SuplaDevForm},
  ProgCfgUnit in 'ProgCfgUnit.pas',
  ConfigEditUnit in 'ConfigEditUnit.pas' {ConfigForm},
  NewChannelDialog in 'NewChannelDialog.pas' {NewChannelDlg},
  BaseFrameUnit in 'Frames\BaseFrameUnit.pas' {BaseFrame: TFrame},
  RelayFrameUnit in 'Frames\RelayFrameUnit.pas' {RelayFrame: TFrame},
  TemperatureFrameUnit in 'Frames\TemperatureFrameUnit.pas' {TemperatureFrame: TFrame},
  InputFrameUnit in 'Frames\InputFrameUnit.pas' {InputFrame: TFrame},
  TempHumidityFrameUnit in 'Frames\TempHumidityFrameUnit.pas' {TempHumidityFrame: TFrame},
  ElektrMeterFrameUnit in 'Frames\ElektrMeterFrameUnit.pas' {ElektrMeterFrame: TFrame},
  ImpulsCounterFrameUnit in 'Frames\ImpulsCounterFrameUnit.pas' {ImpulsCounterFrame: TFrame},
  ThermostatHeatpolFrameUnit in 'Frames\ThermostatHeatpolFrameUnit.pas' {ThermostatHeatpolFrame: TFrame},
  ThermostatFrameUnit in 'Frames\ThermostatFrameUnit.pas' {ThermostatFrame: TFrame},
  NoImplementedFrameUnit in 'Frames\NoImplementedFrameUnit.pas' {NoImplementedFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TNewChannelDlg, NewChannelDlg);
  Application.Run;
end.


