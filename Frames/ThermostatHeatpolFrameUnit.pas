unit ThermostatHeatpolFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.ExtCtrls,
  supla_proto, ProgCfgUnit, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls;

type
  TSchedParam = record
    Width: integer;
    Height: integer;
    col0dx: integer;
    colDx: integer;
    row0dy: integer;
    rowDy: integer;
  end;

  TThermostatHeatpolFrame = class(TBaseFrame)
    SendBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TempGrid: TStringGrid;
    TabSheet2: TTabSheet;
    FlagsGrid: TStringGrid;
    TabSheet3: TTabSheet;
    FieldsEdit: TLabeledEdit;
    TimeSecEdit: TLabeledEdit;
    GroupBox1: TGroupBox;
    TimeMinEdit: TLabeledEdit;
    TimeHourEdit: TLabeledEdit;
    TimeDofWEdit: TLabeledEdit;
    TabSheet4: TTabSheet;
    SchedulePaintBox: TPaintBox;
    Button2: TButton;
    Button3: TButton;
    ScheduleTypeBox: TRadioGroup;
    procedure SendBtnClick(Sender: TObject);
    procedure SchedulePaintBoxPaint(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SchedulePaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure Button3Click(Sender: TObject);
  private
    SchedParam: TSchedParam;
    procedure FillFields;
    function ReadFields: Boolean;
    procedure LiczSchedParam;

  public
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;
    procedure SetCalCfg(CalCfg: TSD_DeviceCalCfgRequest); override;

    function getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): Boolean; override;
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); override;
  end;

implementation

{$R *.dfm}

procedure TThermostatHeatpolFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  inherited;

  TempGrid.Cols[0].CommaText := 'lp 0 1 2 3 4 5 6 7 8 9';
  TempGrid.Cells[1, 0] := 'Temperatura';
  TempGrid.Cells[2, 0] := 'Preset';
  TempGrid.Cells[3, 0] := 'Preset Name';

  TempGrid.Cells[3, 1] := 'Bie¿¹ce wartoœci';
  TempGrid.Cells[3, 3] := 'Max water tempr.';
  TempGrid.Cells[3, 4] := 'Reduction in ECO';
  TempGrid.Cells[3, 5] := 'Comfort temp. AUTO';
  TempGrid.Cells[3, 6] := 'ECO temp. AUTO';

  FlagsGrid.Cols[0].CommaText := 'lp 0 1 2 3 4 5 6 7';
  FlagsGrid.Cells[1, 0] := 'Flag';
  FlagsGrid.Cells[2, 0] := 'Values';
  FlagsGrid.Cells[3, 0] := 'Uwagi';
  FlagsGrid.Cells[3, 5] := 'V:Duration of the Turbo mode';

  FillFields;
end;

type
  Supla_TemeratureRecord = packed record
    tempNr: word;
    temperatureTab: array [0 .. 9] of word;
  end;

procedure TThermostatHeatpolFrame.SetCalCfg(CalCfg: TSD_DeviceCalCfgRequest);
var
  tRec: Supla_TemeratureRecord;
  i: integer;
  idx: integer;
  buf : bytes;
begin
  case CalCfg.Command of
    SUPLA_THERMOSTAT_CMD_TURNON:
      begin
        mChannelCfg.TH.dt.setThermostatOn(not mChannelCfg.TH.dt.getThermostatOn);
        if mChannelCfg.TH.dt.getThermostatOn = false then
        begin
          mChannelCfg.TH.dt.setEcoMode(false);
          mChannelCfg.TH.dt.setAutoMode(false);
          mChannelCfg.TH.dt.setTurboMode(false);
        end;
        FillFields;
        SendBtnClick(nil);

      end;
    SUPLA_THERMOSTAT_CMD_SET_MODE_AUTO:
      begin
        mChannelCfg.TH.dt.setEcoMode(false);
        mChannelCfg.TH.dt.setAutoMode(not mChannelCfg.TH.dt.getAutoMode);
        mChannelCfg.TH.dt.setTurboMode(false);
        FillFields;
        SendBtnClick(nil);
      end;

    SUPLA_THERMOSTAT_CMD_SET_MODE_ECO:
      begin
        mChannelCfg.TH.dt.setEcoMode(not mChannelCfg.TH.dt.getEcoMode);
        mChannelCfg.TH.dt.setAutoMode(false);
        mChannelCfg.TH.dt.setTurboMode(false);
        FillFields;
        SendBtnClick(nil);
      end;
    SUPLA_THERMOSTAT_CMD_SET_MODE_TURBO:
      begin
        mChannelCfg.TH.dt.setEcoMode(false);
        mChannelCfg.TH.dt.setAutoMode(false);
        mChannelCfg.TH.dt.setTurboMode(not mChannelCfg.TH.dt.getTurboMode);
        FillFields;
        SendBtnClick(nil);
      end;
    SUPLA_THERMOSTAT_CMD_SET_TIME:
      begin
        mChannelCfg.TH.dt.Values[4] := CalCfg.data[0];
        FillFields;
        SendBtnClick(nil);
      end;
    SUPLA_THERMOSTAT_CMD_SET_TEMPERATURE:
      begin
        move(CalCfg.data, tRec, sizeof(tRec));
        for i := 0 to 9 do
        begin
          if (tRec.tempNr and (1 shl i)) <> 0 then
          begin
            case i of
              3:
                idx := 4;
              4:
                idx := 5;
              5:
                idx := 3;
            else
              idx := i;
            end;

            mChannelCfg.TH.dt.PresetTemperature[idx] := tRec.temperatureTab[i];
          end;
        end;
        FillFields;
        SendBtnClick(nil);
      end;
    SUPLA_THERMOSTAT_CMD_SET_SCHEDULE:
      begin
        setlength(buf,CalCfg.DataSize);
        move(CalCfg.data,buf[0],CalCfg.DataSize);
      
        mChannelCfg.TH.dt.Schedule.SetFromCmd(buf);
        SchedulePaintBox.Invalidate;
        SendBtnClick(nil);
      end;
  end;

