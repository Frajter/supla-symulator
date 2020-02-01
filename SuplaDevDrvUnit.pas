unit SuplaDevDrvUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  IdGlobal, IdTCPClient, IdComponent, ExtCtrls,
  IdSSLOpenSSL,
  ProgCfgUnit,
  Supla_proto;

const
  wmBase = wm_User + 200;
  wmRecData = wmBase + 0;
  wmDisconnected = wmBase + 1;

type
  TBufObj = class(TObject)
    buf: TIdBytes;
  end;

  TRdThread = class(TThread)
  private
    ToDoEvent: THandle;
    FOwnerHandle: THandle;
    FTcpClient: TIdTCPClient;
  protected
    procedure Execute; override;
  public
    myConnected: boolean;
    constructor Create(aOwnerHandle: THandle; aTcpClient: TIdTCPClient);
    destructor Destroy; override;
  end;

  TSuplaDevDrv = class;
  TOnDataRecive = procedure(Sender: TSuplaDevDrv; BufObj: TBufObj) of object;
  TStatusEvent = procedure(Sender: TObject; const AStatusText: string) of object;
  TOnChannelValue = procedure(Sender: TObject; NewVal: TSD_SuplaChannelNewValue) of object;
  TOnCalCfg = procedure(Sender: TObject; CalCfg: TSD_DeviceCalCfgRequest) of object;

  TSuplaDevDrv = class(TObject)
  private
    RdThread: TRdThread;
    TCPClient: TIdTCPClient;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    FDevHandle: THandle;
    FOnDataRecive: TOnDataRecive;
    FOnStatusEvent: TStatusEvent;
    FOnSuplaRegistred: TNotifyEvent;
    FOnDisconnected: TNotifyEvent;
    FOnNewChannelValue: TOnChannelValue;
    FOnCalCfg: TOnCalCfg;
    FOnWdgTimer: TNotifyEvent;
    spd: TSuplaProtoData;
    mActivityTimeOut: integer;
    mWdgTimer: TTimer;

    procedure wrMsg(msg: string);
    procedure wm_RecData(var Message: TMessage); message wmRecData;
    procedure wm_Disconnected(var Message: TMessage); message wmDisconnected;

    procedure WndProc(var AMessage: TMessage);
    procedure IdTCPClient1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure IdTCPClientDisconected(ASender: TObject);
    procedure OnWdgTimerProc(Sender: TObject);

    procedure SendData(call_type: integer; var dt; sz: integer);
    procedure UnpackRecivedData(inp: TIdBytes; var recDataTab: TSrpcReceivedDataTab);

    procedure doRecivedObj(recdata: TSrpcReceivedData);
    procedure supla_esp_on_register_result(dt: TIdBytes);
    procedure supla_esp_channel_set_value(dt: TIdBytes);
    procedure supla_esp_board_calcfg_request(dt: TIdBytes);

  public
    constructor Create;
    destructor Destroy; override;
    property OnDataRecive: TOnDataRecive read FOnDataRecive write FOnDataRecive;
    property OnStatusEvent: TStatusEvent read FOnStatusEvent write FOnStatusEvent;
    property OnSuplaRegistred: TNotifyEvent read FOnSuplaRegistred write FOnSuplaRegistred;
    property OnNewChannelValue: TOnChannelValue read FOnNewChannelValue write FOnNewChannelValue;
    property OnCalCfg: TOnCalCfg read FOnCalCfg write FOnCalCfg;

    property OnDisconnected: TNotifyEvent read FOnDisconnected write FOnDisconnected;
    property ActivityTimeOut: integer read mActivityTimeOut;
    property OnWdgTimer: TNotifyEvent read FOnWdgTimer write FOnWdgTimer;

    procedure Open(addr: string; DevCfg: TSuplaDevCfg);
    procedure Close;
    procedure RegisterDev(DevCfg: TSuplaDevCfg);
    function Connected: boolean;
    procedure SendChannelValue(ToSendDt: TDS_SuplaDeviceChannelValue); overload;
    procedure SendChannelValue(ToSendDt: TDS_SuplaDeviceChannelExtendedValue); overload;
    procedure SendChannelsValue(ToSendDt: TDS_SuplaDeviceChannelValueTab);

  end;

