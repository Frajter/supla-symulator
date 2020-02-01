unit ProgCfgUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Forms,
  Contnrs, Registry,
  Supla_proto;

type
  TGuid = record
    dt: TSuplaGuid;
    function getAsString: string;
    function getAsHumanString: string;
    function loadFromStr(s: string): boolean;
    procedure Zero;
    procedure GenerNew;
  end;

  TAuthKey = record
    dt: TSuplaAuthKey;
    function getAsString: string;
    function getAsHumanString: string;
    function loadFromStr(s: string): boolean;
    procedure Zero;
    procedure GenerNew;
  end;

  TRegistryEx = class(TRegistry)
  public
    procedure ReadEx(name: string; var val: integer); overload;
    procedure ReadEx(name: string; var val: cardinal); overload;
    procedure ReadEx(name: string; var val: smallint); overload;
    procedure ReadEx(name: string; var val: word); overload;
    procedure ReadEx(name: string; var val: byte); overload;
    procedure ReadEx(name: string; var val: TWindowState); overload;

    procedure ReadEx(name: string; var val: boolean); overload;
    procedure ReadEx(name: string; var val: Double); overload;
    procedure ReadEx(name: string; var val: String); overload;
    procedure ReadEx(name: string; var val: Uint64); overload;

    procedure ReadEx(name: string; var val: TGuid); overload;
    procedure ReadEx(name: string; var val: TAuthKey); overload;
    procedure ReadEx(name: string; var val: TSuplaVal); overload;
  public
    procedure WriteEx(name: string; val: integer); overload;
    procedure WriteEx(name: string; val: TWindowState); overload;

    procedure WriteEx(name: string; val: cardinal); overload;
    procedure WriteEx(name: string; val: boolean); overload;
    procedure WriteEx(name: string; val: Double); overload;
    procedure WriteEx(name: string; const val: String); overload;
    procedure WriteEx(name: string; const val: TGuid); overload;
    procedure WriteEx(name: string; const val: TAuthKey); overload;
    procedure WriteEx(name: string; const val: TSuplaVal); overload;
  end;

  TElekMeterEx = record
    EM: TElectricityMeter_ExtendedValue;
    procedure SaveToReg(reg: TRegistryEx);
    procedure LoadFromReg(reg: TRegistryEx);
  end;

  TImpulCounterEx = record
    dt: TSC_ImpulseCounter_ExtendedValue;
    procedure SaveToReg(reg: TRegistryEx);
    procedure LoadFromReg(reg: TRegistryEx);
  end;

  TThermostatEx = record
    dt: TThermostat_ExtendedValue;
    IsOn: boolean;
    procedure SaveToReg(reg: TRegistryEx);
    procedure LoadFromReg(reg: TRegistryEx);
  end;

  TChannelCfg = class(TObject)
    ChannelType: integer;
    FuncList: integer;
    Default: integer;
    CurrValue: TSuplaVal;
    EM: TElekMeterEx;
    IMP: TImpulCounterEx;
    TH: TThermostatEx;
    // ----------------
    ChannelFun: integer;
    procedure SaveToReg(reg: TRegistryEx);
    procedure LoadFromReg(reg: TRegistryEx);
    procedure copyFrom(src: TChannelCfg);
  end;

  TChannelList = class(TObjectList)
  private
    function FGetItem(Index: integer): TChannelCfg;
  public
    property Items[Index: integer]: TChannelCfg read FGetItem;
    procedure SaveToReg(reg: TRegistryEx);
    procedure LoadFromReg(reg: TRegistryEx);
    function isFirst(cfg: TChannelCfg): boolean;
    function isLast(cfg: TChannelCfg): boolean;
    procedure MoveUp(cfg: TChannelCfg);
    procedure MoveDn(cfg: TChannelCfg);

  end;

  TSuplaDevCfg = class(TObject)
    Guid: TGuid;
    AuthKey: TAuthKey;
    name: string;
    SoftVer: string;
    Channels: TChannelList;
    useSSL: boolean;
    autoReconnect: boolean;

    Registered: boolean; // informacja czy definicja zosta³a ju¿ zarejestrowana na serwerze SUPLI
    M_Top, M_Left, M_Width, M_Height: integer;
    M_Winstate: TWindowState;
    MemoHeight: integer;

    Form: TForm; // Forma skojarzona z ta definicj¹
    constructor Create;
    destructor Destroy; override;
    procedure SaveToReg(reg: TRegistryEx);
    procedure LoadFromReg(reg: TRegistryEx);
    procedure deleteChannel(Ch: TChannelCfg);
  end;

  TSuplaDevCfgList = class(TObjectList)
  private
    function FGetItem(Index: integer): TSuplaDevCfg;
  public
    property Items[Index: integer]: TSuplaDevCfg read FGetItem;
    procedure SaveToReg(reg: TRegistryEx);
    procedure LoadFromReg(reg: TRegistryEx);
  end;

  TProgCfg = class(TObject)
    ServerName: string;
    Email: string;
    DevCfgList: TSuplaDevCfgList;
    W_Top, W_Left, W_Width, W_Height: integer;
    W_WinState: TWindowState;
    SpecUser : boolean;
    constructor Create;
    destructor Destroy; override;
    procedure SaveToReg;
    procedure LoadFromReg;
    function AddDevice: TSuplaDevCfg;
    function DelDevice(DevCfg: TSuplaDevCfg): boolean;
  end;

