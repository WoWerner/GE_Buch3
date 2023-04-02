// y.ivanov: Here is my small helper unit for Synapse. The password is the sender password (for SMTP).
//https://wiki.lazarus.freepascal.org/Synapse_-_Email_Examples

unit mailsend;
 
{$mode objfpc}{$H+}
 
interface
 
uses
  Classes,
  SysUtils,
  smtpsend;
 
type
 
  { TMySMTPSend }
 
  TMySMTPSend = class(TSMTPSend)
  private
    FSendSize: Integer;
  protected
    function SendToRaw(const AFrom, ATo: String; const AMailData: TStrings): Boolean;
  public
    function SendMessage(AFrom, ATo, ASubject: String; AContent, AAttachments: TStrings): Boolean;
    property SendSize: Integer read FSendSize write FSendSize;
  end;
 
implementation
 
uses
  ssl_openssl,
  mimemess,
  mimepart,
  synautil,
  synachar;
 
{ TMySMTPSend }
 
function TMySMTPSend.SendToRaw(const AFrom, ATo: String; const AMailData: TStrings): Boolean;

var
  S, T: String;

begin
  Result := False;
  if Self.Login then
  begin
    FSendSize := Length(AMailData.Text);
    if Self.MailFrom(GetEmailAddr(AFrom), FSendSize) then
    begin
      S := ATo;
      repeat
        T := GetEmailAddr(Trim(FetchEx(S, ',', '"')));
        if T <> '' then
          Result := Self.MailTo(T);
        if not Result then
          Break;
      until S = '';
      if Result then
        Result := Self.MailData(AMailData);
    end;
    Self.Logout;
  end;
end;
 
function TMySMTPSend.SendMessage(AFrom, ATo, ASubject: String; AContent, AAttachments: TStrings): Boolean;

var
  Mime: TMimeMess;
  P: TMimePart;
  I: Integer;

begin
  Mime := TMimeMess.Create;
  try
    // Set some headers
    Mime.Header.CharsetCode := UTF_8;
    Mime.Header.ToList.Text := ATo;
    Mime.Header.Subject := ASubject;
    Mime.Header.From := AFrom;
 
    // Create a MultiPart part
    P := Mime.AddPartMultipart('mixed', Nil);
 
    // Add as first part the mail text
    Mime.AddPartTextEx(AContent, P, UTF_8, True, ME_8BIT);
 
    // Add all attachments:
    if Assigned(AAttachments) then
      for I := 0 to Pred(AAttachments.Count) do
        Mime.AddPartBinaryFromFile(AAttachments[I], P);
 
    // Compose message
    Mime.EncodeMessage;
 
    // Send using SendToRaw
    Result := Self.SendToRaw(AFrom, ATo, Mime.Lines);
 
  finally
    Mime.Free;
  end;
end;
 
end.
