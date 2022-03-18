unit banken;

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
  Spin,
  ExtCtrls,
  types;

type

  { TfrmBanken }

  TfrmBanken = class(TForm)
    btnAbbrechen: TButton;
    btnAendern: TButton;
    btnClose: TButton;
    btnDelete: TButton;
    btnHilfe: TButton;
    btnNeu: TButton;
    btnSpeichern: TButton;
    DBGridBankListe: TDBGrid;
    ediName: TEdit;
    ediKontoNr: TSpinEdit;
    ediStatistik: TSpinEdit;
    ediKontostand: TEdit;
    ediSortPos: TSpinEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    procedure btnAbbrechenClick(Sender: TObject);
    procedure btnAendernClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnHilfeClick(Sender: TObject);
    procedure btnNeuClick(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
    procedure DBGridBankListeDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ediNameEnter(Sender: TObject);
    procedure ediKontoNrExit(Sender: TObject);
    procedure ediKontostandEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure AfterScroll;
  end;

var
  frmBanken: TfrmBanken;

implementation

{$R *.lfm}

uses
  global,
  help,
  Ausgabe,
  dm;

{ TfrmBanken }

procedure TfrmBanken.AfterScroll;

begin
  try
    //Hier wegen Query Refresh
    DBGridBankListe.Columns.Items[0].Width        :=  60;    //KontoNr
    DBGridBankListe.Columns.Items[1].Width        :=  60;    //Sortpos
    DBGridBankListe.Columns.Items[2].Width        :=  60;    //Statistik
    DBGridBankListe.Columns.Items[3].Width        := 350;    //Name
    DBGridBankListe.Columns.Items[4].Width        :=  90;    //Kontostand
    DBGridBankListe.Columns.Items[5].Width        :=  90;    //Kontostand
    ediKontoNr.Value   := frmDM.ZQueryBanken.FieldByName('BankNr').AsInteger;
    ediName.Text       := frmDM.ZQueryBanken.FieldByName('Name').AsString;
    ediKontostand.Text := IntToCurrency(frmDM.ZQueryBanken.FieldByName('Kontostand').AsLongint);
    ediSortPos.Value   := frmDM.ZQueryBanken.FieldByName('Sortpos').AsInteger;
    ediStatistik.Value := frmDM.ZQueryBanken.FieldByName('Statistik').AsInteger;
  except
    ediKontoNr.Value   := 0;
    ediName.Text       := '';
    ediKontostand.Text := '';
    ediSortPos.Value   := 0;
    ediStatistik.Value := 0;
  end;

  btnDelete.ShowHint := true;
  btnDelete.Enabled  := true;
  btnAendern.Enabled := btnDelete.Enabled;

  if btnDelete.Enabled
    then
      begin
        frmDM.ZQueryHelp.SQL.Text:='select count(BankNr) as c, max(Buchungsjahr) as m from journal where BankNr='+inttostr(ediKontoNr.Value);
        frmDM.ZQueryHelp.Open;
        try
          if (frmDM.ZQueryHelp.FieldByName('c').AsInteger <> 0)
            then
              begin
                btnDelete.Enabled := false;
                btnDelete.Hint    := 'Konto kann nicht gelöscht werden weil es im Buchungsjahr '+inttostr(frmDM.ZQueryHelp.FieldByName('m').AsInteger)+' noch verwendet wird';
                btnDelete.ShowHint:= true;
              end;
        except

        end;
        frmDM.ZQueryHelp.Close;
      end;
  ediKontostand.Enabled := false;
  ediKontoNr.Enabled    := false;
end;

procedure TfrmBanken.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  btnAbbrechenClick(self);
  frmDM.ZQueryBanken.Close;
end;

procedure TfrmBanken.FormShow(Sender: TObject);
begin
  AfterScroll;
end;

procedure TfrmBanken.DBGridBankListeDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);

begin
  try
    if (Column.FieldName = 'Kontostand') or (Column.FieldName = 'StartSaldo')
      then
        begin
          //den, vom System gezeichneten, Inhalt löschen
          DBGridBankListe.Canvas.FillRect(Rect);
          //eigenen Text reinschreiben
          DBGridBankListe.Canvas.TextRect(Rect,Rect.Left,Rect.Top+2, Format('%m ',[Column.Field.AsLongint/100]));
        end;
  except

  end;
end;

procedure TfrmBanken.btnNeuClick(Sender: TObject);
begin
  btnAbbrechen.Visible := true;
  btnSpeichern.Visible := true;
  btnNeu.Visible       := false;
  btnAendern.Visible   := false;
  btnDelete.Visible    := false;
  btnClose.Visible     := false;
  ediKontoNr.Value      := 199;
  ediKontoNr.Enabled    := true;
  ediName.Text         := 'Name des Kontos';
  ediKontostand.Text   := '0,00';
  ediKontostand.Enabled:= true;
  ediSortPos.Value     := 199;
  ediStatistik.Value   := 11;
  DBGridBankListe.Enabled:=false;
