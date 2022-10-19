unit sachkonten;

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
  DBGrids,
  Grids,
  StdCtrls,
  Spin, ExtCtrls,
  types;

type

  { TfrmSachkonten }

  TfrmSachkonten = class(TForm)
    btnAbbrechen: TButton;
    btnAendern: TButton;
    btnClose: TButton;
    btnSetFreistellung: TButton;
    btnDelete: TButton;
    btnHilfe: TButton;
    btnNeu: TButton;
    btnSpeichern: TButton;
    cbKontoType: TComboBox;
    cbSteuer: TComboBox;
    DBGridSachkontenliste: TDBGrid;
    ediFinanzamt: TEdit;
    ediFinanzamtVom: TEdit;
    ediFinanzamtNr: TEdit;
    ediSachkonto: TEdit;
    ediSachkontonummer: TSpinEdit;
    ediSortPos: TSpinEdit;
    ediStatistik: TSpinEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnAbbrechenClick(Sender: TObject);
    procedure btnAendernClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnHilfeClick(Sender: TObject);
    procedure btnNeuClick(Sender: TObject);
    procedure btnSetFreistellungClick(Sender: TObject);
    procedure btnSetFreistellungContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure btnSpeichernClick(Sender: TObject);
    //procedure DBGridSachkontenlisteDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridSachkontenlistePrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure ediSachkontoEnter(Sender: TObject);
    procedure ediSachkontonummerExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure AfterScroll;
  end;

var
  frmSachkonten: TfrmSachkonten;

implementation

{$R *.lfm}

uses
  global,
  ausgabe,
  help,
  db,
  dm;

{ TfrmSachkonten }

var
  Winleft,
  WinTop,
  WinWidth,
  WinHeight : integer;

procedure TfrmSachkonten.FormShow(Sender: TObject);

begin
  Winleft    := help.ReadIniInt(sIniFile, 'Sachkonten', 'Winleft',  self.Left);
  WinTop     := help.ReadIniInt(sIniFile, 'Sachkonten', 'WinTop',   self.Top);
  WinWidth   := help.ReadIniInt(sIniFile, 'Sachkonten', 'WinWidth', self.Width);
  WinHeight  := help.ReadIniInt(sIniFile, 'Sachkonten', 'WinHeight',self.Height);

  if (Winleft < VirtualScreenSize.Left) or (Winleft > (VirtualScreenSize.Left + VirtualScreenSize.Right)) then Winleft := 0;
  if (WinTop < VirtualScreenSize.Top) or (WinTop > (VirtualScreenSize.Top + VirtualScreenSize.Bottom)) then WinTop := 0;

  self.Left  := Winleft;
  self.Top   := WinTop;
  self.Width := WinWidth;
  self.Height:= WinHeight;

  if not frmDM.ZQuerySachkonten.Active then frmDM.ZQuerySachkonten.Open;
  AfterScroll;
end;

