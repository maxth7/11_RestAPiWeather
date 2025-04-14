object Form1: TForm1
  Left = 81
  Top = 0
  Caption = 'Rest-'#1082#1083#1080#1077#1085#1090
  ClientHeight = 522
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 15
  object GroupBoxLocalServer: TGroupBox
    Left = 359
    Top = 8
    Width = 403
    Height = 511
    Caption = 'Temperature from the local server'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object ChartTemperature: TChart
      Left = 3
      Top = 65
      Width = 397
      Height = 381
      Title.Text.Strings = (
        'Temperatyre')
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
    end
    object DateTimePickerStart: TDateTimePicker
      Left = 3
      Top = 26
      Width = 186
      Height = 33
      Date = 45742.000000000000000000
      Time = 0.799305659718811500
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 214
      Top = 26
      Width = 186
      Height = 33
      Date = 45742.000000000000000000
      Time = 0.799803356479969800
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object ButtonGetLacalData: TButton
      Left = -3
      Top = 452
      Width = 390
      Height = 56
      Caption = 'Show  graph'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = ButtonGetLacalDataClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 345
    Height = 511
    Caption = 'Weather with  https://weatherstack.com/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object Label2: TLabel
      Left = 13
      Top = 27
      Width = 34
      Height = 25
      Caption = 'City'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object MemoWeatheInfo: TMemo
      Left = -3
      Top = 70
      Width = 340
      Height = 376
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Lines.Strings = (
        '')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Button1: TButton
      Left = -11
      Top = 452
      Width = 348
      Height = 56
      Caption = 'Get Weather'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = Button1Click
    end
    object ComboBoxCity: TComboBox
      Left = 72
      Top = 26
      Width = 201
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = 'Moscow'
      OnChange = ComboBoxCityChange
      Items.Strings = (
        'Moscow'
        'New York'
        'Kaluga')
    end
  end
end