var
  ProgCfg: TProgCfg;

function MyGetInt(s: string): integer;
function makeHexStr(var dt; cnt: integer): string;

implementation

uses
  SuplaDevUnit;

const
  REG_KEY = '\SOFTWARE\GEKA\SUPLA\SYMULATOR';

function MyGetInt(s: string): integer;
begin
  if length(s) >= 2 then
  begin
    if Copy(s, 1, 2) = '0x' then
      s := '$' + Copy(s, 3, length(s) - 2);
  end;
  Result := 0;
  TryStrToInt(s, Result);
end;

function makeHexStr(var dt; cnt: integer): string;
var
  pb: pByte;
  i: integer;
begin
  Result := '';
  pb := pByte(@dt);
  for i := 0 to cnt - 1 do
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + IntToHex(pb^, 2);
    inc(pb);
  end;
end;

procedure TRegistryEx.ReadEx(name: string; var val: integer);
begin
  if ValueExists(name) then
    val := ReadInteger(name);
end;

procedure TRegistryEx.ReadEx(name: string; var val: cardinal);
begin
  if ValueExists(name) then
    val := cardinal(ReadInteger(name));
end;

procedure TRegistryEx.ReadEx(name: string; var val: smallint);
begin
  if ValueExists(name) then
    val := smallint(ReadInteger(name));
end;

procedure TRegistryEx.ReadEx(name: string; var val: word);
begin
  if ValueExists(name) then
    val := word(ReadInteger(name));
end;

procedure TRegistryEx.ReadEx(name: string; var val: byte);
begin
  if ValueExists(name) then
    val := word(ReadInteger(name));
end;

procedure TRegistryEx.ReadEx(name: string; var val: TWindowState);
var
  aa: integer;
begin
  if ValueExists(name) then
  begin
    aa := ReadInteger(name);
    try
      val := TWindowState(aa);
    except

    end;
  end;
end;

procedure TRegistryEx.ReadEx(name: string; var val: boolean);
begin
  if ValueExists(name) then
    val := ReadBool(name);
end;

procedure TRegistryEx.ReadEx(name: string; var val: Double);
begin
  if ValueExists(name) then
    val := ReadFloat(name);
end;

procedure TRegistryEx.ReadEx(name: string; var val: String);
begin
  if ValueExists(name) then
    val := ReadString(name);
end;

procedure TRegistryEx.ReadEx(name: string; var val: Uint64);
var
  f: Double;
begin
  if ValueExists(name) then
  begin
    f := ReadFloat(name);
    val := trunc(f);
  end;

end;

procedure TRegistryEx.ReadEx(name: string; var val: TGuid);
var
  s: string;
begin
  if ValueExists(name) then
  begin
    s := ReadString(name);
    val.loadFromStr(s);
  end;
end;

procedure TRegistryEx.ReadEx(name: string; var val: TAuthKey);
var
  s: string;
begin
  if ValueExists(name) then
  begin
    s := ReadString(name);
    val.loadFromStr(s);
  end;
