program PrWeatherstack;

uses
  Vcl.Forms,
  Restweatherstack01 in 'Restweatherstack01.pas' {Form1},
  UnitTchart in 'UnitTchart.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
