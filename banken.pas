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
    ediBank: TEdit;
    ediBankNr: TSpinEdit;
    ediStatistik: TSpinEdit;
    ediKonto: TEdit;
    ediKontostand: TEdit;
    ediSortPos: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
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
    procedure ediBankEnter(Sender: TObject);
    procedure ediBankNrExit(Sender: TObject);
    procedure ediKontoEnter(Sender: TObject);
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
  //Hier wegen Query Refresh
  DBGridBankListe.Columns.Items[0].Width        :=  50;    //BankNr
  DBGridBankListe.Columns.Items[1].Width        := 170;    //Bank
  DBGridBankListe.Columns.Items[2].Width        := 170;    //Konto
  DBGridBankListe.Columns.Items[3].Width        :=  80;    //Kontostand
  DBGridBankListe.Columns.Items[4].Width        :=  50;    //Sortpos
  DBGridBankListe.Columns.Items[5].Width        :=  60;    //Sortpos

  ediBankNr.Value    := frmDM.ZQueryBanken.FieldByName('BankNr').AsInteger;
  ediBank.Text       := frmDM.ZQueryBanken.FieldByName('Bank').AsString;
  ediKonto.Text      := frmDM.ZQueryBanken.FieldByName('Konto').AsString;
  ediKontostand.Text := IntToCurrency(frmDM.ZQueryBanken.FieldByName('Kontostand').AsLongint);
  ediSortPos.Value   := frmDM.ZQueryBanken.FieldByName('Sortpos').AsInteger;
  ediStatistik.Value := frmDM.ZQueryBanken.FieldByName('Statistik').AsInteger;

  btnDelete.ShowHint := true;
  btnDelete.Enabled  := not ((frmDM.ZQueryBanken.FieldByName('BankNr').AsInteger = 1) or
                             (frmDM.ZQueryBanken.FieldByName('BankNr').AsInteger = 999)); //Sammelkonten
  btnAendern.Enabled := btnDelete.Enabled;

  if btnDelete.Enabled
    then
      begin
        frmDM.ZQueryHelp.SQL.Text:='select count(BankNr) as c, max(Buchungsjahr) as m from journal where Banknr='+inttostr(ediBankNr.Value);
        frmDM.ZQueryHelp.Open;
        if (frmDM.ZQueryHelp.FieldByName('c').AsInteger <> 0)
          then
            begin
              btnDelete.Enabled := false;
              btnDelete.Hint    := 'Konto kann nicht gelöscht werden weil es im Buchungsjahr '+inttostr(frmDM.ZQueryHelp.FieldByName('m').AsInteger)+' noch verwendet wird';
              btnDelete.ShowHint:= true;
            end;
        frmDM.ZQueryHelp.Close;
      end;
  ediKontostand.Enabled := false;
  ediBankNr.Enabled     := false;
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
  if Column.FieldName = 'Kontostand'
    then
      begin
        //den, vom System gezeichneten, Inhalt löschen
        DBGridBankListe.Canvas.FillRect(Rect);
        //eigenen Text reinschreiben
        DBGridBankListe.Canvas.TextRect(Rect,Rect.Left+4,Rect.Top+2, Format('€ %m',[Column.Field.AsLongint/100]));
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
  ediBankNr.Value      := 199;
  ediBankNr.Enabled    := true;
  ediBank.Text         := 'NeueBank';
  ediKonto.Text        := 'NeuesKonto';
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
  btnAbbrechen.Visible   := false;
  btnSpeichern.Visible   := false;
  btnNeu.Visible         := true;
  btnAendern.Visible     := true;
  btnDelete.Visible      := true;
  btnClose.Visible       := true;
  ediKontostand.Enabled  := false;
  ediBankNr.Enabled      := false;
  DBGridBankListe.Enabled:= true;

  //BankNr prüfen
  frmDM.ZQueryHelp.SQL.Text:='select count(BankNr) as c from journal where Banknr='+inttostr(ediBankNr.Value);
  frmDM.ZQueryHelp.Open;
  bBankExists := frmDM.ZQueryHelp.FieldByName('c').AsInteger > 0;
  frmDM.ZQueryHelp.Close;

  if bBankExists
    then
      Showmessage('BankNr existiert bereits. Speichern abgebrochen')
    else
      begin
        frmDM.ZQueryHelp.SQL.Text:='insert into banken (banknr, bank, konto, kontostand, Sortpos, Statistik) values ('+
                                    inttostr(ediBankNr.Value)+', "'+
                                    ediBank.text+'", "'+
                                    ediKonto.text+'", '+
                                    inttostr(CurrencyToInt(ediKontostand.text, bEuroModus))+', '+
                                    inttostr(ediSortPos.Value)+', '+
                                    inttostr(ediStatistik.Value)+')';
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQueryHelp.SQL.Text:='insert into BankenAbschluss (BankNr, Buchungsjahr, Anfangssaldo, Abschlusssaldo) values ('+
                                    inttostr(ediBankNr.Value)+', '+
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
  frmDM.ZQueryHelp.SQL.Text:='Update banken set '+
                             'Bank="'+ediBank.text+'", '+
                             'konto="'+ediKonto.text+'", '+
                             'Sortpos='+inttostr(ediSortPos.Value)+', '+
                             'Statistik='+inttostr(ediStatistik.Value)+' '+
                             'where banknr='+frmDM.ZQueryBanken.FieldByName('BankNr').AsString;
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
  ediBankNr.Enabled      := false;
  DBGridBankListe.Enabled:= true;
  AfterScroll;
end;

procedure TfrmBanken.btnDeleteClick(Sender: TObject);

var BankNr : string;

begin
  if MessageDlg('Soll das Konto "'+
                ediKonto.Text +'" bei der Bank "'+
                ediBank.Text+'" gelöscht werden?', mtConfirmation, [mbYes, mbNo],0) = mrYes
    then
      begin
        BankNr := frmDM.ZQueryBanken.FieldByName('BankNr').AsString;
        frmDM.ZQueryHelp.SQL.Text:='delete from banken where banknr = '+BankNr;
        frmDM.ZQueryHelp.ExecSQL;
        frmDM.ZQueryHelp.SQL.Text:='delete from BankenAbschluss where banknr = '+BankNr;
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

procedure TfrmBanken.ediBankEnter(Sender: TObject);
begin
  ediBank.SelectAll;
end;

procedure TfrmBanken.ediBankNrExit(Sender: TObject);
begin
  ediSortPos.Value:=ediBankNr.Value; //Vorschlag
end;

procedure TfrmBanken.ediKontoEnter(Sender: TObject);
begin
  ediKonto.SelectAll;
end;

procedure TfrmBanken.ediKontostandEnter(Sender: TObject);
begin
  ediKontostand.SelectAll;
end;


end.