implementation

constructor TRdThread.Create(aOwnerHandle: THandle; aTcpClient: TIdTCPClient);
begin
  inherited Create;
  ToDoEvent := CreateEvent(nil, true, false, nil);
  FOwnerHandle := aOwnerHandle;
  FTcpClient := aTcpClient;
  myConnected := false;
end;

destructor TRdThread.Destroy;
begin
  SetEvent(ToDoEvent);
  inherited;
  CloseHandle(ToDoEvent);
end;

procedure TRdThread.Execute;
var
  BufObj: TBufObj;
begin
  BufObj := nil;
  while not terminated do
  begin
    if myConnected then
    begin
      if BufObj = nil then
        BufObj := TBufObj.Create;
      try
        FTcpClient.Socket.ReadBytes(BufObj.buf, -1);
      except
        setlength(BufObj.buf, 0);
        myConnected := false;
        PostMessage(FOwnerHandle, wmDisconnected, integer(BufObj), 0);
        BufObj.free;
        BufObj := nil;
      end;
      if Assigned(BufObj) and (length(BufObj.buf) > 0) then
      begin
        PostMessage(FOwnerHandle, wmRecData, integer(BufObj), 0);
        BufObj := nil;
      end;
    end
    else
    begin
      WaitForSingleObject(ToDoEvent, 100);
      ResetEvent(ToDoEvent);
    end;
  end;
end;

constructor TSuplaDevDrv.Create;
begin
  inherited;
{$WARN SYMBOL_DEPRECATED OFF}
  FDevHandle := AllocateHWnd(WndProc);
{$WARN SYMBOL_DEPRECATED ON}
  TCPClient := TIdTCPClient.Create(nil);
  TCPClient.Port := 2015;
  TCPClient.ReadTimeout := 200;
  TCPClient.OnStatus := IdTCPClient1Status;
  TCPClient.OnDisconnected := IdTCPClientDisconected;

  IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSSLIOHandlerSocketOpenSSL1.Open;

  RdThread := TRdThread.Create(FDevHandle, TCPClient);
  FOnDataRecive := nil;
  mWdgTimer := TTimer.Create(nil);
  mWdgTimer.Enabled := false;
  mWdgTimer.OnTimer := OnWdgTimerProc;

  spd.init;
end;

destructor TSuplaDevDrv.Destroy;
begin
  RdThread.Terminate;
  if Assigned(TCPClient.Socket) and TCPClient.Socket.Connected then
    TCPClient.Disconnect;
  RdThread.free;
  TCPClient.free;
  IdSSLIOHandlerSocketOpenSSL1.free;
{$WARN SYMBOL_DEPRECATED OFF}
  DeallocateHWnd(FDevHandle);
{$WARN SYMBOL_DEPRECATED ON}
end;

procedure TSuplaDevDrv.IdTCPClient1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  if Assigned(FOnStatusEvent) then
    FOnStatusEvent(self, AStatusText);
end;

procedure TSuplaDevDrv.IdTCPClientDisconected(ASender: TObject);
begin
  RdThread.myConnected := false;
  if Assigned(FOnDisconnected) then
    FOnDisconnected(self);
end;

procedure TSuplaDevDrv.OnWdgTimerProc(Sender: TObject);
begin
  if Assigned(FOnWdgTimer) then
    FOnWdgTimer(self);
end;

procedure TSuplaDevDrv.WndProc(var AMessage: TMessage);
begin
  Dispatch(AMessage);
end;

procedure TSuplaDevDrv.Open(addr: string; DevCfg: TSuplaDevCfg);
begin
  TCPClient.Host := addr;
  if DevCfg.useSSL = false then
  begin
    TCPClient.Port := 2015;
    TCPClient.IOHandler := nil;
  end
  else
  begin
    TCPClient.Port := 2016;
    TCPClient.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  end;
  TCPClient.Connect;
  RdThread.myConnected := true;

  RegisterDev(DevCfg);
