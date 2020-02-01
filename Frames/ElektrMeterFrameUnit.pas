unit ElektrMeterFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.ExtCtrls, supla_proto, ProgCfgUnit,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids;

type
  TElektrMeterFrame = class(TBaseFrame)
    Button1: TButton;
    PGrid: TStringGrid;
    MeasTabControl: TTabControl;
    MGrid: TStringGrid;
    FreqEdit: TLabeledEdit;
    CurrencyEdit: TLabeledEdit;
    TotalCostEdit: TLabeledEdit;
    PricePerUnitEdit: TLabeledEdit;
    MeasuredValueEdit: TLabeledEdit;
    PeriodEdit: TLabeledEdit;
    M_CountEdit: TLabeledEdit;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure MeasTabControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure MeasTabControlChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillMainGrid;
    function LoadMainGrid: Boolean;
    procedure FillMeasuregrid;
    function LoadMeasureGrid: Boolean;

  public
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); override;
    function getFrameHeight: integer; override;
    function getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): Boolean; override;

  end;

implementation

{$R *.dfm}

procedure TElektrMeterFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
var
  sz : integer;
begin
  inherited;
  PGrid.ColWidths[0] := 150;
  sz := (PGrid.Width-PGrid.ColWidths[0]-10) div 3;
  PGrid.ColWidths[1] := sz;
  PGrid.ColWidths[2] := sz;
  PGrid.ColWidths[3] := sz;

  MGrid.ColWidths[0] := 150;
  sz := (MGrid.Width-MGrid.ColWidths[0]-15) div 3;
  MGrid.ColWidths[1] := sz;
  MGrid.ColWidths[2] := sz;
  MGrid.ColWidths[3] := sz;


  SetResorcePic('ELECTRICITYMETER');
  PGrid.Rows[0].CommaText := 'Pomiar L1 L2 L3';
  PGrid.Cols[0].CommaText := 'Pomiar  "Forw.Activ Energ [kWh]" "Rever.Activ Energ [kWh]" "Forw.React.Energ [kWh]" "Rever.React.Energ [kWh]"';
  MGrid.Rows[0].CommaText := 'Pomiar L1 L2 L3';
  MGrid.Cols[0].CommaText :=
    'Pomiar  "Napiêcie [V]" "Pr¹d [A]" "Moc Czynna [W]" "Moc Bierna [var]" "Moc pozorna [VA]" "Power Factor" "K¹t fazowy"';

  FillMainGrid;
  FillMeasuregrid;

end;

function TElektrMeterFrame.getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): Boolean;
begin
  ChVal.ChannelNumber := mChannelNr;
  ChVal.value.loadFromElectricityMeter(mChannelCfg.EM.EM);
  Result := true;
end;

procedure TElektrMeterFrame.MeasTabControlChange(Sender: TObject);
begin
  inherited;
  FillMeasuregrid;
end;

procedure TElektrMeterFrame.MeasTabControlChanging(Sender: TObject; var AllowChange: Boolean);
begin
  inherited;
  AllowChange := LoadMeasureGrid;
end;

procedure TElektrMeterFrame.SaveBtnClick(Sender: TObject);
begin
  inherited;
  LoadMainGrid;
  LoadMeasureGrid;
end;

procedure TElektrMeterFrame.Button4Click(Sender: TObject);
var
  ChVal: TDS_SuplaDeviceChannelExtendedValue;
begin
  inherited;
  if LoadMainGrid and LoadMeasureGrid then
  begin
    getValueEx(ChVal);
    SendNewValueEx(ChVal);
  end;
end;

const
  MULTIPL_ENER: double = 100*1000;
  MULTIPL_POWER: double = 100 * 1000;
  MULTIPL_VOL: double = 100;
  MULTIPL_CURRENT: double = 100;
  MULTIPL_PF: double = 1000;
  MULTIPL_PHASE: double = 10;
  MULTIPL_FREQ: double = 100;
  MULTIPL_PERIOD: double = 1;
  MULTIPL_PRICEPERUNIT: double = 10000.0;
  MULTIPL_TOTALCOST: double = 100.0;

procedure TElektrMeterFrame.FillMainGrid;

var
  i: integer;
  EM: TElectricityMeter_ExtendedValue;
begin
  EM := mChannelCfg.EM.EM;
  for i := 0 to 2 do
  begin
    PGrid.Cells[i + 1, 1] := Format('%.3f', [EM.total_forward_active_energy[i] / MULTIPL_ENER]);
    PGrid.Cells[i + 1, 2] := Format('%.3f', [EM.total_reverse_active_energy[i] / MULTIPL_ENER]);
    PGrid.Cells[i + 1, 3] := Format('%.3f', [EM.total_forward_reactive_energy[i] / MULTIPL_ENER]);
    PGrid.Cells[i + 1, 4] := Format('%.3f', [EM.total_reverse_reactive_energy[i] / MULTIPL_ENER]);
  end;

  CurrencyEdit.Text := EM.currency.getAsString;
  TotalCostEdit.Text := Format('%.2f', [EM.total_cost / MULTIPL_TOTALCOST]);
  PricePerUnitEdit.Text := Format('%.4f', [EM.price_per_unit / MULTIPL_PRICEPERUNIT]);
  MeasuredValueEdit.Text := Format('0x%.4X', [EM.measured_values]);
  PeriodEdit.Text := Format('%f', [EM.period / MULTIPL_PERIOD]);
  M_CountEdit.Text := IntToStr(EM.m_count);