end;

function TThermostatHeatpolFrame.getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): Boolean;
begin
  ChVal.ChannelNumber := mChannelNr;
  ChVal.value.loadFromThermostat(mChannelCfg.TH.dt);
  Result := true;
end;

procedure TThermostatHeatpolFrame.SendBtnClick(Sender: TObject);
var
  ChVal: TDS_SuplaDeviceChannelExtendedValue;
begin
  inherited;
  ReadFields;
  getValueEx(ChVal);
  SendNewValueEx(ChVal);
end;

procedure TThermostatHeatpolFrame.Button2Click(Sender: TObject);
begin
  inherited;
  ReadFields;
end;

procedure TThermostatHeatpolFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  inherited;
  ChVal.ChannelNumber := mChannelNr;
  // TThermostat_Value;
  mChannelCfg.TH.dt.getAsShortValue(mChannelCfg.TH.IsOn, ChVal.value);
end;

const
  MULTIPL_TEMPER: double = 100;

procedure TThermostatHeatpolFrame.Button3Click(Sender: TObject);
var
  ChVal: TDS_SuplaDeviceChannelValue;
begin
  inherited;
  ReadFields;
  getValue(ChVal);
  SendNewValue(ChVal);
end;

procedure TThermostatHeatpolFrame.FillFields;
var
  dt: TThermostat_ExtendedValue;
  i: integer;
begin
  dt := mChannelCfg.TH.dt;

  if dt.getThermostatOn then
    SetResorcePic('THERMOSTATON')
  else
    SetResorcePic('THERMOSTATOFF');

  for i := 0 to 9 do
  begin
    TempGrid.Cells[1, i + 1] := Format('%.2f', [dt.MeasuredTemperature[i] / MULTIPL_TEMPER]);
    TempGrid.Cells[2, i + 1] := Format('%.2f', [dt.PresetTemperature[i] / MULTIPL_TEMPER]);
  end;

  for i := 0 to 7 do
  begin
    FlagsGrid.Cells[1, i + 1] := Format('0x%.4X', [dt.flags[i]]);
    FlagsGrid.Cells[2, i + 1] := Format('%d', [dt.Values[i]]);
  end;

  FieldsEdit.Text := Format('0x%.4X', [dt.Fields]);
  TimeSecEdit.Text := IntToStr(dt.Time.sec);
  TimeMinEdit.Text := IntToStr(dt.Time.min);
  TimeHourEdit.Text := IntToStr(dt.Time.hour);
  TimeDofWEdit.Text := IntToStr(dt.Time.dayOfWeek);
  ScheduleTypeBox.ItemIndex := dt.Schedule.ValueType;

end;

function TThermostatHeatpolFrame.ReadFields: Boolean;
var
  dt: TThermostat_ExtendedValue;
  i: integer;