procedure TfrmSachkonten.AfterScroll;
begin
  //Hier wegen Query Refresh
  DBGridSachkontenliste.Columns.Items[0].Width   :=  60;    //SachkontoNr
  DBGridSachkontenliste.Columns.Items[1].Width   :=  60;    //Sortpos
  DBGridSachkontenliste.Columns.Items[2].Width   :=  60;    //Statistik
  DBGridSachkontenliste.Columns.Items[3].Width   := 400;    //Name
  DBGridSachkontenliste.Columns.Items[4].Width   :=  70;    //KontoType
  DBGridSachkontenliste.Columns.Items[5].Visible:=false;    //Kontostand
  DBGridSachkontenliste.Columns.Items[6].Width   := 180;    //Finanzamt
  DBGridSachkontenliste.Columns.Items[7].Width   := 100;    //Finanzamt vom
  DBGridSachkontenliste.Columns.Items[8].Width   := 100;    //Finanzamt am

  ediSachkontonummer.Value := frmDM.ZQuerySachkonten.FieldByName('KontoNr').AsInteger;
  ediSachkonto.Text        := frmDM.ZQuerySachkonten.FieldByName('Name').AsString;
  ediSortPos.Value         := frmDM.ZQuerySachkonten.FieldByName('Sortpos').AsInteger;
  cbKontoType.Text         := frmDM.ZQuerySachkonten.FieldByName('KontoType').AsString;
  cbSteuer.Text            := frmDM.ZQuerySachkonten.FieldByName('Steuer').AsString;
  ediStatistik.Value       := frmDM.ZQuerySachkonten.FieldByName('Statistik').AsInteger;
  ediFinanzamt.Text        := frmDM.ZQuerySachkonten.FieldByName('Finanzamt').AsString;
  ediFinanzamtNr.Text      := frmDM.ZQuerySachkonten.FieldByName('FinanzamtNr').AsString;
  ediFinanzamtVom.Text     := frmDM.ZQuerySachkonten.FieldByName('FinanzamtVom').AsString;
  btnDelete.ShowHint       := false;
  btnDelete.Enabled        := true;
  ediSachkontonummer.ShowHint:= false;
  ediSachkontonummer.Enabled := btnDelete.Enabled;

  if btnDelete.Enabled
    then
      begin
        frmDM.ZQueryHelp.SQL.Text:='select count(konto_nach) as c, max(Buchungsjahr) as m from journal where konto_nach='+inttostr(ediSachkontonummer.Value);
        frmDM.ZQueryHelp.Open;
        if (frmDM.ZQueryHelp.FieldByName('c').AsInteger <> 0)
          then
            begin
              btnDelete.Enabled := false;
              btnDelete.Hint    := 'Sachkonto kann nicht gelöscht werden weil es im Buchungsjahr '+inttostr(frmDM.ZQueryHelp.FieldByName('m').AsInteger)+' noch verwendet wird';
              btnDelete.ShowHint:= true;

              ediSachkontonummer.Enabled := false;
              ediSachkontonummer.Hint    := 'Sachkonto kann nicht editiert werden weil es im Buchungsjahr '+inttostr(frmDM.ZQueryHelp.FieldByName('m').AsInteger)+' noch verwendet wird';
              ediSachkontonummer.ShowHint:= true;
            end;
        frmDM.ZQueryHelp.Close;
      end;

  btnSetFreistellung.Hint := 'Setze für alle Einnahmekonten (Kennzeichnung E)'#13+
                             'Finanzamt auf "'+sFinanzamt+'"'#13+
                             'FinanzamtVom auf "'+sFinanzamtVom+'"'#13+
                             'FinanzamtNr auf "'+sFinanzamtNr+'"'#13#13+
                             'Einstellbar unter "Allgemeine Einstellungen"';
end;

procedure TfrmSachkonten.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  help.WriteIniInt(sIniFile, 'Sachkonten', 'Winleft',   self.Left);
  help.WriteIniInt(sIniFile, 'Sachkonten', 'WinTop',    self.Top);
  help.WriteIniInt(sIniFile, 'Sachkonten', 'WinWidth',  self.Width);
  help.WriteIniInt(sIniFile, 'Sachkonten', 'WinHeight', self.Height);

  frmDM.ZQuerySachkonten.Close;
end;

procedure TfrmSachkonten.FormCreate(Sender: TObject);
begin
  cbSteuer.Items.Text:=sSteuer;
end;

procedure TfrmSachkonten.DBGridSachkontenlistePrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);

var
  MyTextStyle: TTextStyle;

begin
  if DataCol in [0,5]
    then
      begin
        MyTextStyle := DBGridSachkontenliste.Canvas.TextStyle;
        MyTextStyle.Alignment:=taLeftJustify;
        DBGridSachkontenliste.Canvas.TextStyle := MyTextStyle;
      end;
end;

procedure TfrmSachkonten.btnNeuClick(Sender: TObject);
begin
  btnAbbrechen.Visible       := true;
  btnSpeichern.Visible       := true;
  btnNeu.Visible             := false;
  btnAendern.Visible         := false;
  btnDelete.Visible          := false;
  btnClose.Visible           := false;
  btnSetFreistellung.Visible := false;
  ediSachkonto.Text          := 'NeuesSachkonto';
  ediSachkontonummer.Value   := 500;
  ediSortPos.Value           := 500;
  ediStatistik.Value         := 500;
  cbSteuer.Text              := 'Nicht umsatzsteuerbar';
  ediSachkontonummer.Enabled := true;
  application.ProcessMessages;
  ediSachkontonummer.SetFocus;
end;

procedure TfrmSachkonten.btnSetFreistellungClick(Sender: TObject);
begin
  ShowMessage('Sicherheitsfunktion: Ausführen über Rechtsklick!');
end;

procedure TfrmSachkonten.btnSetFreistellungContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  frmDM.ZQueryHelp.SQL.Text:='Update konten set '+
                             'Finanzamt="'+sFinanzamt+'", '+
                             'FinanzamtVom="'+sFinanzamtVom+'", '+
                             'FinanzamtNr="'+sFinanzamtNr+'" '+
                             'where Kontotype = ''E''';
  frmDM.ZQueryHelp.ExecSQL;
  frmDM.ZQuerySachkonten.Refresh;
  AfterScroll;
  ShowMessage('Finanzamtsdaten eingetragen.');
end;