end;

procedure TRegistryEx.ReadEx(name: string; var val: TSuplaVal);
var
  s: string;
begin
  if ValueExists(name) then
  begin
    s := ReadString(name);
    val.loadFromStr(s);
  end;
end;

procedure TRegistryEx.WriteEx(name: string; val: integer);
begin
  WriteInteger(name, val);
end;

procedure TRegistryEx.WriteEx(name: string; val: TWindowState);
begin
  WriteInteger(name, ord(val));
end;

procedure TRegistryEx.WriteEx(name: string; val: cardinal);
begin
  WriteInteger(name, val);
end;

procedure TRegistryEx.WriteEx(name: string; val: boolean);
begin
  WriteBool(name, val);
end;

procedure TRegistryEx.WriteEx(name: string; val: Double);
begin
  WriteFloat(name, val);
end;

procedure TRegistryEx.WriteEx(name: string; const val: String);
begin
  WriteString(name, val);
end;

procedure TRegistryEx.WriteEx(name: string; const val: TGuid);
begin
  WriteString(name, val.getAsString);
end;

procedure TRegistryEx.WriteEx(name: string; const val: TAuthKey);
begin
  WriteString(name, val.getAsString);
end;

procedure TRegistryEx.WriteEx(name: string; const val: TSuplaVal);
begin
  WriteString(name, val.getAsString);
end;

// ----------------------------------------------------------
function H2(Ch: AnsiChar): string;
begin
  Result := IntToHex(ord(Ch), 2);
end;

procedure TGuid.Zero;
var
  i: integer;
begin
  for i := 0 to SUPLA_GUID_SIZE - 1 do
    dt[i] := #0;
end;

function TGuid.getAsString: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to SUPLA_GUID_SIZE - 1 do
  begin
    Result := Result + IntToHex(ord(dt[i]), 2);
  end;
end;

function TGuid.getAsHumanString: string;
begin
  Result := H2(dt[0]) + H2(dt[1]) + H2(dt[2]) + H2(dt[3]) + '-' + H2(dt[4]) + H2(dt[5]) + '-' + H2(dt[6]) + H2(dt[7]) +
    '-' + H2(dt[8]) + H2(dt[9]) + '-' + H2(dt[10]) + H2(dt[11]) + H2(dt[12]) + H2(dt[13]) + H2(dt[14]) + H2(dt[15]);
end;

function TGuid.loadFromStr(s: string): boolean;
var
  i: integer;
begin
  Result := false;
  if length(s) = 2 * SUPLA_GUID_SIZE then
  begin
    try
      for i := 0 to SUPLA_GUID_SIZE - 1 do
      begin
        dt[i] := AnsiChar(StrToInt('$' + Copy(s, 1 + 2 * i, 2)));
      end;
      Result := true;
    except
      Result := false;
    end;
  end;
end;

procedure TGuid.GenerNew;
var
  i: integer;
begin
  for i := 0 to SUPLA_GUID_SIZE - 1 do
  begin
    dt[i] := AnsiChar(byte(Random(256)));
  end;
end;

procedure TAuthKey.Zero;
var
  i: integer;
begin
  for i := 0 to SUPLA_AUTHKEY_SIZE - 1 do
    dt[i] := #0;
end;

procedure TAuthKey.GenerNew;
var
  i: integer;
begin
  for i := 0 to SUPLA_AUTHKEY_SIZE - 1 do
  begin
    dt[i] := AnsiChar(byte(Random(256)));
  end;
end;

function TAuthKey.getAsString: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to SUPLA_AUTHKEY_SIZE - 1 do
  begin
    Result := Result + IntToHex(ord(dt[i]), 2);
  end;
end;

function TAuthKey.getAsHumanString: string;
begin
  Result := H2(dt[0]) + H2(dt[1]) + H2(dt[2]) + H2(dt[3]) + '-' + H2(dt[4]) + H2(dt[5]) + '-' + H2(dt[6]) + H2(dt[7]) +
    '-' + H2(dt[8]) + H2(dt[9]) + '-' + H2(dt[10]) + H2(dt[11]) + H2(dt[12]) + H2(dt[13]) + H2(dt[14]) + H2(dt[15]);
