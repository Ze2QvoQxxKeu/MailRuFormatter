unit uMain;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, System.IniFiles, System.SysUtils,
  System.StrUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  System.RegularExpressions, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin;

type
  TToolButton = class(Vcl.ComCtrls.TToolButton)
  public
    BBIndex: Integer;
  end;

  TfMain = class(TForm)
    FormatBtn: TButton;
    cComment: TCheckBox;
    cApplyAntiFreebie: TCheckBox;
    cApplyAntiAntiSpam: TCheckBox;
    cAntiAntiSpam: TComboBox;
    CopyBtn: TButton;
    PasteBtn: TButton;
    sp: TSplitter;
    cInput: TMemo;
    cOutput: TMemo;
    Lnk: TLinkLabel;
    cSave: TCheckBox;
    tbInput: TToolBar;
    tbOutput: TToolBar;
    procedure FormatBtnClick(Sender: TObject);
    procedure cApplyAntiAntiSpamClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LnkLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
    procedure tbInputBtnClick(Sender: TObject);
    procedure tbOutputBtnClick(Sender: TObject);
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

const
  AAS = 'AntiAntiSpam.txt';
  OPT = 'Settings.ini';
  FIN = 'input.txt';
  FOUT = 'output.txt';
  Name = 'MailRuFormatter';
  OAAS = 'AntiAntiSpam.ID';
  OAFB = 'AntiFreebie.Enabled';
  OAAE = 'AntiAntiSpam.Enabled';
  OCMT = 'FormatAsComment.Enabled';
  OSAVE = 'Save.Enabled';
  OTOP = 'Window.Top';
  OLEFT = 'Window.Left';
  OWIDTH = 'Window.Width';
  OHEIGHT = 'Window.Height';
  OMAXIMIZED = 'Window.Maximized';
  OSPLITTER = 'Window.Splitter';
  
  {BBCODES}
  BBDef =[1, 8, 12];
  BBNop = #32;
  BBCmd = 15;
  BBClr = 15;
  BBTag = 'UUUUUU'#32'SSS'#32'XX'#32'♻';
  BBChr = '̲̳̼͙͟͢'#32'̵̶̴'#32'̷̸'#32'♻';

var
  HOME: string;

function BBCode(var Text: string; var i: Integer): Boolean;
var
  j, x: Integer;
  m: TMatch;
  str, tmp: string;
