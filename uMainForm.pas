unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  FB4D.Interfaces, FB4D.GeminiAI;

type
  TMainForm = class(TForm)
    PromptGrp: TGroupBox;
    PromptMem: TMemo;
    PromptBtn: TButton;
    ResponseGrp: TGroupBox;
    ResponseMem: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure PromptBtnClick(Sender: TObject);
    procedure PromptMemChangeTracking(Sender: TObject);
  private
    fGeminiAI: IGeminiAI;

    procedure GeminiAI_OnGeminiGenContent(Response: IGeminiAIResponse);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

const
  {$I uConstantes.inc}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Instanciamos la clase que se encarga de interactuar con Gemini
  fGeminiAI := TGeminiAI.Create(MY_GEMINI_API_KEY, 'gemini-1.5-pro');
end;

procedure TMainForm.PromptBtnClick(Sender: TObject);
var
  LRequest: IGeminiAIRequest;
begin
  // Creamos la peticion con el texto de la pregunta
  LRequest := TGeminiAIRequest.Create.Prompt(PromptMem.Text);
  // Enviamos la peticion y recibiremos la respuesta en GeminiAI_OnGeminiGenContent
  fGeminiAI.generateContentByRequest(LRequest, GeminiAI_OnGeminiGenContent);
end;

procedure TMainForm.PromptMemChangeTracking(Sender: TObject);
begin
  // Activamos el boton solo cuando hay una pregunta
  PromptBtn.Enabled := not(PromptMem.Text.IsEmpty);
end;

procedure TMainForm.GeminiAI_OnGeminiGenContent(Response: IGeminiAIResponse);
begin
  // Mostramos la respuesta que dio Gemini
  ResponseMem.Lines.Text := Response.RawFormatedJSONResult;
end;

end.