end;

function TAuthKey.loadFromStr(s: string): boolean;
var
  i: integer;
begin
  Result := false;
  if length(s) = 2 * SUPLA_AUTHKEY_SIZE then
  begin
    try
      for i := 0 to SUPLA_AUTHKEY_SIZE - 1 do
      begin
        dt[i] := AnsiChar(StrToInt('$' + Copy(s, 1 + 2 * i, 2)));
      end;
      Result := true;
    except
      Result := false;
    end;
  end;
end;

procedure TChannelCfg.copyFrom(src: TChannelCfg);
begin
  ChannelType := src.ChannelType;
  FuncList := src.FuncList;
  Default := src.Default;
  CurrValue := src.CurrValue;
  ChannelFun := src.ChannelFun;

end;

procedure TElekMeterEx.SaveToReg(reg: TRegistryEx);
var
  i: integer;
  idx: integer;
  suf: string;
  key: string;
begin
  for i := 0 to 2 do
  begin
    suf := '_' + INtToStr(i + 1);
    reg.WriteFloat('TFAE' + suf, EM.total_forward_active_energy[i]);
    reg.WriteFloat('TRAE' + suf, EM.total_reverse_active_energy[i]);
    reg.WriteFloat('TFRE' + suf, EM.total_forward_reactive_energy[i]);
    reg.WriteFloat('TRRE' + suf, EM.total_reverse_reactive_energy[i]);
  end;
  reg.WriteInteger('TotalCost', EM.total_cost);
  reg.WriteInteger('PricePerUnit', EM.price_per_unit);
  reg.WriteString('Currency', EM.currency.getAsString);
  reg.WriteInteger('MeasuredValue', EM.measured_values);
  reg.WriteInteger('Period', EM.period);
  reg.WriteInteger('M_COUNT', EM.m_count);
  for idx := 0 to EM.m_count do
  begin
    key := '\' + reg.CurrentPath + '\MEAS_' + INtToStr(idx);
    if reg.OpenKey(key, true) then
    begin
      reg.WriteInteger('Freq', EM.m[idx].freq);
      for i := 0 to 2 do
      begin
        suf := '_' + INtToStr(i + 1);
        reg.WriteEx('Voltage' + suf, EM.m[idx].voltage[i]);
        reg.WriteEx('Current' + suf, EM.m[idx].current[i]);
        reg.WriteEx('PowerActive' + suf, EM.m[idx].power_active[i]);
        reg.WriteEx('PowerReactive' + suf, EM.m[idx].power_reactive[i]);
        reg.WriteEx('PowerApparent' + suf, EM.m[idx].power_apparent[i]);
        reg.WriteEx('PowerFactor' + suf, EM.m[idx].power_factor[i]);
        reg.WriteEx('PhaseAngle' + suf, EM.m[idx].phase_angle[i]);
      end;
      reg.OpenKey('..', false);
    end;
  end;
end;

procedure TElekMeterEx.LoadFromReg(reg: TRegistryEx);
var
  i: integer;
  idx: integer;
  suf: string;
  ss: string;
  key: string;
begin
  for i := 0 to 2 do
  begin
    suf := '_' + INtToStr(i + 1);
    reg.ReadEx('TFAE' + suf, EM.total_forward_active_energy[i]);
    reg.ReadEx('TRAE' + suf, EM.total_reverse_active_energy[i]);
    reg.ReadEx('TFRE' + suf, EM.total_forward_reactive_energy[i]);
    reg.ReadEx('TRRE' + suf, EM.total_reverse_reactive_energy[i]);
  end;
  reg.ReadEx('TotalCost', EM.total_cost);
  reg.ReadEx('PricePerUnit', EM.price_per_unit);

  reg.ReadEx('Currency', ss);
  EM.currency.LoadFromString(ss);

  reg.ReadEx('MeasuredValue', EM.measured_values);
  reg.ReadEx('Period', EM.period);

  reg.ReadEx('M_COUNT', EM.m_count);
  for idx := 0 to EM.m_count do
  begin
    key := '\' + reg.CurrentPath + '\MEAS_' + INtToStr(idx);
    if reg.OpenKey(key, false) then
    begin
      reg.ReadEx('Freq', EM.m[idx].freq);
      for i := 0 to 2 do
      begin
        suf := '_' + INtToStr(i + 1);
        reg.ReadEx('Voltage' + suf, EM.m[idx].voltage[i]);
        reg.ReadEx('Current' + suf, EM.m[idx].current[i]);
        reg.ReadEx('PowerActive' + suf, EM.m[idx].power_active[i]);
        reg.ReadEx('PowerReactive' + suf, EM.m[idx].power_reactive[i]);
        reg.ReadEx('PowerApparent' + suf, EM.m[idx].power_apparent[i]);
        reg.ReadEx('PowerFactor' + suf, EM.m[idx].power_factor[i]);
        reg.ReadEx('PhaseAngle' + suf, EM.m[idx].phase_angle[i]);
      end;
      reg.OpenKey('..', false);
    end;
  end;