end;

procedure TSuplaDevDrv.Close;
begin
  mWdgTimer.Enabled := false;
  TCPClient.Disconnect;
  if Assigned(TCPClient.IOHandler) then
    if Assigned(TCPClient.IOHandler.InputBuffer) then
      TCPClient.IOHandler.InputBuffer.Clear;
  RdThread.myConnected := false;
end;

function TSuplaDevDrv.Connected: boolean;
begin
  Result := RdThread.myConnected;
end;

procedure TSuplaDevDrv.SendChannelValue(ToSendDt: TDS_SuplaDeviceChannelValue);
begin
  SendData(SUPLA_DS_CALL_DEVICE_CHANNEL_VALUE_CHANGED, ToSendDt, sizeof(ToSendDt));
end;

procedure TSuplaDevDrv.SendChannelsValue(ToSendDt: TDS_SuplaDeviceChannelValueTab);
var
  i, n: integer;
begin
  n := length(ToSendDt);
  for i := 0 to n - 1 do
  begin
    SendData(SUPLA_DS_CALL_DEVICE_CHANNEL_VALUE_CHANGED, ToSendDt, sizeof(ToSendDt));
  end;
end;

procedure TSuplaDevDrv.SendChannelValue(ToSendDt: TDS_SuplaDeviceChannelExtendedValue);
var
  sz: integer;
begin
  sz := sizeof(TDS_SuplaDeviceChannelExtendedValue) - (SUPLA_CHANNELEXTENDEDVALUE_SIZE - ToSendDt.value.size);
  SendData(SUPLA_DS_CALL_DEVICE_CHANNEL_EXTENDEDVALUE_CHANGED, ToSendDt, sz);
end;

procedure TSuplaDevDrv.RegisterDev(DevCfg: TSuplaDevCfg);
var
  regDev: TDS_SuplaRegisterDevice_D;
  size: integer;
  nrCh: integer;
  i: integer;
  Channel: TChannelCfg;
begin

  regDev.init(ProgCfg.Email, ProgCfg.ServerName, DevCfg.Name, DevCfg.SoftVer);
  regDev.GUID := DevCfg.GUID.dt;
  regDev.AuthKey := DevCfg.AuthKey.dt;

  for i := 0 to DevCfg.Channels.Count - 1 do
  begin
    Channel := DevCfg.Channels.Items[i];
    nrCh := regDev.AddChn(Channel.ChannelType, Channel.FuncList, Channel.Default);
    regDev.Channels[nrCh].value := Channel.CurrValue;
  end;

  size := sizeof(TDS_SuplaRegisterDevice_D) - SUPLA_CHANNELMAXCOUNT * sizeof(TDS_SuplaDeviceChannel_B) +
    regDev.channel_count * sizeof(TDS_SuplaDeviceChannel_B);

  SendData(SUPLA_DS_CALL_REGISTER_DEVICE_D, regDev, size);
end;

procedure TSuplaDevDrv.SendData(call_type: integer; var dt; sz: integer);
var
  ABuffer: TIdBytes;
  SuplaDt: TSuplaDataPacket;
  sz3: integer;
begin
  sz3 := SuplaDt.setData(call_type, dt, sz);
  spd.IncRRId;
  SuplaDt.rr_id := spd.next_rr_id;
  SuplaDt.version := spd.version;

  setlength(ABuffer, sz3 + 5);
  move(SuplaDt, ABuffer[0], sz3);
  move(sproto_tag, ABuffer[sz3], SUPLA_TAG_SIZE);

  TCPClient.Socket.Write(ABuffer);
end;

procedure TSuplaDevDrv.UnpackRecivedData(inp: TIdBytes; var recDataTab: TSrpcReceivedDataTab);
var
  SuplaDt: TSuplaDataPacket;
  sz: integer;
  recdata: TSrpcReceivedData;
  n: integer;