begin
  Result := False;
  tmp := Copy(Text, i, Length(Text) - i + 1);
  for x := Low(BBTag) to High(BBTag) do
  begin
    m := TRegEx.Match(tmp, Format('^\[%s%d\](.*?)\[\/%s%d\]', [BBTag[x], x - BBTag.IndexOf
      (BBTag[x]), BBTag[x], x - BBTag.IndexOf(BBTag[x])]), [roSingleLine, roIgnoreCase]);
    if (x in BBDef) and (not m.Success) then
      m := TRegEx.Match(tmp, Format('^\[%s\](.*?)\[\/%s\]', [BBTag[x], BBTag[x]]),
        [roSingleLine, roIgnoreCase]);
    if m.Success then
      if m.Index = 1 then
      begin
        Delete(Text, i, m.Length);
        str := EmptyStr;
        for j := 1 to m.Groups[1].Length do
        begin
          str := str + m.Groups[1].Value[j];
          if not CharInSet(m.Groups[1].Value[j], [#13, #10, #9, ' ']) then
            str := str + BBChr[x];
        end;
        Insert(str, Text, i);
        Inc(i, Succ(Length(str)));
        Exit(True);
      end;
  end;
end;

function FormatCode(const Text: string; const Comment: Boolean; const
  AntiFreebie: Boolean; const AntiAntiSpamUrl: string = string.Empty): string;
const
  RXURL =
    '^(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\:\%\?\=\+\-\&\w\.\,\#\*-]*)*\/?';
  _OLD: string = 'aceopxyABCEHKMOPTXасеорхуАВСЕНКМОРТХ';
  _NEW: string = 'асеорхуАВСЕНКМОРТХaceopxyABCEHKMOPTX';
var
  i: Integer;
  m: TMatch;
  Space, tmp: string;
begin
  Space := IfThen(Comment, ' ', '&nbsp;&nbsp;');
  Result := Text;
  while Pos(#32#13, Result) <> 0 do
    Result := StringReplace(Result, #32#13, #13, [rfReplaceAll]);
  while Pos(#32#10, Result) <> 0 do
    Result := StringReplace(Result, #32#10, #10, [rfReplaceAll]);
  i := 1;
  while i <= Length(Result) do
  begin
    case Result[i] of
      '&':
        begin
          Insert('amp;', Result, Succ(i));
          Inc(i, 4);
        end;
      '<':
        begin
          Result[i] := '&';
          Insert('lt;', Result, Succ(i));
          Inc(i, 3);
        end;
      '>':
        begin
          Result[i] := '&';
          Insert('gt;', Result, Succ(i));
          Inc(i, 3);
        end;
      '!':
        begin
          Result[i] := '&';
          Insert('#33;', Result, Succ(i));
          Inc(i, 4);
        end;
    else
      m := TRegEx.Match(Copy(Result, i, Length(Result) - i + 1), RXURL, [roSingleLine,
        roIgnoreCase]);
      if m.Success then
        if m.Index = 1 then
        begin
          Delete(Result, i, m.Length);
          tmp := Format('<a rel="nofollow" href="%s" target="_blank">%s</a>',
            [AntiAntiSpamUrl + m.Value, m.Value]);
          Insert(tmp, Result, i);
          Inc(i, Succ(Length(tmp)));
          Continue;
        end;
      if BBCode(Result, i) then
        Continue;
      if AntiFreebie then
        if Pos(Result[i], _OLD) <> 0 then
          Result[i] := _NEW[Pos(Result[i], _OLD)];
      Inc(i);
    end;
  end;
  Result := StringReplace(Result, #32#32, Space, [rfReplaceAll]);
  Result := StringReplace(Result, #09, Space, [rfReplaceAll]);
end;

procedure CreateToolButtons(ToolBar: TToolBar; Event: TNotifyEvent);
var
  i: Integer;
begin
  for i := Low(BBTag) to High(BBTag) do
    with TToolButton.Create(ToolBar) do
    begin
      if ToolBar.ButtonCount > 0 then
        Left := ToolBar.Buttons[Pred(ToolBar.ButtonCount)].Left + ToolBar.Buttons
          [Pred(ToolBar.ButtonCount)].Width
      else
        Left := 0;
      if BBTag[i] <> BBNop then
      begin
        Style := tbsTextButton;
        if i < BBCmd then
          Caption := BBTag[i] + BBChr[i]
        else
          Caption := BBTag[i];
      end
      else
        Style := tbsDivider;
      AutoSize := True;
      BBIndex := i;
      OnClick := Event;
      Parent := ToolBar;
    end;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
  Wp: TWindowPlacement;
begin
  CreateToolButtons(tbInput, tbInputBtnClick);
  CreateToolButtons(tbOutput, tbOutputBtnClick);
  with TIniFile.Create(HOME + OPT) do
  try
    if FileExists(HOME + AAS) then
      cAntiAntiSpam.Items.LoadFromFile(HOME + AAS)
    else
      cAntiAntiSpam.Items.SaveToFile(HOME + AAS);
    cAntiAntiSpam.ItemIndex := ReadInteger(Name, OAAS, 0);
    cInput.Height := ReadInteger(Name, OSPLITTER, 150);
    cApplyAntiAntiSpam.Checked := ReadBool(Name, OAAE, True);
    cApplyAntiFreebie.Checked := ReadBool(Name, OAFB, False);
    cComment.Checked := ReadBool(Name, OCMT, False);
    Left := ReadInteger(Name, OLEFT, Screen.Width div 2 - Width div 2);
    Top := ReadInteger(Name, OTOP, Screen.Height div 2 - Height div 2);
    Width := ReadInteger(Name, OWIDTH, Width);
    Height := ReadInteger(Name, OHEIGHT, Height);
    ZeroMemory(@Wp, SizeOf(TWindowPlacement));
    Wp.length := SizeOf(TWindowPlacement);
    Wp.rcNormalPosition.Left := Left;
    Wp.rcNormalPosition.Top := Top;
    Wp.rcNormalPosition.Width := Width;
    Wp.rcNormalPosition.Height := Height;
    SetWindowPlacement(Handle, Wp);
    if ReadBool(Name, OMAXIMIZED, False) then
      WindowState := wsMaximized
    else
      WindowState := wsNormal;
    cSave.Checked := ReadBool(Name, OSAVE, False);
    if cSave.Checked then
    begin
      if FileExists(HOME + FIN) then
        cInput.Lines.LoadFromFile(HOME + FIN, TEncoding.UTF8);
      if FileExists(HOME + FOUT) then
        cOutput.Lines.LoadFromFile(HOME + FOUT, TEncoding.UTF8);
    end;
  finally
    Free;
  end;
end;

procedure TfMain.FormDestroy(Sender: TObject);
var
  Wp: TWindowPlacement;
  i: Integer;
begin
  for i := Pred(tbInput.ButtonCount) downto 0 do
    tbInput.Buttons[i].Free;
  for i := Pred(tbOutput.ButtonCount) downto 0 do
    tbOutput.Buttons[i].Free;
  with TIniFile.Create(HOME + OPT) do
  try
    WriteInteger(Name, OAAS, cAntiAntiSpam.ItemIndex);
    WriteInteger(Name, OSPLITTER, cInput.Height);
    Wp.length := SizeOf(TWindowPlacement);
    GetWindowPlacement(Handle, @Wp);
    WriteInteger(Name, OLEFT, Wp.rcNormalPosition.Left);
    WriteInteger(Name, OTOP, Wp.rcNormalPosition.Top);
    WriteInteger(Name, OWIDTH, Wp.rcNormalPosition.Width);
    WriteInteger(Name, OHEIGHT, Wp.rcNormalPosition.Height);
    WriteBool(Name, OMAXIMIZED, WindowState = wsMaximized);
    WriteBool(Name, OAAE, cApplyAntiAntiSpam.Checked);
    WriteBool(Name, OAFB, cApplyAntiFreebie.Checked);
    WriteBool(Name, OCMT, cComment.Checked);
    WriteBool(Name, OSAVE, cSave.Checked);
    if cSave.Checked then
    begin
      cInput.Lines.SaveToFile(HOME + FIN, TEncoding.UTF8);
      cOutput.Lines.SaveToFile(HOME + FOUT, TEncoding.UTF8);
    end
    else
    begin
      if FileExists(HOME + FIN) then
        DeleteFile(HOME + FIN);
      if FileExists(HOME + FOUT) then
        DeleteFile(HOME + FOUT);
    end;
  finally
    Free;
  end;
end;

procedure TfMain.FormPaint(Sender: TObject);
begin
  cAntiAntiSpam.SelStart := Length(cAntiAntiSpam.Text);
  cAntiAntiSpam.SelLength := 0;
end;

procedure TfMain.LnkLinkClick(Sender: TObject; const Link: string; LinkType:
  TSysLinkType);
begin
  ShellExecute(0, 'open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

procedure TfMain.PasteBtnClick(Sender: TObject);
begin
  cInput.SelectAll;
  cInput.PasteFromClipboard;
end;

procedure TfMain.tbInputBtnClick(Sender: TObject);
var
  t: string;
  s, l: Integer;
begin
  with cInput, (Sender as TToolButton) do
  begin
    t := SelText;
    s := SelStart;
    l := SelLength;
    if (BBIndex < BBCmd) and (BBIndex > 0) then
    begin
      if BBTag[BBIndex] <> BBNop then
      begin
        if BBIndex in BBDef then
        begin
          t := Format('[%s]%s[/%s]', [BBTag[BBIndex], t,
            BBTag[BBIndex]]);
          Inc(s, 3);
        end
        else
        begin
          t := Format('[%s%d]%s[/%s%d]', [BBTag[BBIndex], BBIndex -
            BBTag.IndexOf(BBTag[BBIndex]), t, BBTag[BBIndex],
            BBIndex - BBTag.IndexOf(BBTag[BBIndex])]);
          Inc(s, 4);
        end;
      end;
    end
    else if BBIndex = BBClr then
    begin
      t := TRegEx.Replace(t, '\[\/?(U|S|X)\d?\]', '', [roSingleLine, roIgnoreCase]);
      l := t.Length;
    end;
    SelText := t;
    SelStart := s;
    SelLength := l;
  end;
end;

procedure TfMain.tbOutputBtnClick(Sender: TObject);
var
  t: string;
  i, x, s, l: Integer;
begin
  with cOutput, (Sender as TToolButton) do
  begin
    t := SelText;
    s := SelStart;
    l := SelLength;
    if BBTag[BBIndex] <> BBNop then
    begin
      i := 1;
      while i <= t.Length do
      begin
        x := BBChr.IndexOf(t[i]);
        if (t[i] <> BBNop) and (x < BBCmd) and (x > 0) then
          Delete(t, i, 1)
        else
          Inc(i);
      end;
      l := t.Length;
      if (BBIndex < BBCmd) and (BBIndex > 0) then
      begin
        i := 1;
        while i <= t.Length do
        begin
          if not CharInSet(t[i], [#13, #10, #9, ' ']) then
          begin
            Insert(BBChr[BBIndex], t, Succ(i));
            Inc(i, 2);
          end
          else
            Inc(i);
        end;
        l := t.Length;
      end
      else if BBIndex = BBClr then
      begin
       ///
      end;
    end;
    SelText := t;
    SelStart := s;
    SelLength := l;
  end;
end;

procedure TfMain.cApplyAntiAntiSpamClick(Sender: TObject);
begin
  cAntiAntiSpam.Enabled := cApplyAntiAntiSpam.Checked;
end;

procedure TfMain.CopyBtnClick(Sender: TObject);
begin
  cOutput.SelectAll;
  cOutput.CopyToClipboard;
end;

procedure TfMain.FormatBtnClick(Sender: TObject);
begin
  cOutput.Text := FormatCode(Trim(cInput.Text),
    cComment.Checked,
    cApplyAntiFreebie.Checked,
    IfThen(cApplyAntiAntiSpam.Checked, cAntiAntiSpam.Text, EmptyStr));
  cOutput.SelectAll;
end;

initialization
  HOME := ExtractFilePath(ParamStr(0));

end.

