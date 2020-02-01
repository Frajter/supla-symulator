unit ConfigEditUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  ProgCfgUnit;

type
  TConfigForm = class(TForm)
    ServerNameEdit: TLabeledEdit;
    EmailEdit: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

procedure TConfigForm.Button1Click(Sender: TObject);
begin
  ProgCfg.ServerName := ServerNameEdit.Text;
  ProgCfg.Email := EmailEdit.Text;
end;

procedure TConfigForm.FormShow(Sender: TObject);
begin
  ServerNameEdit.Text := ProgCfg.ServerName;
  EmailEdit.Text := ProgCfg.Email;
end;

end.