begin
  sz := length(inp);
  if sz <= sizeof(SuplaDt) then
  begin
    move(inp[0], SuplaDt, sz);
    if CheckSuplaTag(SuplaDt.tag) then
    begin
      recdata.call_type := SuplaDt.call_type;
      recdata.rr_id := SuplaDt.rr_id;
      if SuplaDt.data_size < SUPLA_MAX_DATA_SIZE then
      begin
        setlength(recdata.data, SuplaDt.data_size);
        move(SuplaDt.data, recdata.data[0], SuplaDt.data_size);
        if CheckSuplaTag(inp[sz - 5]) then
        begin
          n := length(recDataTab);
          setlength(recDataTab, n + 1);
          recDataTab[n] := recdata;
        end;

      end;
    end;
  end
end;

procedure TSuplaDevDrv.wrMsg(msg: string);
begin
  if Assigned(FOnStatusEvent) then
    FOnStatusEvent(self, msg);
end;

procedure TSuplaDevDrv.supla_esp_channel_set_value(dt: TIdBytes);
var
  NewVal: TSD_SuplaChannelNewValue;
begin
  move(dt[0], NewVal, sizeof(NewVal));
  wrMsg(Format('SetVal, Snd=%d ChNr=%d Dur=%d Val=%s', [NewVal.SenderID, NewVal.ChannelNumber, NewVal.DurationMS,
    NewVal.value.getAsString]));
  if Assigned(FOnNewChannelValue) then
    FOnNewChannelValue(self, NewVal);
end;

procedure TSuplaDevDrv.supla_esp_board_calcfg_request(dt: TIdBytes);
var
  CalCfg: TSD_DeviceCalCfgRequest;
  n, k: integer;
  ss: string;
  txt: string;
begin
  n := length(dt);
  if (n >= sizeof(CalCfg) - sizeof(CalCfg.data)) and (n <= sizeof(CalCfg)) then
  begin
    move(dt[0], CalCfg, n);
    if Assigned(FOnCalCfg) then
      FOnCalCfg(self, CalCfg);

    // pokazanie w MEMO

    txt := Format('CalCfgRequest, Snd=%d ChNr=%d Cmd=%d SU=%d DtType=%d DtSize=%d ',
      [CalCfg.SenderID, CalCfg.ChannelNumber, CalCfg.Command, CalCfg.SuperUserAuthorized, CalCfg.DataType,
      CalCfg.DataSize]);
    if CalCfg.DataSize > 0 then
    begin
      k := CalCfg.DataSize;
      if k > 110 then
        k := 110;

      ss := makeHexStr(CalCfg.data, k);
      txt := txt + 'DT= ' + ss;

    end;
    wrMsg(txt);

  end;
end;

procedure TSuplaDevDrv.supla_esp_on_register_result(dt: TIdBytes);
var
  RegResult: TSD_SuplaRegisterDeviceResult;
  tm: integer;
