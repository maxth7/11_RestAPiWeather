unit Restweatherstack01;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls,
  System.JSON, VclTee.TeeGDIPlus, VCLTee.TeEngine, Vcl.ExtCtrls,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.ComCtrls,
  VclTee.Series,REST.Types, Data.DB,
  System.DateUtils,
    IdHTTP, IdException;
  const
  DataSize = 100;
  MSG_FILE_LOG='log.txt';

  URL_WEATHERSTACK = 'https://api.weatherstack.com';
  ACCESS_KEY='bb0fb71658c0d0921b33c841523ed161';
  URL_LOCAL_SERVER='http://localhost:8080/';
  MSG_SERVER_NOT_RUNNING = 'The server is not running or unavailable.';//'Сервер не запущен или недоступен.'
var
DataTemp:   array[0..DataSize - 1] of Double;


type
  TForm1 = class(TForm)
    GroupBoxLocalServer: TGroupBox;
    ChartTemperature: TChart;
    DateTimePickerStart: TDateTimePicker;
    DateTimePickerEnd: TDateTimePicker;
    ButtonGetLacalData: TButton;
    GroupBox1: TGroupBox;
    MemoWeatheInfo: TMemo;
    Button1: TButton;
    ComboBoxCity: TComboBox;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ButtonGetLacalDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxCityChange(Sender: TObject);

  private
    { Private declarations }
  procedure GetWeatherResources(const URL: string);

   procedure PlotWeatherData(const Data: TArray<Double>);
   procedure GetTemperatureData(const DateRequested: string);
   function makeDateRequested(StartDate, EndDate: TDateTime): string;
   procedure GetAraayTemperatureForChart(RESTResponseContent: string);

   function IsServerRunning(const URL: string): Boolean;
   public
    { Public declarations }
   end;

var
  Form1: TForm1;
  DataCurrentSize:integer;

  procedure LogMessage(const Msg: string);


implementation
uses
 UnitTchart;

{$R *.dfm}

procedure LogMessage(const Msg: string);
var
  LogFile: TextFile;
begin
  AssignFile(LogFile, MSG_FILE_LOG);
  if FileExists(MSG_FILE_LOG) then
    Append(LogFile)
  else
    Rewrite(LogFile);
  Writeln(LogFile, Msg);
  CloseFile(LogFile);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 SelectedIndex: Integer;
 SelectedItem: string;
 AccessKey:string;
 URL: string;
begin
 SelectedIndex := ComboBoxCity.ItemIndex;

  if SelectedIndex <> -1 then
  begin
    SelectedItem := Trim(ComboBoxCity.Items[SelectedIndex]);

  end
  else
    begin
    ShowMessage('Please select an item from the list.');
  end;
    URL := Format(URL_WEATHERSTACK+'current?access_key=%s&query=%s', [ACCESS_KEY, SelectedItem]);
  if IsServerRunning(URL) then
  begin
    GetWeatherResources(URL);
  end
    else
  begin
    ShowMessage(MSG_SERVER_NOT_RUNNING);
  end;
end;

function TForm1.makeDateRequested(StartDate, EndDate: TDateTime): string;
  var
    StartDate1, EndDate1: string;
begin
       StartDate1:=FormatDateTime('yyyy-mm-dd', StartDate) ;
       EndDate1:=FormatDateTime('yyyy-mm-dd', EndDate);
     Result:=URL_LOCAL_SERVER
              +StartDate1+'/'
              +EndDate1;
end;

procedure TForm1.ButtonGetLacalDataClick(Sender: TObject);
var
URL: string;
UrlChecking:string;
begin
 URL:=makeDateRequested(DateTimePickerStart.Date,
                        DateTimePickerEnd.Date);
 UrlChecking:=URL_LOCAL_SERVER+'Checking the server';
if IsServerRunning(UrlChecking) then
  begin
 GetTemperatureData(URL);
 DrawTemperatureChart(ChartTemperature, DataTemp, DataCurrentSize);
  end
    else
  begin
    ShowMessage(MSG_SERVER_NOT_RUNNING);
  end;
end;

procedure TForm1.ComboBoxCityChange(Sender: TObject);
begin
     MemoWeatheInfo.Clear;
end;

