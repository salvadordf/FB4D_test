unit uMainForm2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts, FMX.DialogService, FB4D.Interfaces, FB4D.GeminiAI;

type
  TMainForm2 = class(TForm)
    PromptGrp: TGroupBox;
    PromptBtn: TButton;
    PromptMem: TMemo;
    ResponseGrp: TGroupBox;
    ResponseMem: TMemo;
    PromptLay: TLayout;
    SelectFileDlg: TOpenDialog;
    AttachmentLay: TLayout;
    AttachmentEdt: TEdit;
    SelectBtn: TButton;
    ClearBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PromptBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure PromptMemChangeTracking(Sender: TObject);
  private
    fGeminiAI: IGeminiAI;

    procedure GeminiAI_OnGeminiGenContent(Response: IGeminiAIResponse);
  public
    { Public declarations }
  end;

var
  MainForm2: TMainForm2;

implementation

{$R *.fmx}

const
  {$I uConstantes.inc}

procedure TMainForm2.FormCreate(Sender: TObject);
begin
  // Instanciamos la clase que se encarga de interactuar con Gemini
  fGeminiAI := TGeminiAI.Create(MY_GEMINI_API_KEY, 'gemini-1.5-pro');
end;

procedure TMainForm2.ClearBtnClick(Sender: TObject);
begin
  // Borramos el archivo adjunto
  AttachmentEdt.Text := '';
end;

procedure TMainForm2.PromptBtnClick(Sender: TObject);
var
  LStream : TFileStream;
  LRequest: IGeminiAIRequest;
begin
  LStream := nil;
  try
    try
      // Leemos el archivo adjunto en un flujo (stream)
      LStream := TFileStream.Create(AttachmentEdt.Text, fmOpenRead);
      // Creamos la peticion con el texto de la pregunta y el archivo adjunto.
      LRequest := TGeminiAIRequest.Create.PromptWithMediaData(PromptMem.Text, 'application/pdf', LStream);
      // Enviamos la peticion y recibiremos la respuesta en GeminiAI_OnGeminiGenContent
      fGeminiAI.generateContentByRequest(LRequest, GeminiAI_OnGeminiGenContent);
    except
      TDialogService.ShowMessage('Se produjo un error leyendo el archivo.');
    end;
  finally
    if assigned(LStream) then
      LStream.Free;
  end;
end;

procedure TMainForm2.SelectBtnClick(Sender: TObject);
begin
  // Seleccionamos un archivo que adjuntaremos a la pregunta
  if SelectFileDlg.Execute then
    AttachmentEdt.Text := SelectFileDlg.FileName;
end;

procedure TMainForm2.PromptMemChangeTracking(Sender: TObject);
begin
  // Activamos el boton solo cuando hay una pregunta y un archivo seleccionado
  PromptBtn.Enabled := not(AttachmentEdt.Text.IsEmpty) and not(PromptMem.Text.IsEmpty);
end;

procedure TMainForm2.GeminiAI_OnGeminiGenContent(Response: IGeminiAIResponse);
begin
  // Mostramos la respuesta que dio Gemini
  ResponseMem.Lines.Text := Response.RawFormatedJSONResult;
end;

end.
