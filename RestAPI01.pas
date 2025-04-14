unit RestAPI01;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls,
   System.JSON;


type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    MemoWeatheInfo: TMemo;
    Button2: TButton;
    MemoRes: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }

   public
    { Public declarations }

  end;

var
  Form1: TForm1;
  procedure LogMessage(const Msg: string);
  procedure GetWeatherData(const AccessKey: string; const Location: string);
  procedure GetWeatherResources(const AccessKey: string);
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONValue: TJSONValue;
  WeatherInfo: string;
begin
  RESTClient := TRESTClient.Create('https://api.weatherstack.com/current?access_key=0156903bc4b85fa0701a5f9a7e84a1d8&query=Moscow');//New York');
  RESTRequest := TRESTRequest.Create(RESTClient);
  RESTResponse := TRESTResponse.Create(RESTClient);
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;

    // ���������� �������
    RESTRequest.Execute;

    if RESTResponse.StatusCode = 200 then
    begin
      // ��������� JSON-������
      JSONValue := TJSONObject.ParseJSONValue(RESTResponse.Content);
      MemoWeatheInfo.Clear; // ������� Memo ����� ����������� ����� ������
      try
        if Assigned(JSONValue) then
        begin
          // ���������� ���������� � ������
          WeatherInfo := '�����: ' + JSONValue.GetValue<string>('location.name') + sLineBreak +
                         '�����������: ' + JSONValue.GetValue<integer>('current.temperature').ToString + ' �C' + sLineBreak +
                         '��������: ' + JSONValue.GetValue<string>('current.weather_descriptions[0]');

          // ����� ���������� �� �����
          //Label1.Caption := WeatherInfo; // ��� Memo1.Lines.Add(WeatherInfo);
          MemoWeatheInfo.Lines.Add(WeatherInfo);
        end;
      finally
        JSONValue.Free;
      end;
    end
    else
    begin
      Label1.Caption := '������: ' + IntToStr(RESTResponse.StatusCode);
          // �������������
     LogMessage('Response Code: ' + IntToStr(RESTResponse.StatusCode));
     LogMessage('Response Content: ' + RESTResponse.Content);

    end;
  except
    on E: Exception do
      begin
      Label1.Caption := '������: ' + E.Message;
          // �������������
      LogMessage('Response Code: ' + IntToStr(RESTResponse.StatusCode));
      LogMessage('Response Content: ' + RESTResponse.Content);
      end;

  end;
                            // �������������
     LogMessage('Response Code: ' + IntToStr(RESTResponse.StatusCode));
     LogMessage('Response Content: ' + RESTResponse.Content);

  // ������������ ��������
  RESTResponse.Free;
  RESTRequest.Free;
  RESTClient.Free;

end;
    procedure LogMessage(const Msg: string);
var
  LogFile: TextFile;
begin
  AssignFile(LogFile, 'log.txt');
  if FileExists('log.txt') then
    Append(LogFile)
  else
    Rewrite(LogFile);
  Writeln(LogFile, Msg);
  CloseFile(LogFile);
end;
procedure TForm1.Button2Click(Sender: TObject);
begin
 // ������ ������ �������
//  GetWeatherData('0156903bc4b85fa0701a5f9a7e84a1d8', 'New York');
 GetWeatherResources('0156903bc4b85fa0701a5f9a7e84a1d8');

end;

procedure GetWeatherData(const AccessKey: string; const Location: string);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  URL: string;
  //WeatherInfo: string;
begin
  // ������� ���������� �����������
RESTClient := TRESTClient.Create('https://api.weatherstack.com/');
  //  RESTClient := TRESTClient.Create('https://api.weatherstack.com/current?access_key=0156903bc4b85fa0701a5f9a7e84a1d8&query=Moscow');//New York');

  RESTRequest := TRESTRequest.Create(RESTClient);
  RESTResponse := TRESTResponse.Create(RESTClient);

  try
    // ��������� URL ��� �������
    URL := Format('current?access_key=%s&query=%s', [AccessKey, Location]);
    RESTRequest.Resource := URL;

    // ��������� ������
    RESTRequest.Execute;

    // ��������� ������ ������
    if RESTResponse.StatusCode = 200 then
    begin
      // ������� ���������� ������ � MemoRes
      Form1.MemoRes.Clear;
      Form1.MemoRes.Lines.Add(RESTResponse.Content);

    end
    else
    begin
//      Writeln('Error: ' + RESTResponse.StatusText);
     LogMessage('Response Code Resource: ' + IntToStr(RESTResponse.StatusCode));
     LogMessage('Response Content Resource : ' + RESTResponse.Content);

    end;

  finally
    // ����������� �������
    RESTResponse.Free;
    RESTRequest.Free;
    RESTClient.Free;
  end;
end;

procedure GetWeatherResources(const AccessKey: string);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONValue: TJSONValue;
  ResourceList: string;
begin
  RESTClient := TRESTClient.Create('https://api.weatherstack.com/');
  RESTRequest := TRESTRequest.Create(RESTClient);
  RESTResponse := TRESTResponse.Create(RESTClient);
  try
    // ������������� ������ ��� �������
    RESTRequest.Resource := 'resources?access_key=' + AccessKey;

    // ��������� ������
    RESTRequest.Execute;

    // ��������� ������ ������
    if RESTResponse.StatusCode = 200 then
    begin
      // ��������� JSON-������
      JSONValue := TJSONObject.ParseJSONValue(RESTResponse.Content);
      try
        if Assigned(JSONValue) then
        begin
          // ������ ���������� ������ �� JSON
          ResourceList := JSONValue.ToString; // �������� ��������� ������������� JSON
//          MemoOutput.Clear;
//          MemoOutput.Lines.Add(ResourceList); // ������� ������� � Memo
           Form1.MemoRes.Clear;
           Form1.MemoRes.Lines.Add(ResourceList);
        end;
      finally
        JSONValue.Free;
      end;
    end
    else
    begin
      Form1.MemoRes.Lines.Add('������: ' + IntToStr(RESTResponse.StatusCode) + ' - ' + RESTResponse.StatusText);
    end;
  finally
    // ����������� �������
    RESTResponse.Free;
    RESTRequest.Free;
    RESTClient.Free;
  end;
end;

end.
