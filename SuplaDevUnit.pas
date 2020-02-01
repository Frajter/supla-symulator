unit SuplaDevUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList, Contnrs,
  Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.ToolWin, Vcl.ExtCtrls, Vcl.StdCtrls,
  SuplaDevDrvUnit, Supla_proto, ProgCfgUnit, NewChannelDialog,
  BaseFrameUnit, Vcl.Menus;

type
  TPanelInfo = class(TObject)
    Panel: TPanel;
    Frame: TBaseFrame;
  end;

  TFrameList = class(TObjectList)
  private
    function FGetItem(Index: integer): TPanelInfo;
  public
    property Items[Index: integer]: TPanelInfo read FGetItem;
  end;

  TSuplaDevForm = class(TForm)
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ImageList1: TImageList;
    ScrollBox: TScrollBox;
    ConnectBtn: TToolButton;
    InfoBtn: TToolButton;
    CfgBtn: TToolButton;
    Memo1: TMemo;
    Splitter1: TSplitter;
    actOpenClose: TAction;
    actInformation: TAction;
    actConfig: TAction;
    actAddChannel: TAction;
    actDelChannel: TAction;
    CfgPanel: TPanel;
    OkBtn: TButton;
    CancelBtn: TButton;
    UseSSLBox: TCheckBox;
    FirmwareVerEdit: TLabeledEdit;
    DevNameEdit: TLabeledEdit;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    InfoPanel: TPanel;
    GuidText: TStaticText;
    Label1: TLabel;
    AuthKeyText: TStaticText;
    Label2: TLabel;
    ChannelPopupMenu: TPopupMenu;
    Usukana1: TMenuItem;
    actEditChannel: TAction;
    Edytujkana1: TMenuItem;
    actChannelUp: TAction;
    actChannelDn: TAction;
    Dogry1: TMenuItem;
    Wd1: TMenuItem;
    actClearRegistred: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    AutoReconnectTimer: TTimer;
    AutoReconnectBox: TCheckBox;
    IntervalcText: TStaticText;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actInformationExecute(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure actAddChannelExecute(Sender: TObject);
    procedure actOpenCloseExecute(Sender: TObject);
    procedure ChannelPopupMenuPopup(Sender: TObject);
    procedure actChannelUpUpdate(Sender: TObject);
    procedure actChannelDnUpdate(Sender: TObject);
    procedure actChannelDnExecute(Sender: TObject);
    procedure actChannelUpExecute(Sender: TObject);
    procedure actEditChannelUpdate(Sender: TObject);
    procedure actEditChannelExecute(Sender: TObject);
    procedure actDelChannelUpdate(Sender: TObject);
    procedure actDelChannelExecute(Sender: TObject);
    procedure actAddChannelUpdate(Sender: TObject);
    procedure actClearRegistredUpdate(Sender: TObject);
    procedure actClearRegistredExecute(Sender: TObject);
    procedure actOpenCloseUpdate(Sender: TObject);
    procedure AutoReconnectTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Memo1DblClick(Sender: TObject);
  private
    SuplaDevDrv: TSuplaDevDrv;
    DevCfg: TSuplaDevCfg; // wska¿nik do elementu na liœcie ProgCfg.DevCfgList
    mPopUpFrame: TBaseFrame;
    mFrameList: TFrameList;
    mDestroying: Boolean;

    procedure Wr(s: string);
    procedure SuplaOnDataRecive(Sender: TSuplaDevDrv; BufObj: TBufObj);
    procedure OnDevStatus(ASender: TObject; const txt: string);
    procedure FillInfoPanel;
    function CreateChannelFrame(FrameOwner: TPanel; ChannelType: integer): TBaseFrame;
    procedure AddChannelFrame(chNr: integer; chCfg: TChannelCfg);
    procedure OnSuplaRegistredProc(Sender: TObject);
    procedure OnNewChannelValue(Sender: TObject; NewVal: TSD_SuplaChannelNewValue);
    procedure OnCalCfgProc(Sender: TObject; CalCfg: TSD_DeviceCalCfgRequest);
    procedure OnDisconected(Sender: TObject);
    procedure OnWdgTimerProc(Sender: TObject);

    function GetChannelFrame(channelNr: integer): TBaseFrame;
    procedure ReloadChannels;
    procedure OnSendChannelNewValue(Sender: TObject; ToSendDt: TDS_SuplaDeviceChannelValue);
    procedure OnSendChannelNewValueEx(Sender: TObject; ToSendDt: TDS_SuplaDeviceChannelExtendedValue);

    procedure OnFrameMsgProc(Sender: TObject; Msg: string);
  public
    procedure SetCfg(Dev: TSuplaDevCfg);
    function isConnected: Boolean;
    procedure Connect;
    procedure DisConnect;

    { Public declarations }
  end;

implementation

uses
  TemperatureFrameUnit,
  RelayFrameUnit,
  InputFrameUnit,
  TempHumidityFrameUnit,
  ElektrMeterFrameUnit,
  ImpulsCounterFrameUnit,
  ThermostatHeatpolFrameUnit,
  ThermostatFrameUnit,
  NoImplementedFrameUnit;
{$R *.dfm}

function TFrameList.FGetItem(Index: integer): TPanelInfo;
begin
  Result := inherited GetItem(Index) as TPanelInfo;
end;

procedure TSuplaDevForm.FormCreate(Sender: TObject);
begin
  mDestroying := false;
  SuplaDevDrv := TSuplaDevDrv.Create;
  SuplaDevDrv.OnStatusEvent := OnDevStatus;
  SuplaDevDrv.OnDataRecive := SuplaOnDataRecive;
  SuplaDevDrv.OnSuplaRegistred := OnSuplaRegistredProc;
  SuplaDevDrv.OnNewChannelValue := OnNewChannelValue;
  SuplaDevDrv.OnCalCfg := OnCalCfgProc;

  SuplaDevDrv.OnDisconnected := OnDisconected;
  SuplaDevDrv.OnWdgTimer := OnWdgTimerProc;
  mFrameList := TFrameList.Create;

end;

procedure TSuplaDevForm.FormDestroy(Sender: TObject);
begin
  SuplaDevDrv.Free;
  mFrameList.Free;
end;

procedure TSuplaDevForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  mDestroying := true;
end;

procedure TSuplaDevForm.SetCfg(Dev: TSuplaDevCfg);
var
  i: integer;
begin
  DevCfg := Dev;
  DevCfg.Form := self;

  Top := DevCfg.M_Top;
  Left := DevCfg.M_Left;
  Caption := DevCfg.Name;
  if (DevCfg.M_Width <> 0) and (DevCfg.M_Height <> 0) then
  begin
    Width := DevCfg.M_Width;
    Height := DevCfg.M_Height;
  end;
  if DevCfg.MemoHeight <> 0 then
  begin
    Memo1.Height := DevCfg.MemoHeight;
  end;
  WindowState := DevCfg.M_Winstate;

  for i := 0 to DevCfg.Channels.Count - 1 do
  begin
    AddChannelFrame(i, DevCfg.Channels.Items[i]);
  end;

end;

function TSuplaDevForm.isConnected: Boolean;
begin
  Result := SuplaDevDrv.Connected;
end;

procedure TSuplaDevForm.Memo1DblClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TSuplaDevForm.Connect;
begin
  if SuplaDevDrv.Connected = false then
  begin
    SuplaDevDrv.Open(ProgCfg.ServerName, DevCfg);
    AutoReconnectTimer.Enabled := DevCfg.autoReconnect;
  end;
end;

procedure TSuplaDevForm.DisConnect;
begin
  if SuplaDevDrv.Connected then
  begin
    SuplaDevDrv.Close;
    AutoReconnectTimer.Enabled := false;
  end;
end;

procedure TSuplaDevForm.ReloadChannels;
var
  i: integer;
  P: TPanel;
begin
  for i := 0 to mFrameList.Count - 1 do
  begin
    P := mFrameList.Items[i].Panel;
    ScrollBox.RemoveControl(P);
    P.Free
  end;

  mFrameList.Clear;

  for i := 0 to DevCfg.Channels.Count - 1 do
  begin
    AddChannelFrame(i, DevCfg.Channels.Items[i]);
  end;

end;

procedure TSuplaDevForm.OnSuplaRegistredProc(Sender: TObject);
begin
  DevCfg.Registered := true;
end;

procedure TSuplaDevForm.OnDisconected(Sender: TObject);
begin
  Wr('Remote close');
end;

procedure TSuplaDevForm.OnWdgTimerProc(Sender: TObject);
var
  i: integer;
  ValTab: TDS_SuplaDeviceChannelValueTab;
begin
  if SuplaDevDrv.Connected then
  begin
    Wr('WDG Send state');
    setlength(ValTab, mFrameList.Count);
    for i := 0 to mFrameList.Count - 1 do
    begin
      mFrameList.Items[i].Frame.getValue(ValTab[i]);
    end;
    SuplaDevDrv.SendChannelsValue(ValTab);
  end;
end;

function TSuplaDevForm.GetChannelFrame(channelNr: integer): TBaseFrame;
begin
  Result := nil;
  if (channelNr >= 0) and (channelNr < mFrameList.Count) then
    Result := mFrameList.Items[channelNr].Frame;
end;

procedure TSuplaDevForm.OnNewChannelValue(Sender: TObject; NewVal: TSD_SuplaChannelNewValue);
var
  Frame: TBaseFrame;
begin
  Frame := GetChannelFrame(NewVal.ChannelNumber);
  if Assigned(Frame) then
    Frame.SetNewValue(NewVal);
end;

procedure TSuplaDevForm.OnCalCfgProc(Sender: TObject; CalCfg: TSD_DeviceCalCfgRequest);
var
  Frame: TBaseFrame;
begin
  Frame := GetChannelFrame(CalCfg.ChannelNumber);
  if Assigned(Frame) then
    Frame.SetCalCfg(CalCfg);
end;

procedure TSuplaDevForm.OnSendChannelNewValue(Sender: TObject; ToSendDt: TDS_SuplaDeviceChannelValue);
begin
  if SuplaDevDrv.Connected then
  begin
    Wr(Format('Send Ch=%u Val=%s', [ToSendDt.ChannelNumber, ToSendDt.value.getAsString]));
    SuplaDevDrv.SendChannelValue(ToSendDt);
  end;
end;

procedure TSuplaDevForm.OnSendChannelNewValueEx(Sender: TObject; ToSendDt: TDS_SuplaDeviceChannelExtendedValue);
begin
  if SuplaDevDrv.Connected then
  begin
    Wr(Format('Send Ch=%u Size=%u', [ToSendDt.ChannelNumber, ToSendDt.value.size]));
    SuplaDevDrv.SendChannelValue(ToSendDt);
  end;
end;

procedure TSuplaDevForm.OnFrameMsgProc(Sender: TObject; Msg: string);
begin
  Wr(Msg);
end;

procedure TSuplaDevForm.actInformationExecute(Sender: TObject);
var
  Act: TAction;
begin
  Act := Sender as TAction;
  Act.Checked := not(Act.Checked);
  InfoBtn.Down := Act.Checked;
  InfoPanel.Visible := Act.Checked;
  if InfoPanel.Visible then
  begin
    InfoPanel.Top := 0;
    FillInfoPanel
  end;
end;

procedure TSuplaDevForm.actOpenCloseExecute(Sender: TObject);
begin
  if SuplaDevDrv.Connected = false then
    Connect
  else
    DisConnect;
  ConnectBtn.Down := SuplaDevDrv.Connected;
end;

procedure TSuplaDevForm.actOpenCloseUpdate(Sender: TObject);
begin
  ConnectBtn.Down := SuplaDevDrv.Connected;
end;

procedure TSuplaDevForm.FillInfoPanel;
begin
  GuidText.Caption := DevCfg.Guid.getAsHumanString;
  AuthKeyText.Caption := DevCfg.AuthKey.getAsHumanString;
  IntervalcText.Caption := IntToStr(SuplaDevDrv.ActivityTimeOut);
end;

function TSuplaDevForm.CreateChannelFrame(FrameOwner: TPanel; ChannelType: integer): TBaseFrame;
begin
  Result := nil;
  case ChannelType of
    SUPLA_CHANNELTYPE_RELAY:
      Result := TRelayFrame.Create(FrameOwner);
    SUPLA_CHANNELTYPE_THERMOMETERDS18B20, //
      SUPLA_CHANNELTYPE_WINDSENSOR, //
      SUPLA_CHANNELTYPE_PRESSURESENSOR, //
      SUPLA_CHANNELTYPE_RAINSENSOR, //
      SUPLA_CHANNELTYPE_WEIGHTSENSOR, //
      SUPLA_CHANNELTYPE_THERMOMETER, //
      SUPLA_CHANNELTYPE_DISTANCESENSOR:
      begin
        Result := TTemperatureFrame.Create(FrameOwner);
      end;
    SUPLA_CHANNELTYPE_CALLBUTTON, //
      SUPLA_CHANNELTYPE_SENSORNO, //
      SUPLA_CHANNELTYPE_SENSORNC:
      begin
        Result := TInputFrame.Create(FrameOwner);
        (Result as TInputFrame).SetType(ChannelType);
      end;
    SUPLA_CHANNELTYPE_HUMIDITYANDTEMPSENSOR, //
      SUPLA_CHANNELTYPE_DHT11, //
      SUPLA_CHANNELTYPE_DHT22, //
      SUPLA_CHANNELTYPE_DHT21, //
      SUPLA_CHANNELTYPE_AM2302, //
      SUPLA_CHANNELTYPE_AM2301:
      begin
        Result := TTempHumidityFrame.Create(FrameOwner);
      end;
    SUPLA_CHANNELTYPE_ELECTRICITY_METER:
      begin
        Result := TElektrMeterFrame.Create(FrameOwner);
      end;
    SUPLA_CHANNELTYPE_IMPULSE_COUNTER:
      begin
        Result := TImpulsCounterFrame.Create(FrameOwner);
      end;

    SUPLA_CHANNELTYPE_THERMOSTAT:
      begin
        Result := TThermostatFrame.Create(FrameOwner);
      end;
    SUPLA_CHANNELTYPE_THERMOSTAT_HEATPOL_HOMEPLUS:
      begin
        if ProgCfg.SpecUser then
          Result := TThermostatHeatpolFrame.Create(FrameOwner);
      end;

  else
    Result := TNoImplementedFrame.Create(FrameOwner);
  end;

  if Result=nil then
    Result := TNoImplementedFrame.Create(FrameOwner);
end;

procedure TSuplaDevForm.AddChannelFrame(chNr: integer; chCfg: TChannelCfg);
var
  Panel: TPanel;
  Frame: TBaseFrame;
  PInfo: TPanelInfo;
  h1: integer;
begin
  Panel := TPanel.Create(self);
  Panel.Parent := ScrollBox;
  Panel.Align := alTop;
  Panel.Height := 84;
  // Panel.Name := Format('Channel_%u', [chNr + 1]);
  Panel.Top := 1000;
  Frame := CreateChannelFrame(Panel, chCfg.ChannelType);
  Frame.Parent := Panel;
  h1 := Frame.getFrameHeight;
  Frame.Align := alClient;
  Frame.PopupMenu := ChannelPopupMenu;
  Frame.setChannelInfo(chNr, chCfg);
  Frame.OnSendChannelValue := OnSendChannelNewValue;
  Frame.OnSendChannelValueEx := OnSendChannelNewValueEx;

  Frame.OnMsg := OnFrameMsgProc;
  Panel.Height := h1;

  PInfo := TPanelInfo.Create;
  PInfo.Panel := Panel;
  PInfo.Frame := Frame;
  mFrameList.Add(PInfo);
end;

procedure TSuplaDevForm.AutoReconnectTimerTimer(Sender: TObject);
begin
  if not SuplaDevDrv.Connected then
  begin
    Connect;
  end;
end;

procedure TSuplaDevForm.actAddChannelExecute(Sender: TObject);
var
  Dlg: TNewChannelDlg;
  chCfg: TChannelCfg;
begin
  Dlg := TNewChannelDlg.Create(self);
  try
    if Dlg.ShowModal = mrOK then
    begin
      chCfg := Dlg.getChannelCfg;
      DevCfg.Channels.Add(chCfg);
      AddChannelFrame(DevCfg.Channels.Count - 1, chCfg);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TSuplaDevForm.actAddChannelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := not DevCfg.Registered;
end;

procedure TSuplaDevForm.actChannelDnExecute(Sender: TObject);
begin
  DevCfg.Channels.MoveDn(mPopUpFrame.ChannelCfg);
  ReloadChannels;
end;

procedure TSuplaDevForm.actChannelDnUpdate(Sender: TObject);
var
  q: Boolean;
begin
  q := false;
  if Assigned(mPopUpFrame) then
  begin
    q := not DevCfg.Channels.isLast(mPopUpFrame.ChannelCfg);
    q := q and not DevCfg.Registered;
  end;
  (Sender as TAction).Enabled := q;
end;

procedure TSuplaDevForm.actChannelUpExecute(Sender: TObject);
begin
  DevCfg.Channels.MoveUp(mPopUpFrame.ChannelCfg);
  ReloadChannels;
end;

procedure TSuplaDevForm.actChannelUpUpdate(Sender: TObject);
var
  q: Boolean;
begin
  q := false;
  if Assigned(mPopUpFrame) then
  begin
    q := not DevCfg.Channels.isFirst(mPopUpFrame.ChannelCfg);
    q := q and not DevCfg.Registered;
  end;
  (Sender as TAction).Enabled := q;
end;

procedure TSuplaDevForm.actClearRegistredExecute(Sender: TObject);
begin
  if DevCfg.Registered then
  begin
    Application.MessageBox
      ('Jeœli zmienisz konfiguracjê kana³ów, to przed ponown¹ rejestracj¹ musisz skasowaæ urz¹dzenie na serwerze SUPLA',
      'Uwaga !', Mb_Ok);
    DevCfg.Registered := false;
  end;
end;

procedure TSuplaDevForm.actClearRegistredUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := DevCfg.Registered and not(SuplaDevDrv.Connected);
end;

procedure TSuplaDevForm.actConfigExecute(Sender: TObject);
var
  Act: TAction;
begin
  Act := Sender as TAction;
  Act.Checked := not(Act.Checked);
  CfgBtn.Down := Act.Checked;
  CfgPanel.Visible := Act.Checked;
  if CfgPanel.Visible then
  begin
    CfgPanel.Top := 0;
    FirmwareVerEdit.Text := DevCfg.SoftVer;
    DevNameEdit.Text := DevCfg.Name;
    UseSSLBox.Checked := DevCfg.useSSL;
    AutoReconnectBox.Checked := DevCfg.autoReconnect;
    FirmwareVerEdit.Enabled := not(SuplaDevDrv.Connected);
    DevNameEdit.Enabled := not(SuplaDevDrv.Connected);
    UseSSLBox.Enabled := not(SuplaDevDrv.Connected);
    AutoReconnectBox.Enabled := not(SuplaDevDrv.Connected);
  end;
end;

procedure TSuplaDevForm.actDelChannelExecute(Sender: TObject);
var
  txt: string;
begin
  txt := Format('Czy usun¹æ kana³ nr %u, typu %s ?', [DevCfg.Channels.IndexOf(mPopUpFrame.ChannelCfg) + 1,
    getChanelTypeName(mPopUpFrame.ChannelCfg.ChannelType)]);
  if Application.MessageBox(pchar(txt), 'Usuñ', MB_YESNO) = idYes then
  begin
    DevCfg.deleteChannel(mPopUpFrame.ChannelCfg);
    ReloadChannels;
  end;
end;

procedure TSuplaDevForm.actDelChannelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(mPopUpFrame) and not DevCfg.Registered;
end;

procedure TSuplaDevForm.actEditChannelExecute(Sender: TObject);
var
  Dlg: TNewChannelDlg;
  chCfg: TChannelCfg;
begin
  Dlg := TNewChannelDlg.Create(self);
  try
    Dlg.setChannelCfg(mPopUpFrame.ChannelCfg);
    if Dlg.ShowModal = mrOK then
    begin
      chCfg := Dlg.getChannelCfg;
      mPopUpFrame.ChannelCfg.copyFrom(chCfg);
      chCfg.Free;
      ReloadChannels;
    end;
  finally
    Dlg.Free;
  end;

end;

procedure TSuplaDevForm.actEditChannelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(mPopUpFrame) and not DevCfg.Registered;
end;

procedure TSuplaDevForm.CancelBtnClick(Sender: TObject);
begin
  actConfig.Checked := false;
  CfgBtn.Down := false;
  CfgPanel.Visible := false;
end;

procedure TSuplaDevForm.ChannelPopupMenuPopup(Sender: TObject);
var
  menu: TPopupMenu;
  i: integer;
  y: integer;
  Pt: TPoint;
  PInfo: TPanelInfo;
begin
  menu := Sender as TPopupMenu;
  mPopUpFrame := nil;
  Pt := ScrollBox.ScreenToClient(menu.PopupPoint);
  y := Pt.y;
  for i := 0 to mFrameList.Count - 1 do
  begin
    PInfo := mFrameList.Items[i];
    if (y >= PInfo.Panel.Top) and (y < PInfo.Panel.Top + PInfo.Panel.Height) then
    begin
      mPopUpFrame := PInfo.Frame;
    end;

  end;

end;

procedure TSuplaDevForm.OkBtnClick(Sender: TObject);
begin
  DevCfg.useSSL := UseSSLBox.Checked;
  DevCfg.SoftVer := FirmwareVerEdit.Text;
  DevCfg.Name := DevNameEdit.Text;
  DevCfg.autoReconnect := AutoReconnectBox.Checked;

  CancelBtnClick(Sender);
  Caption := DevCfg.Name;
  if DevCfg.autoReconnect = false then
    AutoReconnectTimer.Enabled := false;

end;

procedure TSuplaDevForm.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  if Application.MessageBox('Czy na pewno chcesz usun¹æ urz¹dzenie ?', 'Usuwanie', MB_YESNO) = idYes then
  begin
    Action := caFree;
    Application.MessageBox('Nie zapominj usun¹æ urz¹dzenie z serwera Supli !', 'Usuniêty', Mb_Ok);
    ProgCfg.DelDevice(DevCfg);
  end
  else
    Action := caNone;

end;

procedure TSuplaDevForm.Wr(s: string);
begin
  if not mDestroying then
    Memo1.Lines.Add(s);
end;

procedure TSuplaDevForm.SuplaOnDataRecive(Sender: TSuplaDevDrv; BufObj: TBufObj);
begin
  Wr(Format('Reclen=%d', [length(BufObj.buf)]));
end;

procedure TSuplaDevForm.OnDevStatus(ASender: TObject; const txt: string);
begin

  Wr(txt);
end;

end.
