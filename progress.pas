unit Progress;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls;

type

  { TfrmProgress }

  TfrmProgress = class(TForm)
    labMessage: TLabel;
    ProgressBar: TProgressBar;
  private

  public

  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.lfm}

end.

