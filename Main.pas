unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, Vcl.OleCtrls,
  SHDocVw, Vcl.ComCtrls, IdGlobal,
  IdCustomTCPServer, IdTCPServer,
  Supla_proto, SuplaDevDrvUnit, System.ImageList, Vcl.ImgList, System.Actions,
  Vcl.ActnList, Vcl.ToolWin,
  ProgCfgUnit, ConfigEditUnit, SuplaDevUnit;

type

  TMainForm = class(TForm)
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    actConfig: TAction;
    actAddDevice: TAction;
    actSaveConfig: TAction;
    actDisconnectAll: TAction;
    actConnectAll: TAction;
    ToolButton8: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actSaveConfigExecute(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure actAddDeviceExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actDisconnectAllUpdate(Sender: TObject);
    procedure actConnectAllUpdate(Sender: TObject);
    procedure actDisconnectAllExecute(Sender: TObject);
    procedure actConnectAllExecute(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
{$R pictures.res}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ProgCfg.LoadFromReg;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ProgCfg.SaveToReg;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i: integer;
  Form: TSuplaDevForm;
begin
  if (ProgCfg.W_Height<>0) and (ProgCfg.W_Width<>0) then
  begin
    Top := ProgCfg.W_Top;
    Left := ProgCfg.W_Left;
    Height := ProgCfg.W_Height;
    Width := ProgCfg.W_Width;
  end;

  for i := 0 to ProgCfg.DevCfgList.Count - 1 do
  begin
    Form := TSuplaDevForm.Create(self);
    Form.SetCfg(ProgCfg.DevCfgList.Items[i]);
  end;
end;

procedure TMainForm.actAddDeviceExecute(Sender: TObject);
var
  Dev: TSuplaDevCfg;
  Form: TSuplaDevForm;
begin
  Dev := ProgCfg.AddDevice;
  Form := TSuplaDevForm.Create(self);
  Form.SetCfg(Dev);

end;

procedure TMainForm.actConfigExecute(Sender: TObject);
var
  dlg: TConfigForm;
begin
  dlg := TConfigForm.Create(self);
  try
    dlg.ShowModal;
  finally
    dlg.Free;
  end;
end;

procedure TMainForm.actConnectAllExecute(Sender: TObject);
var
  i : integer;
begin
  for i:=0 to MdiChildCount-1 do
  begin
    (MDIChildren[i] as TSuplaDevForm).Connect;
  end;
end;

procedure TMainForm.actConnectAllUpdate(Sender: TObject);
var
  i : integer;
  q : boolean;
begin
  q := false;
  for i:=0 to MdiChildCount-1 do
  begin
    if (MDIChildren[i] as TSuplaDevForm).isConnected=false then
      q := true;
  end;
  (Sender as Taction).Enabled := q;

end;

procedure TMainForm.actDisconnectAllExecute(Sender: TObject);
var
  i : integer;
begin
  for i:=0 to MdiChildCount-1 do
  begin
    (MDIChildren[i] as TSuplaDevForm).DisConnect;
  end;
end;

procedure TMainForm.actDisconnectAllUpdate(Sender: TObject);
var
  i : integer;
  q : boolean;
begin
  q := false;
  for i:=0 to MdiChildCount-1 do
  begin
    if (MDIChildren[i] as TSuplaDevForm).isConnected then
      q := true;
  end;
  (Sender as Taction).Enabled := q;
end;

procedure TMainForm.actSaveConfigExecute(Sender: TObject);
begin
  ProgCfg.SaveToReg;
end;

end.
