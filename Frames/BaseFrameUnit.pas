unit BaseFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProgCfgUnit,
  supla_proto, SuplaDevDrvUnit;

type
  TOnSendToServerValue = procedure(Sender: TObject; NewVal: TDS_SuplaDeviceChannelValue) of object;
  TOnSendToServerValueEx = procedure(Sender: TObject; NewVal: TDS_SuplaDeviceChannelExtendedValue) of object;
  TOnMsg = procedure(Sender: TObject; msg: string) of object;

  TBaseFrame = class(TFrame)
    Image1: TImage;
  private
    FOnSendChannelValue: TOnSendToServerValue;
    FOnSendChannelValueEx: TOnSendToServerValueEx;
    FOnMsg: TOnMsg;
  protected
    mChannelCfg: TChannelCfg;
    mChannelNr: integer;
    LastValSenderId: integer;
    procedure SetResorcePic(Resname: string);
  public
    property OnSendChannelValue: TOnSendToServerValue read FOnSendChannelValue write FOnSendChannelValue;
    property OnSendChannelValueEx: TOnSendToServerValueEx read FOnSendChannelValueEx write FOnSendChannelValueEx;

    property OnMsg: TOnMsg read FOnMsg write FOnMsg;
    procedure SetNewValue(NewVal: TSD_SuplaChannelNewValue); virtual;
    procedure SetCalCfg(CalCfg: TSD_DeviceCalCfgRequest); virtual;

    procedure SendNewValue(ToSendVal: TDS_SuplaDeviceChannelValue);
    procedure SendNewValueEx(ToSendVal: TDS_SuplaDeviceChannelExtendedValue);

    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); virtual;
    procedure getValue(var ChVal: TDS_SuplaDeviceChannelValue); virtual;
    function getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): boolean; virtual;
    property ChannelCfg: TChannelCfg read mChannelCfg;
    procedure Wr(str: string);
    function getFrameHeight: integer; virtual;

  end;

implementation

{$R *.dfm}

procedure TBaseFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  mChannelCfg := ChCfg;
  mChannelNr := ChNr;
end;

procedure TBaseFrame.Wr(str: string);
begin
  if Assigned(FOnMsg) then
    FOnMsg(self, str);
end;

function TBaseFrame.getFrameHeight: integer;
begin
  Result := Height;
end;

procedure TBaseFrame.SetNewValue(NewVal: TSD_SuplaChannelNewValue);
begin
  LastValSenderId := NewVal.SenderID;
end;

procedure TBaseFrame.SetCalCfg(CalCfg: TSD_DeviceCalCfgRequest);
begin

end;

procedure TBaseFrame.SendNewValue(ToSendVal: TDS_SuplaDeviceChannelValue);
begin
  if Assigned(FOnSendChannelValue) then
    FOnSendChannelValue(self, ToSendVal);
end;

procedure TBaseFrame.SendNewValueEx(ToSendVal: TDS_SuplaDeviceChannelExtendedValue);
begin
  if Assigned(FOnSendChannelValueEx) then
    FOnSendChannelValueEx(self, ToSendVal);
end;

procedure TBaseFrame.getValue(var ChVal: TDS_SuplaDeviceChannelValue);
begin
  ChVal.ChannelNumber := mChannelNr;
  ChVal.value.Zero;
end;

function TBaseFrame.getValueEx(var ChVal: TDS_SuplaDeviceChannelExtendedValue): boolean;
begin
  Result := false;
end;

procedure TBaseFrame.SetResorcePic(Resname: string);
var
  Stream: TResourceStream;
begin
  if Resname <> '' then
  begin
    Stream := TResourceStream.Create(hInstance, Resname, 'PNG');
    try
      Image1.Picture.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

end.
