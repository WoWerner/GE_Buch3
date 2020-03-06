unit db_liste;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DBGrids;

type

  { TfrmListe }

  TfrmListe = class(TForm)
    btnClose: TButton;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmListe: TfrmListe;

implementation

uses
  global,
  help;

{$R *.lfm}

{ TfrmListe }

procedure TfrmListe.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmListe.FormShow(Sender: TObject);

var i : integer;

begin
  for i := 0 to DBGrid1.Columns.Count-1 do
    if DBGrid1.Columns.Items[i].Width > 130 then DBGrid1.Columns.Items[i].Width := 130;
end;

end.