end;

procedure TImpulCounterEx.SaveToReg(reg: TRegistryEx);
begin
  reg.WriteEx('total_cost', dt.total_cost);
  reg.WriteEx('price_per_unit', dt.price_per_unit);
  reg.WriteEx('currency', dt.currency.getAsString);
  reg.WriteEx('custom_unit', dt.custom_unit.getAsString);
  reg.WriteEx('impulses_per_unit', dt.impulses_per_unit);
  reg.WriteEx('counter', dt.counter);
  reg.WriteEx('calculated_value', dt.calculated_value);
end;

procedure TImpulCounterEx.LoadFromReg(reg: TRegistryEx);
var
  ss: string;
begin
  reg.ReadEx('total_cost', dt.total_cost);
  reg.ReadEx('price_per_unit', dt.price_per_unit);
  reg.ReadEx('currency', ss);
  dt.currency.LoadFromString(ss);
  reg.ReadEx('custom_unit', ss);
  dt.custom_unit.LoadFromString(ss);
  reg.ReadEx('impulses_per_unit', dt.impulses_per_unit);
  reg.ReadEx('counter', dt.counter);
  reg.ReadEx('calculated_value', dt.calculated_value);
end;

procedure TThermostatEx.SaveToReg(reg: TRegistryEx);
var
  i, j: integer;
begin
  reg.WriteEx('isON', IsOn);
  reg.WriteEx('Fields', dt.Fields);
  for i := 0 to 9 do
  begin
    reg.WriteEx(Format('Temp_%u', [i + 1]), dt.MeasuredTemperature[i]);
    reg.WriteEx(Format('Preset_%u', [i + 1]), dt.PresetTemperature[i]);
  end;

  for i := 0 to 7 do
  begin
    reg.WriteEx(Format('Flags_%u', [i + 1]), dt.flags[i]);
    reg.WriteEx(Format('Values_%u', [i + 1]), dt.Values[i]);
  end;

  reg.WriteEx('Tm_sec', dt.Time.sec);
  reg.WriteEx('Tm_min', dt.Time.min);
  reg.WriteEx('Tm_hour', dt.Time.hour);
  reg.WriteEx('Tm_dayOfWeek', dt.Time.dayOfWeek);

  reg.WriteEx('She_ValueType', dt.Schedule.ValueType);

  for i := 0 to 6 do
  begin
    for j := 0 to 23 do
    begin
      reg.WriteEx(Format('She_%u_%u', [i + 1, j + 1]), dt.Schedule.HourValue[i][j]);
    end;
  end;
end;

procedure TThermostatEx.LoadFromReg(reg: TRegistryEx);
var
  i, j: integer;
  b: byte;
