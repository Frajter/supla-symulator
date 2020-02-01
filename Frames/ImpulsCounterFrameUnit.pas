unit ImpulsCounterFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.ExtCtrls,
  supla_proto, ProgCfgUnit, Vcl.StdCtrls;

type
  TImpulsCounterFrame = class(TBaseFrame)
    SendBtn: TButton;
    CurrencyEdit: TLabeledEdit;
    PricePerUnitEdit: TLabeledEdit;
    TotalCostEdit: TLabeledEdit;
    Button1: TButton;
    UnitEdit: TLabeledEdit;
    ImpPerUnitEdit: TLabeledEdit;
    CounterEdit: TLabeledEdit;
    ValueEdit: TLabeledEdit;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    TimerOnBox: TCheckBox;
    TimerIntervalEdit: TLabeledEdit;
    Add1Btn: TButton;
    Add10Btn: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure SendBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Add10BtnClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TimerOnBoxClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure LoadImg;
    procedure FillFields;
    function ReadFields: Boolean;

  public
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;
    function getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): Boolean; override;
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); override;

  end;

implementation

{$R *.dfm}

procedure TImpulsCounterFrame.SendBtnClick(Sender: TObject);
var
  ChVal: TDS_SuplaDeviceChannelExtendedValue;
begin
  inherited;
  getValueEx(ChVal);
  SendNewValueEx(ChVal);

end;

procedure TImpulsCounterFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  inherited;
  LoadImg;
  FillFields;
end;

procedure TImpulsCounterFrame.Timer1Timer(Sender: TObject);
begin
  inherited;
  Add10BtnClick(Add1Btn);
end;

procedure TImpulsCounterFrame.TimerOnBoxClick(Sender: TObject);
begin
  inherited;
  Timer1.Interval := StrToInt(TimerIntervalEdit.Text);
  Timer1.Enabled := TimerOnBox.Checked;
end;

procedure TImpulsCounterFrame.LoadImg;
const
  TabBmp: array [0 .. 2] of string = ('GASMETER', 'ELECTRICITYMETER', 'WATERMETER');
begin
  SetResorcePic(TabBmp[mChannelCfg.ChannelFun mod 3]);
end;

const
  MULTIPL_PRICEPERUNIT: double = 10000.0;
  MULTIPL_TOTALCOST: double = 100.0;
  MULTIPL_VALUE: double = 1000.0;

procedure TImpulsCounterFrame.Add10BtnClick(Sender: TObject);
begin
  inherited;
  if Sender = Add10Btn then
    inc(mChannelCfg.IMP.dt.counter, 10)
  else
    inc(mChannelCfg.IMP.dt.counter, 1);
  mChannelCfg.IMP.dt.calculated_value :=
    trunc(MULTIPL_VALUE * (mChannelCfg.IMP.dt.counter * 1.0 / mChannelCfg.IMP.dt.impulses_per_unit) *
    (mChannelCfg.IMP.dt.price_per_unit / MULTIPL_PRICEPERUNIT));
  FillFields;
end;

procedure TImpulsCounterFrame.Button1Click(Sender: TObject);
begin
  inherited;
  mChannelCfg.ChannelFun := (mChannelCfg.ChannelFun + 1) mod 3;
  LoadImg;
end;

procedure TImpulsCounterFrame.Button2Click(Sender: TObject);
begin
  inherited;
  ReadFields;
end;

procedure TImpulsCounterFrame.Button3Click(Sender: TObject);
var
  ChVal: TDS_SuplaDeviceChannelValue;
begin
  inherited;
  getValue(ChVal);
  SendNewValue(ChVal);
end;

procedure TImpulsCounterFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  ChVal.ChannelNumber := mChannelNr;
  mChannelCfg.IMP.dt.getAsShortValue(ChVal.value);
end;



function TImpulsCounterFrame.getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): Boolean;
begin
  ChVal.ChannelNumber := mChannelNr;
  ChVal.value.loadFromImpulseCounter(mChannelCfg.IMP.dt);
  Result := true;
end;

procedure TImpulsCounterFrame.FillFields;
var
  dt: TSC_ImpulseCounter_ExtendedValue;
begin
  dt := mChannelCfg.IMP.dt;
  CurrencyEdit.Text := dt.currency.getAsString;
  PricePerUnitEdit.Text := Format('%.4f', [dt.price_per_unit / MULTIPL_PRICEPERUNIT]);
  TotalCostEdit.Text := Format('%.2f', [dt.total_cost / MULTIPL_TOTALCOST]);
  UnitEdit.Text := dt.custom_unit.getAsString;
  ImpPerUnitEdit.Text := Format('%u', [dt.impulses_per_unit]);
  CounterEdit.Text := Format('%u', [dt.counter]);
  ValueEdit.Text := Format('%.2f', [dt.calculated_value / MULTIPL_VALUE]);

end;

function TImpulsCounterFrame.ReadFields: Boolean;
var
  dt: TSC_ImpulseCounter_ExtendedValue;
begin
  try
    dt := mChannelCfg.IMP.dt;
    dt.currency.LoadFromString(CurrencyEdit.Text);
    dt.price_per_unit := trunc(StrToFloat(PricePerUnitEdit.Text) * MULTIPL_PRICEPERUNIT);
    dt.total_cost := trunc(StrToFloat(TotalCostEdit.Text) * MULTIPL_TOTALCOST);
    dt.custom_unit.LoadFromString(UnitEdit.Text);
    dt.impulses_per_unit := StrToInt(ImpPerUnitEdit.Text);
    dt.counter := StrToInt(CounterEdit.Text);
    dt.calculated_value := trunc(StrToFloat(ValueEdit.Text) * MULTIPL_VALUE);
    mChannelCfg.IMP.dt := dt;
    Result := true;
  except
    Application.ShowException(ExceptObject as Exception);
    Result := false;
  end;
end;

end.