procedure TForm1.GetTemperatureData(const DateRequested: string);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  URL: string;
begin
   URL := DateRequested;
  RESTClient := TRESTClient.Create(URL);
  try
    RESTRequest := TRESTRequest.Create(RESTClient);
    RESTResponse := TRESTResponse.Create(RESTClient);
    try
      RESTRequest.Response := RESTResponse;
      RESTRequest.Method := rmGET;
      RESTRequest.Execute;
      if RESTResponse.StatusCode = 200 then
      begin
          GetAraayTemperatureForChart(RESTResponse.Content);
          MemoWeatheInfo.Lines.Add(RESTResponse.Content);
      end
      else
      begin
      end;
    finally
      RESTRequest.Free;
      RESTResponse.Free;
    end;
  finally
    RESTClient.Free;
  end;
end;

procedure TForm1.GetWeatherResources(const URL: string);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONValue: TJSONValue;
  CurrentWeather: TJSONObject;
  AirQuality: TJSONObject;
  LocationData: TJSONObject;
begin
  RESTClient := TRESTClient.Create(URL);
  RESTRequest := TRESTRequest.Create(RESTClient);
  RESTResponse := TRESTResponse.Create(RESTClient);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
    begin
      JSONValue := TJSONObject.ParseJSONValue(RESTResponse.Content);
      LogMessage('All Response Content: ' + RESTResponse.Content);
      try
        if Assigned(JSONValue) then
        begin
       CurrentWeather := JSONValue.GetValue<TJSONObject>('current');
      MemoWeatheInfo.Clear;
      MemoWeatheInfo.Lines.Add('Observation Time: ' + CurrentWeather.GetValue<string>('observation_time'));
      MemoWeatheInfo.Lines.Add('Temperature: ' + CurrentWeather.GetValue<string>('temperature') + ' °C');
      MemoWeatheInfo.Lines.Add('Weather Descriptions: ' + CurrentWeather.GetValue<TJSONArray>('weather_descriptions').Items[0].Value);
      MemoWeatheInfo.Lines.Add('Sunrise: ' + CurrentWeather.GetValue<TJSONObject>('astro').GetValue<string>('sunrise'));
      MemoWeatheInfo.Lines.Add('Sunrise: ' + CurrentWeather.GetValue<TJSONObject>('astro').GetValue<string>('sunrise'));
      MemoWeatheInfo.Lines.Add('Wind Speed: ' + CurrentWeather.GetValue<string>('wind_speed') + ' km/h');
      MemoWeatheInfo.Lines.Add('Wind Degree: ' + CurrentWeather.GetValue<string>('wind_degree'));
      MemoWeatheInfo.Lines.Add('Pressure: ' + CurrentWeather.GetValue<string>('pressure') + ' hPa');
      MemoWeatheInfo.Lines.Add('Precipitation: ' + CurrentWeather.GetValue<string>('precip') + ' mm');
      MemoWeatheInfo.Lines.Add('Humidity: ' + CurrentWeather.GetValue<string>('humidity') + ' %');
      MemoWeatheInfo.Lines.Add('Cloud Cover: ' + CurrentWeather.GetValue<string>('cloudcover') + ' %');
      MemoWeatheInfo.Lines.Add('Feels Like: ' + CurrentWeather.GetValue<string>('feelslike') + ' °C');
      MemoWeatheInfo.Lines.Add('UV Index: ' + CurrentWeather.GetValue<string>('uv_index'));
      MemoWeatheInfo.Lines.Add('Visibility: ' + CurrentWeather.GetValue<string>('visibility') + ' km');
      MemoWeatheInfo.Lines.Add('Is Day: ' + CurrentWeather.GetValue<string>('is_day'));
      MemoWeatheInfo.Lines.Add('Показатели качества воздуха:');
      AirQuality := JSONValue.GetValue<TJSONObject>('current').GetValue<TJSONObject>('air_quality');
      MemoWeatheInfo.Lines.Add('Air Quality:');
      MemoWeatheInfo.Lines.Add('CO: ' + AirQuality.GetValue<string>('co'));
      MemoWeatheInfo.Lines.Add('NO2: ' + AirQuality.GetValue<string>('no2'));
      MemoWeatheInfo.Lines.Add('O3: ' + AirQuality.GetValue<string>('o3'));
      MemoWeatheInfo.Lines.Add('SO2: ' + AirQuality.GetValue<string>('so2'));
      MemoWeatheInfo.Lines.Add('PM2.5: ' + AirQuality.GetValue<string>('pm2_5'));
      MemoWeatheInfo.Lines.Add('PM10: ' + AirQuality.GetValue<string>('pm10'));
      MemoWeatheInfo.Lines.Add('US EPA Index: ' + AirQuality.GetValue<string>('us-epa-index'));
      MemoWeatheInfo.Lines.Add('GB DEFRA Index: ' + AirQuality.GetValue<string>('gb-defra-index'));


      LocationData := JSONValue.GetValue<TJSONObject>('location');

          if Assigned(LocationData) then
          begin
            MemoWeatheInfo.Lines.Add('Location: ' + LocationData.GetValue<string>('name'));
            MemoWeatheInfo.Lines.Add('Country: ' + LocationData.GetValue<string>('country'));
            MemoWeatheInfo.Lines.Add('Region: ' + LocationData.GetValue<string>('region'));
            MemoWeatheInfo.Lines.Add('Latitude: ' + LocationData.GetValue<string>('lat'));
            MemoWeatheInfo.Lines.Add('Longitude: ' + LocationData.GetValue<string>('lon'));
            MemoWeatheInfo.Lines.Add('Timezone: ' + LocationData.GetValue<string>('timezone_id'));
            MemoWeatheInfo.Lines.Add('Local Time: ' + LocationData.GetValue<string>('localtime'));
          end
          else
            ShowMessage('Location data not found in the response.');

    end;
      finally
        JSONValue.Free;
      end;
    end
    else
    begin
     LogMessage('Response Code: ' + IntToStr(RESTResponse.StatusCode));
     LogMessage('Response Content: ' + RESTResponse.Content);
    end;
  except
    on E: Exception do
      begin
      LogMessage('Response Code: ' + IntToStr(RESTResponse.StatusCode));
      LogMessage('Response Content: ' + RESTResponse.Content);
      end;

  end;
     LogMessage('Response Code: ' + IntToStr(RESTResponse.StatusCode));
     LogMessage('Response Content: ' + RESTResponse.Content);
  RESTResponse.Free;
  RESTRequest.Free;
  RESTClient.Free;