begin
  reg.ReadEx('isON', IsOn);
  reg.ReadEx('Fields', dt.Fields);
  for i := 0 to 9 do
  begin
    reg.ReadEx(Format('Temp_%u', [i + 1]), dt.MeasuredTemperature[i]);
    reg.ReadEx(Format('Preset_%u', [i + 1]), dt.PresetTemperature[i]);
  end;

  for i := 0 to 7 do
  begin
    reg.ReadEx(Format('Flags_%u', [i + 1]), dt.flags[i]);
    reg.ReadEx(Format('Values_%u', [i + 1]), dt.Values[i]);
  end;

  reg.ReadEx('Tm_sec', dt.Time.sec);
  reg.ReadEx('Tm_min', dt.Time.min);
  reg.ReadEx('Tm_hour', dt.Time.hour);
  reg.ReadEx('Tm_dayOfWeek', dt.Time.dayOfWeek);

  reg.ReadEx('She_ValueType', dt.Schedule.ValueType);

  for i := 0 to 6 do
  begin
    for j := 0 to 23 do
    begin
      reg.ReadEx(Format('She_%u_%u', [i + 1, j + 1]), dt.Schedule.HourValue[i][j]);
      b := dt.Schedule.HourValue[i][j];
      if (b <> THERMOSTATE_PROG_ECO) and (b <> THERMOSTATE_PROG_COMFORT) then
        dt.Schedule.HourValue[i][j] := THERMOSTATE_PROG_ECO;
    end;
  end;
end;

// -------------------------------------------------------------------------
procedure TChannelCfg.SaveToReg(reg: TRegistryEx);
var
  key: string;
begin
  reg.WriteInteger('TypeCh', ChannelType);
  reg.WriteInteger('FuncList', FuncList);
  reg.WriteInteger('Default', Default);
  reg.WriteString('CurrValue', CurrValue.getAsString);
  reg.WriteInteger('ChannelFun', ChannelFun);
  if ChannelType = SUPLA_CHANNELTYPE_ELECTRICITY_METER then
  begin
    key := '\' + reg.CurrentPath + '\EN_METER';
    if reg.OpenKey(key, true) then
    begin
      EM.SaveToReg(reg);
      reg.OpenKey('..', false);
    end;
  end
  else if ChannelType = SUPLA_CHANNELTYPE_IMPULSE_COUNTER then
  begin
    key := '\' + reg.CurrentPath + '\IMP_METER';
    if reg.OpenKey(key, true) then
    begin
      IMP.SaveToReg(reg);
      reg.OpenKey('..', false);
    end;
  end
  else if (ChannelType = SUPLA_CHANNELTYPE_THERMOSTAT) or (ChannelType = SUPLA_CHANNELTYPE_THERMOSTAT_HEATPOL_HOMEPLUS)
  then
  begin
    key := '\' + reg.CurrentPath + '\THERMOSAT';
    if reg.OpenKey(key, true) then
    begin
      TH.SaveToReg(reg);
      reg.OpenKey('..', false);
    end;
  end

end;

procedure TChannelCfg.LoadFromReg(reg: TRegistryEx);
var
  key: string;
begin
  reg.ReadEx('TypeCh', ChannelType);
  reg.ReadEx('FuncList', FuncList);
  reg.ReadEx('Default', Default);
  reg.ReadEx('CurrValue', CurrValue);
  reg.ReadEx('ChannelFun', ChannelFun);

  if ChannelType = SUPLA_CHANNELTYPE_ELECTRICITY_METER then
  begin
    key := '\' + reg.CurrentPath + '\EN_METER';
    if reg.OpenKey(key, true) then
    begin
      EM.LoadFromReg(reg);
      reg.OpenKey('..', false);
    end;
  end
  else if ChannelType = SUPLA_CHANNELTYPE_IMPULSE_COUNTER then
  begin
    key := '\' + reg.CurrentPath + '\IMP_METER';
    if reg.OpenKey(key, true) then
    begin
      IMP.LoadFromReg(reg);
      reg.OpenKey('..', false);
    end;
  end
  else if (ChannelType = SUPLA_CHANNELTYPE_THERMOSTAT) or (ChannelType = SUPLA_CHANNELTYPE_THERMOSTAT_HEATPOL_HOMEPLUS)
  then
  begin
    key := '\' + reg.CurrentPath + '\THERMOSAT';
    if reg.OpenKey(key, true) then
    begin
      TH.LoadFromReg(reg);
      reg.OpenKey('..', false);
    end;
  end

end;

function TChannelList.FGetItem(Index: integer): TChannelCfg;
begin
  Result := inherited GetItem(Index) as TChannelCfg;
end;

procedure TChannelList.SaveToReg(reg: TRegistryEx);
var
  i: integer;
  key0: string;
  key: string;