begin
  try
    dt := mChannelCfg.TH.dt;

    for i := 0 to 9 do
    begin
      dt.MeasuredTemperature[i] := trunc(StrToFloat(TempGrid.Cells[1, i + 1]) * MULTIPL_TEMPER);
      dt.PresetTemperature[i] := trunc(StrToFloat(TempGrid.Cells[2, i + 1]) * MULTIPL_TEMPER);
    end;

    for i := 0 to 7 do
    begin
      dt.flags[i] := MyGetInt(FlagsGrid.Cells[1, i + 1]);
      dt.Values[i] := StrToInt(FlagsGrid.Cells[2, i + 1]);
    end;

    dt.Fields := MyGetInt(FieldsEdit.Text);
    dt.Time.sec := StrToInt(TimeSecEdit.Text);
    dt.Time.min := StrToInt(TimeMinEdit.Text);
    dt.Time.hour := StrToInt(TimeHourEdit.Text);
    dt.Time.dayOfWeek := StrToInt(TimeDofWEdit.Text);
    dt.Schedule.ValueType := ScheduleTypeBox.ItemIndex;

    mChannelCfg.TH.dt := dt;
    Result := true;
  except
    Application.ShowException(ExceptObject as Exception);
    Result := false;
  end;

end;

procedure TThermostatHeatpolFrame.LiczSchedParam;
begin
  SchedParam.Width := SchedulePaintBox.Width - 4;
  SchedParam.Height := SchedulePaintBox.Height - 4;

  SchedParam.row0dy := 20;
  SchedParam.rowDy := (SchedulePaintBox.Height - SchedParam.row0dy) div 24;
  SchedParam.col0dx := 20;
  SchedParam.colDx := (SchedulePaintBox.Width - SchedParam.col0dx) div 7;
  if SchedParam.colDx > 50 then
  begin
    SchedParam.colDx := 50;
    SchedParam.Width := 7 * SchedParam.colDx + SchedParam.col0dx;
  end;
end;

procedure TThermostatHeatpolFrame.SchedulePaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
  procedure ChgVal(var b: byte);
  begin
    if b = THERMOSTATE_PROG_COMFORT then
      b := THERMOSTATE_PROG_ECO
    else
      b := THERMOSTATE_PROG_COMFORT;
  end;

var
  col, row: integer;
begin
  inherited;
  LiczSchedParam;
  col := (X - SchedParam.col0dx) div SchedParam.colDx;
  row := (Y - SchedParam.row0dy) div SchedParam.rowDy;
  if (col >= 0) and (col < 7) and (row >= 0) and (row < 24) then
  begin
    col := (col + 1) mod 7;
    ChgVal(mChannelCfg.TH.dt.Schedule.HourValue[col][row]);
  end;
  SchedulePaintBox.Invalidate;

end;

procedure TThermostatHeatpolFrame.SchedulePaintBoxPaint(Sender: TObject);
const
  TabTyg: array [0 .. 6] of string = ('  Pon', '  Wt', '  Srd', '  Czw', '  Pt', '  Sob', '  Ndz');
var
  X, xx, Y: integer;
  cn: TCanvas;
  R: TRect;
  s: string;
begin
  cn := (Sender as TPaintBox).Canvas;

  LiczSchedParam;
  cn.Brush.Color := clWhite;

  for X := 0 to 6 do
  begin
    s := TabTyg[X];
    R.Top := 0;
    R.Bottom := SchedParam.row0dy;
    R.Left := SchedParam.col0dx + X * SchedParam.colDx;
    R.Right := R.Left + SchedParam.colDx;
    cn.TextRect(R, s);
    cn.MoveTo(R.Left, 0);
    cn.LineTo(R.Left, SchedParam.Height);
  end;

  for Y := 0 to 23 do
  begin
    s := Format(' %.2u', [Y]);
    R.Left := 0;
    R.Right := SchedParam.col0dx;
    R.Top := SchedParam.row0dy + Y * SchedParam.rowDy;
    R.Bottom := R.Top + SchedParam.rowDy;
    cn.TextRect(R, s);
    cn.MoveTo(0, R.Top);
    cn.LineTo(SchedParam.Width, R.Top);
  end;

  for X := 0 to 6 do
  begin
    for Y := 0 to 23 do
    begin
      R.Left := SchedParam.col0dx + X * SchedParam.colDx;
      R.Right := R.Left + SchedParam.colDx;
      R.Top := SchedParam.row0dy + Y * SchedParam.rowDy;
      R.Bottom := R.Top + SchedParam.rowDy;

      inc(R.Left, 3);
      dec(R.Right, 3);
      inc(R.Top, 2);
      dec(R.Bottom, 2);

      if mChannelCfg.TH.dt.Schedule.HourValue[(X + 1) mod 7][Y] = THERMOSTATE_PROG_COMFORT then
        cn.Brush.Color := clLime
      else
        cn.Brush.Color := clGray;
      cn.FillRect(R);

    end;
  end;

end;

end.
