unit journal_import_data;

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
  Grids,
  StdCtrls;

type

  { TfrmImportData }

  TfrmImportData = class(TForm)
    labHinweis: TLabel;
    labImportMode: TLabel;
    panCSVImportData: TPanel;
    Panel1: TPanel;
    sgImportData: TStringGrid;
  private

  public
    procedure CheckHeight;
  end;

var
  frmImportData: TfrmImportData;

implementation

{$R *.lfm}

{ TfrmImportData }

procedure TfrmImportData.CheckHeight;

begin
  if labHinweis.Height > 1
    then frmImportData.Height := panCSVImportData.Height + labHinweis.Height + 10
    else frmImportData.Height := panCSVImportData.Height;
end;

end.