begin
  key0 := reg.CurrentPath;
  for i := 0 to count - 1 do
  begin
    key := Format('\%s\CHANNEL_%u', [key0, i]);
    if reg.OpenKey(key, true) then
      Items[i].SaveToReg(reg);
  end;
  reg.OpenKey('..', false);
end;

procedure TChannelList.LoadFromReg(reg: TRegistryEx);
var
  i: integer;
  key0: string;
  key: string;
  Channel: TChannelCfg;
begin
  key0 := reg.CurrentPath;
  i := 0;
  while true do
  begin
    key := Format('\%s\CHANNEL_%u', [key0, i]);
    if reg.OpenKey(key, false) then
    begin
      Channel := TChannelCfg.Create;
      Channel.LoadFromReg(reg);
      Add(Channel);
    end
    else
      break;
    inc(i);
  end;
  reg.OpenKey('..', false);
end;

function TChannelList.isFirst(cfg: TChannelCfg): boolean;
begin
  if count > 0 then
    Result := (cfg = Items[0])
  else
    Result := false;
end;

function TChannelList.isLast(cfg: TChannelCfg): boolean;
begin
  if count > 0 then
    Result := (cfg = Items[count - 1])
  else
    Result := false;
end;

procedure TChannelList.MoveUp(cfg: TChannelCfg);
var
  n: integer;
begin
  n := IndexOf(cfg);
  if n >= 1 then
    Exchange(n - 1, n);
end;

procedure TChannelList.MoveDn(cfg: TChannelCfg);
var
  n: integer;
begin
  n := IndexOf(cfg);
  if n < count - 1 then
    Exchange(n, n + 1);
end;

constructor TSuplaDevCfg.Create;
begin
  inherited;
  Channels := TChannelList.Create;
  Guid.Zero;
  AuthKey.Zero;
  Name := '';
  SoftVer := '1.1.1';
  useSSL := true;
  autoReconnect := true;
  Registered := false;
  M_Winstate := wsNormal;
end;

destructor TSuplaDevCfg.Destroy;
begin
  inherited;
  Channels.Free;
end;

procedure TSuplaDevCfg.deleteChannel(Ch: TChannelCfg);
var
  idx: integer;
begin
  idx := Channels.IndexOf(Ch);
  if idx >= 0 then
    Channels.Delete(idx);
end;

procedure TSuplaDevCfg.SaveToReg(reg: TRegistryEx);
var
  memWinS: TWindowState;
begin
  if Assigned(Form) then
  begin
    M_Winstate := Form.WindowState;
    memWinS := Form.WindowState;
    Form.WindowState := wsNormal;
    M_Left := Form.Left;
    M_Top := Form.Top;
    M_Width := Form.Width;
    M_Height := Form.Height;
    MemoHeight := (Form as TSuplaDevForm).Memo1.Height;
    Form.WindowState := memWinS;
  end;

  reg.WriteEx('Guid', Guid.getAsString);
  reg.WriteEx('AuthKey', AuthKey.getAsString);
  reg.WriteEx('Name', Name);
  reg.WriteEx('SoftVer', SoftVer);
  reg.WriteEx('useSSL', useSSL);
  reg.WriteEx('autoReconnect', autoReconnect);
  reg.WriteEx('Registered', Registered);

  reg.WriteEx('Winstate', M_Winstate);
  reg.WriteEx('Top', M_Top);
  reg.WriteEx('Left', M_Left);
  reg.WriteEx('Width', M_Width);
  reg.WriteEx('Height', M_Height);
  reg.WriteEx('MemoHeight', MemoHeight);

  Channels.SaveToReg(reg);
end;

procedure TSuplaDevCfg.LoadFromReg(reg: TRegistryEx);
begin
  reg.ReadEx('Guid', Guid);
  reg.ReadEx('AuthKey', AuthKey);
  reg.ReadEx('Name', Name);
  reg.ReadEx('SoftVer', SoftVer);
  reg.ReadEx('useSSL', useSSL);
  reg.ReadEx('autoReconnect', autoReconnect);
  reg.ReadEx('Registered', Registered);

  reg.ReadEx('Winstate', M_Winstate);
  reg.ReadEx('Top', M_Top);
  reg.ReadEx('Left', M_Left);
  reg.ReadEx('Width', M_Width);
  reg.ReadEx('Height', M_Height);
  reg.ReadEx('MemoHeight', MemoHeight);

  Channels.LoadFromReg(reg);