end;
procedure TForm1.PlotWeatherData(const Data: TArray<Double>);
var
  i: Integer;
  Series: TLineSeries;
begin
  ChartTemperature.SeriesList.Clear;
  Series := TLineSeries.Create(ChartTemperature);
  ChartTemperature.AddSeries(Series);

  for i := 0 to High(Data) do
  begin
    Series.AddXY(i, Data[i]);
  end;

  ChartTemperature.Axes.Bottom.Title.Caption := 'Days';
  ChartTemperature.Axes.Left.Title.Caption := 'Temperature (°C)';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        ComboBoxCity.ItemIndex := 0;
        MemoWeatheInfo.Clear;
end;

procedure  TForm1.GetAraayTemperatureForChart(RESTResponseContent: string);
     var
  Data: array of Double;
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
  i: Integer;
begin
  JSONValue := TJSONObject.ParseJSONValue(RESTResponseContent);
  try
    if JSONValue is TJSONObject then
    begin
      JSONArray := (JSONValue as TJSONObject).GetValue<TJSONArray>('temperatures');
      DataCurrentSize := JSONArray.Count;
      SetLength(Data, DataSize);
      for i := 0 to DataCurrentSize - 1 do
      begin
        DataTemp[i] := StrToFloat(JSONArray.Items[i].Value);
      end;
    end;
  finally
    JSONValue.Free;
  end;
end;
function TForm1.IsServerRunning(const URL: string): Boolean;
var
  IdHTTP: TIdHTTP;
  Response: string;
begin
  Result := False;
  IdHTTP := TIdHTTP.Create(nil);
  try
    try
      Response := IdHTTP.Get(URL);
      Result := True;
    except
      on E: EIdHTTPProtocolException do
      begin
       MemoWeatheInfo.Lines.Add('HTTP Error: ' + E.Message);
      end;
      on E: EIdConnClosedGracefully do
      begin
         MemoWeatheInfo.Lines.Add('Connection closed gracefully: ' + E.Message);
      end;
      on E: Exception do
      begin
        MemoWeatheInfo.Lines.Add('Error: ' + E.Message);
      end;
    end;
  finally
    IdHTTP.Free;
  end;
end;

end.
