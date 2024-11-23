program FB4Dtest_con_Imagen;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainForm3 in 'uMainForm3.pas' {MainForm3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm3, MainForm3);
  Application.Run;
end.
