program MailRuFormatter;

uses
  Winapi.Windows,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  uMain in 'uMain.pas' {fMain};

{$R *.res}

const
  MutexStr = '{105651C1-F352-4A6D-B287-0B4B550C4A2D}';

var
  Mutex: THandle;

function Executed(): BOOL;
begin
  Mutex := OpenMutex(MUTEX_ALL_ACCESS, False, MutexStr);
  Result := (Mutex <> 0);
  if Mutex = 0 then
    Mutex := CreateMutex(nil, False, MutexStr);
end;

begin
  if Executed() then
    Exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.Title := 'MailRuFormatter';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
