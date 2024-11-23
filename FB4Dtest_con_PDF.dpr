program FB4Dtest_con_PDF;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainForm2 in 'uMainForm2.pas' {MainForm2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm2, MainForm2);
  Application.Run;
end.
