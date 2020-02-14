unit personen;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  FileUtil,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  DbCtrls,
  StdCtrls,
  DBGrids;

type

  { TfrmPersonen }

  TfrmPersonen = class(TForm)
    btnSchliessen: TButton;
    DBCBAnrede: TDBComboBox;
    DBCheckBoxAbgang: TDBCheckBox;
    dbediEMail: TDBEdit;
    dbediGeburtstag: TDBEdit;
    dbediGE_KartID: TDBEdit;
    dbediLand: TDBEdit;
    dbediName: TDBEdit;
    dbediOrt: TDBEdit;
    dbediOrtsteil: TDBEdit;
    dbediPersonenID: TDBEdit;
    dbediPLZ: TDBEdit;
    dbediStrasse: TDBEdit;
    dbediTelDienst: TDBEdit;
    dbediTelMobil: TDBEdit;
    dbediTelPrivat: TDBEdit;
    dbediTitel: TDBEdit;
    dbediVorname: TDBEdit;
    dbediVorname2: TDBEdit;
    DBGridPersonen: TDBGrid;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    procedure btnSchliessenClick(Sender: TObject);
    procedure DBGridPersonenColumnSized(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPersonen: TfrmPersonen;

implementation

{$R *.lfm}

{ TfrmPersonen }

uses
  DB,      //Dataset.state
  dm,
  global,
  help;

var
  Col00Width,
  Col03Width,
  Col04Width,
  Col05Width,
  Col06Width,
  Col08Width,
  Col09Width,
  Col10Width,
  Col11Width,
  Col12Width,
  Col13Width,
  Col14Width,
  Col17Width,
  Winleft,
  WinTop,
  WinWidth,
  WinHeight : integer;

procedure TfrmPersonen.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  help.WriteIniInt(sIniFile, 'Personen', 'Col00Width', DBGridPersonen.Columns.Items[ 0].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col03Width', DBGridPersonen.Columns.Items[ 3].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col04Width', DBGridPersonen.Columns.Items[ 4].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col05Width', DBGridPersonen.Columns.Items[ 5].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col06Width', DBGridPersonen.Columns.Items[ 6].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col08Width', DBGridPersonen.Columns.Items[ 8].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col09Width', DBGridPersonen.Columns.Items[ 9].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col10Width', DBGridPersonen.Columns.Items[10].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col11Width', DBGridPersonen.Columns.Items[11].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col12Width', DBGridPersonen.Columns.Items[12].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col13Width', DBGridPersonen.Columns.Items[13].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col14Width', DBGridPersonen.Columns.Items[14].Width);
  help.WriteIniInt(sIniFile, 'Personen', 'Col17Width', DBGridPersonen.Columns.Items[17].Width);

  help.WriteIniInt(sIniFile, 'Personen', 'Winleft',   self.Left);
  help.WriteIniInt(sIniFile, 'Personen', 'WinTop',    self.Top);
  help.WriteIniInt(sIniFile, 'Personen', 'WinWidth',  self.Width);
  help.WriteIniInt(sIniFile, 'Personen', 'WinHeight', self.Height);

  if frmDM.ZQueryPersonen.State in [dsEdit, dsInsert]
    then frmDM.ZQueryPersonen.Post; {speicheret die Änderungen}
  frmDM.ZQueryPersonen.close;
end;

procedure TfrmPersonen.FormKeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) and not (activeControl is TButton)
    then
      begin
        key := #0;
        SelectNext(activeControl, True, True);
      end;
end;

procedure TfrmPersonen.FormShow(Sender: TObject);
begin
  Col00Width := help.ReadIniInt(sIniFile, 'Personen', 'Col00Width', 40);
  Col03Width := help.ReadIniInt(sIniFile, 'Personen', 'Col03Width', 90);
  Col04Width := help.ReadIniInt(sIniFile, 'Personen', 'Col04Width', 90);
  Col05Width := help.ReadIniInt(sIniFile, 'Personen', 'Col05Width', 90);
  Col06Width := help.ReadIniInt(sIniFile, 'Personen', 'Col06Width',170);
  Col08Width := help.ReadIniInt(sIniFile, 'Personen', 'Col08Width', 45);
  Col09Width := help.ReadIniInt(sIniFile, 'Personen', 'Col09Width',100);
  Col10Width := help.ReadIniInt(sIniFile, 'Personen', 'Col10Width', 80);
  Col11Width := help.ReadIniInt(sIniFile, 'Personen', 'Col11Width',100);
  Col12Width := help.ReadIniInt(sIniFile, 'Personen', 'Col12Width', 60);
  Col13Width := help.ReadIniInt(sIniFile, 'Personen', 'Col13Width', 60);
  Col14Width := help.ReadIniInt(sIniFile, 'Personen', 'Col14Width',140);
  Col17Width := help.ReadIniInt(sIniFile, 'Personen', 'Col17Width', 75);
  Winleft    := help.ReadIniInt(sIniFile, 'Personen', 'Winleft',  self.Left);
  WinTop     := help.ReadIniInt(sIniFile, 'Personen', 'WinTop',   self.Top);
  WinWidth   := help.ReadIniInt(sIniFile, 'Personen', 'WinWidth', self.Width);
  WinHeight  := help.ReadIniInt(sIniFile, 'Personen', 'WinHeight',self.Height);

  self.Left  := Winleft;
  self.Top   := WinTop;
  self.Width := WinWidth;
  self.Height:= WinHeight;

  DBGridPersonen.Columns.Items[ 0].Width         :=  Col00Width;   //Nr
  DBGridPersonen.Columns.Items[ 0].Title.Caption := 'ID';
  DBGridPersonen.Columns.Items[ 1].Visible       :=  false;        //Anrede
  DBGridPersonen.Columns.Items[ 2].Visible       :=  false;        //Titel
  DBGridPersonen.Columns.Items[ 3].Width         :=  Col03Width;   //Vorname
  DBGridPersonen.Columns.Items[ 4].Width         :=  Col04Width;   //Vorname2
  DBGridPersonen.Columns.Items[ 5].Width         :=  Col05Width;   //Nachame
  DBGridPersonen.Columns.Items[ 6].Width         :=  Col06Width;   //Straße
  DBGridPersonen.Columns.Items[ 7].Visible       :=  false;        //Land
  DBGridPersonen.Columns.Items[ 8].Width         :=  Col08Width;   //PLZ
  DBGridPersonen.Columns.Items[ 9].Width         :=  Col09Width;   //Ort
  DBGridPersonen.Columns.Items[10].Width         :=  Col10Width;   //Ortsteil
  DBGridPersonen.Columns.Items[11].Width         :=  Col11Width;   //Tel
  DBGridPersonen.Columns.Items[12].Width         :=  Col12Width;   //Tel
  DBGridPersonen.Columns.Items[13].Width         :=  Col13Width;   //Tel
  DBGridPersonen.Columns.Items[14].Width         :=  Col14Width;   //email
  DBGridPersonen.Columns.Items[15].Visible       :=  false;        //letzter Beitrag
  DBGridPersonen.Columns.Items[16].Visible       :=  false;        //GE_KartID
  DBGridPersonen.Columns.Items[17].Width         :=  Col17Width;   //Geburtstag
  DBGridPersonen.Columns.Items[18].Visible       :=  false;        //Abgang
end;

procedure TfrmPersonen.btnSchliessenClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPersonen.DBGridPersonenColumnSized(Sender: TObject);
begin
  Col00Width := DBGridPersonen.Columns.Items[ 0].Width;
  Col03Width := DBGridPersonen.Columns.Items[ 3].Width;
  Col04Width := DBGridPersonen.Columns.Items[ 4].Width;
  Col05Width := DBGridPersonen.Columns.Items[ 5].Width;
  Col06Width := DBGridPersonen.Columns.Items[ 6].Width;
  Col08Width := DBGridPersonen.Columns.Items[ 8].Width;
  Col09Width := DBGridPersonen.Columns.Items[ 9].Width;
  Col10Width := DBGridPersonen.Columns.Items[10].Width;
  Col11Width := DBGridPersonen.Columns.Items[11].Width;
  Col12Width := DBGridPersonen.Columns.Items[12].Width;
  Col13Width := DBGridPersonen.Columns.Items[13].Width;
  Col14Width := DBGridPersonen.Columns.Items[14].Width;
  Col17Width := DBGridPersonen.Columns.Items[17].Width;
end;

procedure TfrmPersonen.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
begin
  dbediPersonenID.SetFocus;
  if Button = nbInsert then frmDM.ZQueryPersonen.Insert;
end;


end.