end;

function TSuplaDevCfgList.FGetItem(Index: integer): TSuplaDevCfg;
begin
  Result := inherited GetItem(Index) as TSuplaDevCfg;
end;

procedure TSuplaDevCfgList.SaveToReg(reg: TRegistryEx);
var
  i: integer;
  key0: string;
  key: string;
begin
  key0 := reg.CurrentPath;
  for i := 0 to count - 1 do
  begin
    key := Format('\%s\DEVICE_%u', [key0, i]);
    if reg.OpenKey(key, true) then
      Items[i].SaveToReg(reg);
  end;
  reg.OpenKey('..', false);
end;

procedure TSuplaDevCfgList.LoadFromReg(reg: TRegistryEx);
var
  i: integer;
  key0: string;
  key: string;
  DevCfg: TSuplaDevCfg;
begin
  key0 := reg.CurrentPath;
  i := 0;
  while true do
  begin
    key := Format('\%s\DEVICE_%u', [key0, i]);
    if reg.OpenKey(key, false) then
    begin
      DevCfg := TSuplaDevCfg.Create;
      DevCfg.LoadFromReg(reg);
      Add(DevCfg);
    end
    else
      break;
    inc(i);
  end;
  reg.OpenKey('..', false);
end;

constructor TProgCfg.Create;
begin
  inherited;
  DevCfgList := TSuplaDevCfgList.Create;
  ServerName := '';
  Email := '';
end;

destructor TProgCfg.Destroy;
begin
  inherited;
  DevCfgList.Free;
end;

procedure TProgCfg.SaveToReg;
var
  reg: TRegistryEx;
  SL: TStringList;
  i: integer;
begin
  reg := TRegistryEx.Create;
  try
    if reg.OpenKey(REG_KEY, true) then
    begin
      SL := TStringList.Create;
      try
        reg.GetKeyNames(SL);
        for i := 0 to SL.count - 1 do
          reg.DeleteKey(SL.Strings[i]);
      finally
        SL.Free;
      end;

      reg.WriteEx('WinState', integer(ord(Application.MainForm.WindowState)));
      if Application.MainForm.WindowState = wsNormal then
      begin
        reg.WriteInteger('Top', Application.MainForm.Top);
        reg.WriteInteger('Left', Application.MainForm.Left);
        reg.WriteInteger('Width', Application.MainForm.Width);
        reg.WriteInteger('Height', Application.MainForm.Height);
      end;

      reg.WriteString('ServerName', ServerName);
      reg.WriteString('Email', Email);
      DevCfgList.SaveToReg(reg);
    end;
  finally
    reg.Free;
  end;
end;

procedure TProgCfg.LoadFromReg;
var
  reg: TRegistryEx;
  aa: integer;
begin
  reg := TRegistryEx.Create;
  try
    if reg.OpenKey(REG_KEY, false) then
    begin
      reg.ReadEx('Top', W_Top);
      reg.ReadEx('Left', W_Left);
      reg.ReadEx('Width', W_Width);
      reg.ReadEx('Height', W_Height);
      reg.ReadEx('WinState', aa);
      try
        W_WinState := TWindowState(aa);
      except

      end;
      reg.ReadEx('ServerName', ServerName);
      reg.ReadEx('Email', Email);
      reg.ReadEx('SpecUser',SpecUser);
      DevCfgList.LoadFromReg(reg);
    end;
  finally
    reg.Free;
  end;
end;

function TProgCfg.AddDevice: TSuplaDevCfg;
begin
  Result := TSuplaDevCfg.Create;
  Result.Guid.GenerNew;
  Result.AuthKey.GenerNew;
  DevCfgList.Add(Result);
end;

function TProgCfg.DelDevice(DevCfg: TSuplaDevCfg): boolean;
var
  idx: integer;
begin
  idx := DevCfgList.IndexOf(DevCfg);
  if idx >= 0 then
    DevCfgList.Delete(idx);
  Result := (idx >= 0);
end;

initialization

ProgCfg := TProgCfg.Create;

finalization

ProgCfg.Free;

end.
