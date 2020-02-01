unit NoImplementedFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFrameUnit, Vcl.ExtCtrls,
  ProgCfgUnit,
  supla_proto, Vcl.StdCtrls;

type
  TNoImplementedFrame = class(TBaseFrame)
    CodeEdit: TLabeledEdit;
    Label1: TLabel;
  private
    { Private declarations }
  public
    procedure setChannelInfo(ChNr: integer; ChCfg: TChannelCfg); override;
  end;

implementation

procedure TNoImplementedFrame.setChannelInfo(ChNr: integer; ChCfg: TChannelCfg);
begin
  inherited;
  SetResorcePic('ERROR');
  CodeEdit.Text := IntToStr(mChannelCfg.ChannelType);
end;


{$R *.dfm}

end.