end;

procedure TElektrMeterFrame.LoadBtnClick(Sender: TObject);
begin
  inherited;
  FillMainGrid;
  FillMeasuregrid;
end;

function TElektrMeterFrame.LoadMainGrid: Boolean;
var
  i: integer;
  EM: TElectricityMeter_ExtendedValue;
begin
  EM := mChannelCfg.EM.EM;
  try

    for i := 0 to 2 do
    begin
      EM.total_forward_active_energy[i] := Trunc(StrToFloat(PGrid.Cells[i + 1, 1]) * MULTIPL_ENER);
      EM.total_reverse_active_energy[i] := Trunc(StrToFloat(PGrid.Cells[i + 1, 2]) * MULTIPL_ENER);
      EM.total_forward_reactive_energy[i] := Trunc(StrToFloat(PGrid.Cells[i + 1, 3]) * MULTIPL_ENER);
      EM.total_reverse_reactive_energy[i] := Trunc(StrToFloat(PGrid.Cells[i + 1, 4]) * MULTIPL_ENER);
    end;

    EM.currency.LoadFromString(CurrencyEdit.Text);
    EM.total_cost := Trunc(StrToFloat(TotalCostEdit.Text) * MULTIPL_TOTALCOST);
    EM.price_per_unit := Trunc(StrToFloat(PricePerUnitEdit.Text) * MULTIPL_PRICEPERUNIT);
    EM.measured_values := MyGetInt(MeasuredValueEdit.Text);
    EM.period := Trunc(StrToFloat(PeriodEdit.Text) * MULTIPL_PERIOD);
    EM.m_count := StrToInt(M_CountEdit.Text);
    mChannelCfg.EM.EM := EM;
    Result := true;
  except
    Application.ShowException(ExceptObject as Exception);
    Result := false;
  end;
end;

procedure TElektrMeterFrame.FillMeasuregrid;
var
  i: integer;
  EM: TElectricityMeter_Measurement;

begin
  EM := mChannelCfg.EM.EM.m[MeasTabControl.TabIndex];
  FreqEdit.Text := Format('%.2f', [EM.freq / MULTIPL_FREQ]);
  for i := 0 to 2 do
  begin
    MGrid.Cells[i + 1, 1] := Format('%.2f', [EM.voltage[i] / MULTIPL_VOL]);
    MGrid.Cells[i + 1, 2] := Format('%.3f', [EM.current[i] / MULTIPL_CURRENT]);
    MGrid.Cells[i + 1, 3] := Format('%.2f', [EM.power_active[i] / MULTIPL_POWER]);
    MGrid.Cells[i + 1, 4] := Format('%.2f', [EM.power_reactive[i] / MULTIPL_POWER]);
    MGrid.Cells[i + 1, 5] := Format('%.2f', [EM.power_apparent[i] / MULTIPL_POWER]);
    MGrid.Cells[i + 1, 6] := Format('%.3f', [EM.power_factor[i] / MULTIPL_PF]);
    MGrid.Cells[i + 1, 7] := Format('%.1f', [EM.phase_angle[i] / MULTIPL_PHASE]);
  end;
end;

function TElektrMeterFrame.LoadMeasureGrid: Boolean;
var
  i: integer;
  EM: TElectricityMeter_Measurement;

begin
  EM := mChannelCfg.EM.EM.m[MeasTabControl.TabIndex];
  try
    EM.freq := Trunc(StrToFloat(FreqEdit.Text) * MULTIPL_FREQ);
    for i := 0 to 2 do
    begin
      EM.voltage[i] := Trunc(StrToFloat(MGrid.Cells[i + 1, 1]) * MULTIPL_VOL);
      EM.current[i] := Trunc(StrToFloat(MGrid.Cells[i + 1, 2]) * MULTIPL_CURRENT);
      EM.power_active[i] := Trunc(StrToFloat(MGrid.Cells[i + 1, 3]) * MULTIPL_POWER);
      EM.power_reactive[i] := Trunc(StrToFloat(MGrid.Cells[i + 1, 4]) * MULTIPL_POWER);
      EM.power_apparent[i] := Trunc(StrToFloat(MGrid.Cells[i + 1, 5]) * MULTIPL_POWER);
      EM.power_factor[i] := Trunc(StrToFloat(MGrid.Cells[i + 1, 6]) * MULTIPL_PF);
      EM.phase_angle[i] := Trunc(StrToFloat(MGrid.Cells[i + 1, 7]) * MULTIPL_PHASE);
    end;
    mChannelCfg.EM.EM.m[MeasTabControl.TabIndex] := EM;
    Result := true;
  except
    Application.ShowException(ExceptObject as Exception);
    Result := false;
  end;
end;

procedure TElektrMeterFrame.Button1Click(Sender: TObject);
var
  ChVal: TDS_SuplaDeviceChannelValue;
begin
  inherited;
  getValue(ChVal);
  SendNewValue(ChVal);
end;

function TElektrMeterFrame.getFrameHeight: integer;
begin
  Result := Height;
end;

procedure TElektrMeterFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  ChVal.ChannelNumber := mChannelNr;
  // TElectricityMeter_Value;
  mChannelCfg.EM.EM.getAsShortValue(ChVal.value);
end;

end.
