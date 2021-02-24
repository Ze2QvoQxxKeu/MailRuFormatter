object fMain: TfMain
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 230
  Caption = 'MailRuFormatter'
  ClientHeight = 462
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object sp: TSplitter
    Left = 0
    Top = 191
    Width = 527
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 140
  end
  object FormatBtn: TButton
    Left = 0
    Top = 291
    Width = 527
    Height = 25
    Align = alTop
    Caption = #1060#1086#1088#1084#1072#1090#1080#1088#1086#1074#1072#1090#1100
    Default = True
    TabOrder = 0
    OnClick = FormatBtnClick
  end
  object cComment: TCheckBox
    Left = 0
    Top = 274
    Width = 527
    Height = 17
    Align = alTop
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    TabOrder = 1
  end
  object cApplyAntiFreebie: TCheckBox
    Left = 0
    Top = 257
    Width = 527
    Height = 17
    Align = alTop
    Caption = #1040#1085#1090#1080'-'#1050#1086#1087#1080#1087#1072#1089#1090#1072
    TabOrder = 2
  end
  object cApplyAntiAntiSpam: TCheckBox
    Left = 0
    Top = 219
    Width = 527
    Height = 17
    Align = alTop
    Caption = #1040#1085#1090#1080'-'#1040#1085#1090#1080'-'#1057#1087#1072#1084
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = cApplyAntiAntiSpamClick
  end
  object cAntiAntiSpam: TComboBox
    Left = 0
    Top = 236
    Width = 527
    Height = 21
    Align = alTop
    TabOrder = 4
    Text = 'https://4pda.ru/pages/go/?u='
    Items.Strings = (
      'https://4pda.ru/pages/go/?u='
      'http://www.durbetsel.ru/go.php?site='
      'https://anonym.es/?'
      'https://anonymz.com/?'
      
        'https://adguardteam.github.io/AnonymousRedirect/redirect.html?ur' +
        'l='
      'https://nullrefer.com/?'
      'http://dvbpro.ru/goto/'
      'http://www.maultalk.com/go.php?'
      'https://vk.com/away.php?to=')
  end
  object CopyBtn: TButton
    Left = 0
    Top = 437
    Width = 527
    Height = 25
    Align = alBottom
    Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 5
    OnClick = CopyBtnClick
  end
  object PasteBtn: TButton
    Left = 0
    Top = 194
    Width = 527
    Height = 25
    Align = alTop
    Caption = #1042#1089#1090#1072#1074#1080#1090#1100
    TabOrder = 6
    OnClick = PasteBtnClick
  end
  object cInput: TMemo
    Left = 0
    Top = 42
    Width = 527
    Height = 149
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object cOutput: TMemo
    Left = 0
    Top = 335
    Width = 527
    Height = 102
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object Lnk: TLinkLabel
    Left = 0
    Top = 0
    Width = 527
    Height = 19
    Align = alTop
    Alignment = taRightJustify
    Caption = 
      '<a href="https://github.com/Ze2QvoQxxKeu/MailRuFormatter">'#1055#1086#1089#1077#1090#1080 +
      #1090#1100' '#1089#1072#1081#1090'?</a>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    UseVisualStyle = True
    OnLinkClick = LnkLinkClick
    ExplicitWidth = 87
  end
  object cSave: TCheckBox
    Left = 0
    Top = 0
    Width = 150
    Height = 17
    Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1077
    TabOrder = 10
  end
  object tbInput: TToolBar
    Left = 0
    Top = 19
    Width = 527
    Height = 23
    AutoSize = True
    ButtonHeight = 23
    ButtonWidth = 13
    List = True
    AllowTextButtons = True
    TabOrder = 11
  end
  object tbOutput: TToolBar
    Left = 0
    Top = 316
    Width = 527
    Height = 19
    AutoSize = True
    ButtonHeight = 19
    ButtonWidth = 25
    List = True
    AllowTextButtons = True
    TabOrder = 12
  end
end