begin
  move(dt[0], RegResult, sizeof(RegResult));
  case RegResult.result_code of

    SUPLA_RESULTCODE_BAD_CREDENTIALS:
      wrMsg('Register: Bad credentials!');
    SUPLA_RESULTCODE_TEMPORARILY_UNAVAILABLE:
      wrMsg('Register: Temporarily unavailable!');

    SUPLA_RESULTCODE_LOCATION_CONFLICT:
      wrMsg('Register: Location conflict!');

    SUPLA_RESULTCODE_CHANNEL_CONFLICT:
      wrMsg('Register: Channel conflict!');

    SUPLA_RESULTCODE_REGISTRATION_DISABLED:
      wrMsg('Register: Registration disabled!');

    SUPLA_RESULTCODE_AUTHKEY_ERROR:
      wrMsg('Register: Incorrect device AuthKey!');
    SUPLA_RESULTCODE_NO_LOCATION_AVAILABLE:
      wrMsg('Register: No location available!');

    SUPLA_RESULTCODE_USER_CONFLICT:
      wrMsg('Register: User conflict!');

    SUPLA_RESULTCODE_TRUE:
      begin
        wrMsg('Register OK');
        mActivityTimeOut := RegResult.activity_timeout;
        tm := mActivityTimeOut;
        if tm > 10 then
          tm := tm - 5;
        mWdgTimer.Interval := 1000 * tm;
        mWdgTimer.Enabled := true;
        if Assigned(FOnSuplaRegistred) then
          FOnSuplaRegistred(self);

        (*
          supla_esp_gpio_state_connected();

          devconn->server_activity_timeout = register_device_result->activity_timeout;
          devconn->registered = 1;

          supla_esp_set_state(LOG_DEBUG, "Registered and ready.");
          supla_log(LOG_DEBUG, "Free heap size: %i", system_get_free_heap_size());

          if ( devconn->server_activity_timeout != ACTIVITY_TIMEOUT ) {

          TDCS_SuplaSetActivityTimeout at;
          at.activity_timeout = ACTIVITY_TIMEOUT;
          srpc_dcs_async_set_activity_timeout(devconn->srpc, &at);

          }

          #ifdef __FOTA
          supla_esp_check_updates(devconn->srpc);
          #endif

          supla_esp_devconn_send_channel_values_with_delay();

          #ifdef ELECTRICITY_METER_COUNT
          supla_esp_em_device_registered();
          #endif

          #ifdef IMPULSE_COUNTER_COUNT
          supla_esp_ic_device_registered();
          #endif

          #ifdef BOARD_ON_DEVICE_REGISTERED
          BOARD_ON_DEVICE_REGISTERED;
          #endif

          return;
        *)
      end;
    SUPLA_RESULTCODE_DEVICE_DISABLED:
      wrMsg('Register: Device is disabled!');

    SUPLA_RESULTCODE_LOCATION_DISABLED:
      wrMsg('Register: Location is disabled!');

    SUPLA_RESULTCODE_DEVICE_LIMITEXCEEDED:
      wrMsg('Register: Device limit exceeded!');

    SUPLA_RESULTCODE_GUID_ERROR:
      wrMsg('Register: Incorrect device GUID!');
  else
    wrMsg(Format('Register: Status=%u', [RegResult.result_code]));

  end;

end;

procedure TSuplaDevDrv.doRecivedObj(recdata: TSrpcReceivedData);
begin
  case recdata.call_type of
    SUPLA_SDC_CALL_VERSIONERROR:
      begin
        wrMsg('CALL_VERSIONERROR');

      end;
    SUPLA_SD_CALL_REGISTER_DEVICE_RESULT:
      begin
        supla_esp_on_register_result(recdata.data);
      end;
    SUPLA_SD_CALL_CHANNEL_SET_VALUE:
      begin
        supla_esp_channel_set_value(recdata.data);
      end;
    SUPLA_SDC_CALL_SET_ACTIVITY_TIMEOUT_RESULT:
      begin
        wrMsg('SET_ACTIVITY_TIMEOUT_RESULT');
      end;
    SUPLA_SD_CALL_DEVICE_CALCFG_REQUEST:
      begin
        supla_esp_board_calcfg_request(recdata.data);
      end;

    // SUPLA_DS_CALL_DEVICE_CHANNEL_EXTENDEDVALUE_CHANGED
  else
    begin
      wrMsg(Format('call_type=%u', [recdata.call_type]));
    end;
  end;
end;

procedure TSuplaDevDrv.wm_Disconnected(var Message: TMessage);
begin
  if Assigned(FOnDisconnected) then
    FOnDisconnected(self);
end;

procedure TSuplaDevDrv.wm_RecData(var Message: TMessage);
var
  BufObj: TBufObj;
  recDataTab: TSrpcReceivedDataTab;
  i: integer;
begin
  BufObj := TBufObj(Message.WParam);
  if Assigned(FOnDataRecive) then
    FOnDataRecive(self, BufObj);

  UnpackRecivedData(BufObj.buf, recDataTab);
  for i := 0 to length(recDataTab) - 1 do
  begin
    doRecivedObj(recDataTab[i]);

  end;

  BufObj.free;
end;

end.