end;

procedure TfrmBanken.btnSpeichernClick(Sender: TObject);

var
  bBankExists: boolean;

begin
  btnAbbrechen.Visible    := false;
  btnSpeichern.Visible    := false;
  btnNeu.Visible          := true;
  btnAendern.Visible      := true;
  btnDelete.Visible       := true;
  btnClose.Visible        := true;
  ediKontostand.Enabled   := false;
  ediKontoNr.Enabled      := false;
  DBGridBankListe.Enabled := true;

  //KontoNr prüfen
  frmDM.ZQueryHelp.SQL.Text:='select count(KontoNr) as c from konten where KontoNr='+inttostr(ediKontoNr.Value);
  frmDM.ZQueryHelp.Open;
  bBankExists := frmDM.ZQueryHelp.FieldByName('c').AsInteger > 0;
  frmDM.ZQueryHelp.Close;

  if bBankExists
    then
      Showmessage('KontoNr existiert bereits. Speichern abgebrochen')
    else
      begin
        frmDM.ZQueryHelp.SQL.Text:='insert into konten (KontoNr, name, kontostand, Sortpos, Statistik, kontotype) values ('+
                                    inttostr(ediKontoNr.Value)+', "'+
                                    ediName.text+'", '+
                                    inttostr(CurrencyToInt(ediKontostand.text, bEuroModus))+', '+
                                    inttostr(ediSortPos.Value)+', '+
                                    inttostr(ediStatistik.Value)+', '+
                                    '"B")';
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQueryHelp.SQL.Text:='insert into BankenAbschluss (KontoNr, Buchungsjahr, Anfangssaldo, Abschlusssaldo) values ('+
                                    inttostr(ediKontoNr.Value)+', '+
                                    inttostr(nBuchungsjahr)+', '+
                                    inttostr(CurrencyToInt(ediKontostand.text, bEuroModus))+
                                    ',0)';
        frmDM.ZQueryHelp.ExecSQL;
      end;
  frmDM.ZQueryBanken.Refresh;
  AfterScroll;
end;

procedure TfrmBanken.btnAendernClick(Sender: TObject);
begin
  frmDM.ZQueryHelp.SQL.Text:='Update konten set '+
                             'Name="'+ediName.text+'", '+
                             'Sortpos='+inttostr(ediSortPos.Value)+', '+
                             'Statistik='+inttostr(ediStatistik.Value)+' '+
                             'where KontoNr='+frmDM.ZQueryBanken.FieldByName('BankNr').AsString;
  frmDM.ZQueryHelp.ExecSQL;
  frmDM.ZQueryBanken.Refresh;
  AfterScroll;
  Showmessage('Die Daten wurden gespeichert');
end;

procedure TfrmBanken.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmBanken.btnAbbrechenClick(Sender: TObject);
begin
  btnAbbrechen.Visible   := false;
  btnSpeichern.Visible   := false;
  btnNeu.Visible         := true;
  btnAendern.Visible     := true;
  btnDelete.Visible      := true;
  btnClose.Visible       := true;
  ediKontostand.Enabled  := false;
  ediKontoNr.Enabled     := false;
  DBGridBankListe.Enabled:= true;
  AfterScroll;
end;

procedure TfrmBanken.btnDeleteClick(Sender: TObject);

var KontoNr : string;

begin
  if MessageDlg('Soll das Konto "'+
                ediName.Text+'" gelöscht werden?', mtConfirmation, [mbYes, mbNo],0) = mrYes
    then
      begin
        KontoNr := frmDM.ZQueryBanken.FieldByName('KontoNr').AsString;
        frmDM.ZQueryHelp.SQL.Text:='delete from konten where KontoNr = '+KontoNr;
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQueryHelp.SQL.Text:='delete from BankenAbschluss where KontoNr = '+KontoNr;
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQueryBanken.Refresh;
        AfterScroll;
      end;
end;

procedure TfrmBanken.btnHilfeClick(Sender: TObject);

var
  StringList : TStringList;
  sFileName  : String;

begin
  sFileName  := sAppDir+'module\hilfe_banken.txt';
  StringList := TStringList.create;
  try
    StringList.LoadFromFile(sFileName);
  except
    on E: Exception do LogAndShowError(E.Message);
  end;
  frmAusgabe.SetDefaults('Hilfe Banken ('+sFileName+')', StringList.text, sFileName, '', 'Schliessen', false);
  StringList.free;
  frmAusgabe.Show;
end;

procedure TfrmBanken.ediNameEnter(Sender: TObject);
begin
  ediName.SelectAll;
end;

procedure TfrmBanken.ediKontoNrExit(Sender: TObject);
begin
  ediSortPos.Value:=ediKontoNr.Value; //Vorschlag
end;


procedure TfrmBanken.ediKontostandEnter(Sender: TObject);
begin
  ediKontostand.SelectAll;
end;


end.