procedure TfrmSachkonten.btnSpeichernClick(Sender: TObject);

var
  sPos : String;

begin
  btnAbbrechen.Visible       := false;
  btnSpeichern.Visible       := false;
  btnClose.Visible           := true;
  btnNeu.Visible             := true;
  btnAendern.Visible         := true;
  btnDelete.Visible          := true;
  btnSetFreistellung.Visible := true;

  sPos := inttostr(ediSachkontonummer.Value);

  frmDM.ZQueryHelp.SQL.Text:='insert into konten (kontonr, Name, Sortpos, KontoType, Statistik, Finanzamt, FinanzamtVom, FinanzamtNr, Steuer) values ('+
                              inttostr(ediSachkontonummer.Value)+', "'+
                              ediSachkonto.text+
                              '",'+
                              inttostr(ediSortPos.Value)+', "'+
                              cbKontoType.Text+'", '+
                              inttostr(ediStatistik.Value)+', "'+
                              ediFinanzamt.Text+'", "'+
                              ediFinanzamtVom.Text+'", "'+
                              ediFinanzamtNr.Text+'", "'+
                              cbSteuer.Text+'")';
  try
    frmDM.ZQueryHelp.ExecSQL;
  except
    on E: Exception do LogAndShowError(e.Message);
  end;
  frmDM.ZQuerySachkonten.Refresh;
  frmDM.ZQuerySachkonten.Locate('kontonr', sPos, []);
  AfterScroll;
end;

procedure TfrmSachkonten.btnAendernClick(Sender: TObject);

var
  Bookmark: TBookmark;

begin
  Bookmark := frmDM.ZQuerySachkonten.GetBookmark;
  frmDM.ZQueryHelp.SQL.Text:='Update konten set '+
                             'kontonr='+inttostr(ediSachkontonummer.Value)+', '+
                             'name="'+ediSachKonto.text+'", '+
                             'Sortpos='+inttostr(ediSortPos.Value)+', '+
                             'KontoType="'+cbKontoType.Text+'", '+
                             'Finanzamt="'+ediFinanzamt.text+'", '+
                             'FinanzamtVom="'+ediFinanzamtVom.text+'", '+
                             'FinanzamtNr="'+ediFinanzamtNr.text+'", '+
                             'Steuer="'+cbSteuer.Text+'", '+
                             'Statistik='+inttostr(ediStatistik.Value)+' '+
                             'where kontoNr='+frmDM.ZQuerySachkonten.FieldByName('kontoNr').AsString;
  frmDM.ZQueryHelp.ExecSQL;
  frmDM.ZQuerySachkonten.Refresh;
  frmDM.ZQuerySachkonten.GotoBookmark(Bookmark);
  AfterScroll;
end;

procedure TfrmSachkonten.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmSachkonten.btnAbbrechenClick(Sender: TObject);
begin
  btnAbbrechen.Visible       := false;
  btnSpeichern.Visible       := false;
  btnNeu.Visible             := true;
  btnClose.Visible           := true;
  btnAendern.Visible         := true;
  btnDelete.Visible          := true;
  btnSetFreistellung.Visible := true;
  AfterScroll;
end;

procedure TfrmSachkonten.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('Soll das Sachkonto "'+ ediSachkonto.Text+'" gelöscht werden?', mtConfirmation, [mbYes, mbNo],0) = mrYes
    then
      begin
        frmDM.ZQueryHelp.SQL.Text:='delete from konten where kontonr = '+frmDM.ZQuerySachkonten.FieldByName('kontonr').AsString;
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQuerySachkonten.Refresh;
        AfterScroll;
      end;
end;

procedure TfrmSachkonten.btnHilfeClick(Sender: TObject);

var
  StringList : TStringList;
  sFileName  : String;

begin
  sFileName  := sAppDir+'module\hilfe_sachkonten.txt';
  StringList := TStringList.create;
  try
    StringList.LoadFromFile(sFileName);
  except
    on E: Exception do LogAndShowError(E.Message);
  end;
  frmAusgabe.SetDefaults('Hilfe Sachkonten ('+sFileName+')', StringList.text, sFileName, '', 'Schliessen', false);
  StringList.free;
  frmAusgabe.Show;
end;

procedure TfrmSachkonten.ediSachkontoEnter(Sender: TObject);
begin
  ediSachkonto.SelectAll;
end;

procedure TfrmSachkonten.ediSachkontonummerExit(Sender: TObject);
var
  nHelp: integer;

begin
  nHelp := ediSachkontonummer.Value;
  if nHelp > 999 then nHelp := nHelp div 10;
  ediSortPos.Value   := nHelp;
  ediStatistik.Value := nHelp;
end;


end.

