object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 709
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 637
    Height = 25
    Caption = 
      #1076#1072#1085#1085#1099#1077' '#1086' '#1087#1086#1075#1086#1076#1077' '#1089' '#1089#1072#1081#1090#1072' https://weatherstack.com/thank-you-free-' +
      'api'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 31
    Top = 359
    Width = 75
    Height = 25
    Caption = 'Get Weather'
    TabOrder = 0
    OnClick = Button1Click
  end
  object MemoWeatheInfo: TMemo
    Left = 8
    Top = 55
    Width = 297
    Height = 274
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 336
    Top = 359
    Width = 75
    Height = 25
    Caption = 'Get Resources'
    TabOrder = 2
    OnClick = Button2Click
  end
  object MemoRes: TMemo
    Left = 327
    Top = 55
    Width = 298
    Height = 274
    Lines.Strings = (
      'MemoRes')
    TabOrder = 3
  end
end
