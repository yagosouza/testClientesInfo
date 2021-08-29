unit uClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON,
  Data.DB, Datasnap.DBClient, idHTTP, IdSSLOpenSSL, Vcl.DBCtrls,
  IdSMTP, IdMessage, IdText, IdAttachmentFile,
  IdExplicitTLSClientServerBase;

type
  TEndereco = record
    CEP,
    logradouro,
    complemento,
    bairro,
    localidade,
    uf,
    pais : string
  end;

type
  TfClientes = class(TForm)
    LabelNome: TLabel;
    EditNome: TEdit;
    EditIdentidade: TEdit;
    LabelIdentidade: TLabel;
    EditCPF: TEdit;
    LabelCPF: TLabel;
    EditTelefone: TEdit;
    LabelTelefone: TLabel;
    EditEmail: TEdit;
    LabelEmail: TLabel;
    GroupBoxEndereco: TGroupBox;
    ButtonSalvar: TButton;
    ButtonCancelar: TButton;
    LabelCEP: TLabel;
    ButtonBuscarCEP: TButton;
    LabelLogradouro: TLabel;
    LabelNumero: TLabel;
    LabelComplemento: TLabel;
    LabelBairro: TLabel;
    LabelCidade: TLabel;
    LabelPais: TLabel;
    LabelUF: TLabel;
    cds_dados: TClientDataSet;
    cds_dadosCEP: TStringField;
    cds_dadosUF: TStringField;
    cds_dadosBairro: TStringField;
    cds_dadosLocalidade: TStringField;
    cds_dadosLogradouro: TStringField;
    cds_dadosComplemento: TStringField;
    cds_dadosIBGE: TStringField;
    cds_dadosUnidade: TStringField;
    ds_dados: TDataSource;
    EditCEP: TDBEdit;
    EditLogradouro: TDBEdit;
    EditNumero: TDBEdit;
    EditComplemento: TDBEdit;
    EditBairro: TDBEdit;
    EditCidade: TDBEdit;
    EditPais: TDBEdit;
    ComboBoxUF: TDBComboBox;
    ButtonEnviarEmail: TButton;
    procedure ButtonCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure ButtonBuscarCEPClick(Sender: TObject);
    function getDados(params: TEndereco): TJSONObject;
    procedure CarregaDados(JSON: TJSONObject);
    function removerAcentuacao(str: string): string;
    procedure CarregaDadosEndereco(jsonArray: TJSONArray);
    function EnviarEmail(params: TEndereco): Boolean;
    procedure ButtonEnviarEmailClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    var
      dadosEndereco : TEndereco;
    procedure LimpaCampos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fClientes: TfClientes;

implementation

{$R *.dfm}

procedure TfClientes.ButtonEnviarEmailClick(Sender: TObject);
begin
  if Trim(EditEmail.Text) = '' then
    begin
      MessageBox(0, 'É necessário informar o E-mail!', 'Aviso', MB_OK+MB_ICONWARNING+MB_TASKMODAL);
      EditEmail.SetFocus;
      Exit;
    end;

  EnviarEmail(dadosEndereco);
end;

procedure TfClientes.LimpaCampos;
begin
  EditNome.Clear;
  EditIdentidade.Clear;
  EditCPF.Clear;
  EditTelefone.Clear;
  EditEmail.Clear;
  EditCEP.Clear;
  EditLogradouro.Clear;
  EditNumero.Clear;
  EditComplemento.Clear;
  EditBairro.Clear;
  EditCidade.Clear;
  ComboBoxUF.Clear;
  EditPais.Clear;
end;

procedure TfClientes.ButtonBuscarCEPClick(Sender: TObject);
var
  jsonObject: TJSONObject;
begin
  EditLogradouro.Clear;
  EditBairro.Clear;
  EditCidade.Clear;
  ComboBoxUF.Clear;
  EditComplemento.Clear;

  if Length(EditCEP.Text) <> 8 then
    begin
      MessageBox(0, 'CEP inválido', 'Aviso', MB_OK+MB_ICONWARNING+MB_TASKMODAL);
      EditCEP.SetFocus;
      Exit;
    end;

  dadosEndereco.CEP := EditCEP.text;

  jsonObject := getDados(dadosEndereco);

  if jsonObject <> nil then
    CarregaDados(jsonObject)
  else
    begin
      MessageBox(0, 'CEP inválido ou não encontrado', 'Aviso', MB_OK+MB_ICONWARNING+MB_TASKMODAL);
      EditCEP.SetFocus;
      Exit;
    end;
end;

procedure TfClientes.ButtonCancelarClick(Sender: TObject);
begin
  LimpaCampos;

  Close;
end;

procedure TfClientes.ButtonSalvarClick(Sender: TObject);
begin
  if Trim(EditNome.Text) = ''  then
    begin
      MessageBox(0, 'É necessário informar o nome!', 'Aviso', MB_OK+MB_ICONWARNING+MB_TASKMODAL);
      EditNome.SetFocus;
      Exit;
    end;

  Close;
end;

procedure TfClientes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfClientes.FormShow(Sender: TObject);
begin
  LimpaCampos;
end;

function TfClientes.getDados(params: TEndereco): TJSONObject;
var
  HTTP: TIdHTTP;
  IDSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  Response: TStringStream;
  JsonArray: TJSONArray;
  Memo_json : TMemo;
begin
  try
    Memo_json := TMemo.Create(Self);
    HTTP := TIdHTTP.Create;
    IDSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create;

    HTTP.IOHandler := IDSSLHandler;
    Response := TStringStream.Create('');

    HTTP.Get('http://viacep.com.br/ws/' + params.CEP + '/json', Response);
    if (HTTP.ResponseCode = 200) and not (UTF8ToString(Response.DataString) = '{'#$A'  "erro": true'#$A'}') then
      begin
        Memo_json.Text := UTF8ToString(Response.DataString);
        Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(UTF8ToString(Response.DataString)), 0) as TJSONObject;
      end
    else
      raise Exception.Create('CEP inexistente!');

  finally
    FreeAndNil(HTTP);
    FreeAndNil(IDSSLHandler);
    FreeAndNil(Memo_json);
    Response.Destroy;
  end;
end;

procedure TfClientes.CarregaDados(JSON: TJSONObject);
begin
  try
    cds_dados.Append;
    cds_dadosLogradouro.AsString  := JSON.Get('logradouro').JsonValue.Value;
    cds_dadosCEP.AsString         := JSON.Get('cep').JsonValue.Value;
    cds_dadosLocalidade.AsString  := UpperCase(JSON.Get('localidade').JsonValue.Value);
    cds_dadosBairro.AsString      := JSON.Get('bairro').JsonValue.Value;
    cds_dadosUF.AsString          := JSON.Get('uf').JsonValue.Value;
    cds_dadosComplemento.AsString := JSON.Get('complemento').JsonValue.Value;
    cds_dadosIBGE.AsString        := JSON.Get('ibge').JsonValue.Value;
    cds_dados.Post;

  except
    on e: Exception do
    begin
      Application.MessageBox(PChar('Ocorreu um erro ao consultar o CEP'), 'Erro', MB_OK + MB_ICONERROR);
    end;
  end;
end;

function TfClientes.removerAcentuacao(str: string): string;
var
  x: Integer;
const
  ComAcento = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
begin
  for x := 1 to Length(Str) do

    if Pos(Str[x], ComAcento) <> 0 then
      Str[x] := SemAcento[Pos(Str[x], ComAcento)];

  Result := Str;
end;

procedure TfClientes.CarregaDadosEndereco(jsonArray: TJSONArray);
var
  i : Integer;
  resultados, jsonObjeto : TJSONObject;
begin
  cds_dados.DisableControls;

  try
    for i := 0 to jsonArray.Size - 1 do
    begin
      cds_dados.Append;
      cds_dadosLogradouro.AsString  := TJSONObject(jsonArray.Get(i)).Get('logradouro').JsonValue.Value;
      cds_dadosCEP.AsString         := TJSONObject(jsonArray.Get(i)).Get('cep').JsonValue.Value;
      cds_dadosLocalidade.AsString  := UpperCase(TJSONObject(jsonArray.Get(0)).Get('localidade').JsonValue.Value);
      cds_dadosBairro.AsString      := TJSONObject(jsonArray.Get(i)).Get('bairro').JsonValue.Value;
      cds_dadosUF.AsString          := TJSONObject(jsonArray.Get(i)).Get('uf').JsonValue.Value;
      cds_dadosComplemento.AsString := TJSONObject(jsonArray.Get(i)).Get('complemento').JsonValue.Value;
      cds_dadosIBGE.AsString        := TJSONObject(jsonArray.Get(i)).Get('ibge').JsonValue.Value;
      cds_dadosUnidade.AsString     := TJSONObject(jsonArray.Get(i)).Get('unidade').JsonValue.Value;
      cds_dados.Post;
    end;
  finally
    cds_dados.First;
    cds_dados.EnableControls;
  end;

end;

function TfClientes.EnviarEmail(params: TEndereco): Boolean;
var
  // variáveis e objetos necessários para o envio
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  sAnexo: string;
begin
  // instanciação dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  IdSMTP := TIdSMTP.Create(Self);
  IdMessage := TIdMessage.Create(Self);

  try
    // Configuração do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

    // Configuração do servidor SMTP (TIdSMTP)
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.UseTLS := utUseExplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := 587;
    IdSMTP.Host := 'smtp.live.com';
    IdSMTP.Username := 'yago_testeenvio@hotmail.com';
    IdSMTP.Password := '1q2w3e4r5t6y';

    // Configuração da mensagem (TIdMessage)
    IdMessage.From.Name := 'Info Sistemas';
    IdMessage.From.Address := IdSMTP.Username;
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := EditEmail.Text;
    IdMessage.Subject := 'Dados Cadastrais ' + EditNome.Text + ' ' + DateToStr(Now);
    IdMessage.Encoding := meMIME;

    // Configuração do corpo do email (TIdText)
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add('Dados do cadastro de Clientes (Info SistemaS)');
    IdText.Body.Add('');
    IdText.Body.Add('Inf. Pessoais');
    IdText.Body.Add('');
    IdText.Body.Add('Nome: ' +  EditNome.Text);
    IdText.Body.Add('Identidade: ' +  EditIdentidade.Text + ' CPF: ' + EditCPF.Text);
    IdText.Body.Add('Telefone: ' +  EditTelefone.Text);
    IdText.Body.Add('E-mail: ' +  EditEmail.Text);
    IdText.Body.Add('');
    IdText.Body.Add('Dados de Endereço');
    IdText.Body.Add('');
    IdText.Body.Add('CEP: ' + EditCEP.Text);
    IdText.Body.Add('Logradouro : ' +  EditLogradouro.Text);
    IdText.Body.Add('Numero: ' + EditNumero.Text + ' Complemento: ' + EditComplemento.Text);
    IdText.Body.Add('Bairro: ' + EditBairro.Text);
    IdText.Body.Add('Cidade: ' + EditCidade.Text +  '/'  + ComboBoxUF.Text);
    IdText.Body.Add('País:   ' + EditPais.Text);
    IdText.Body.Add('');
    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    // Opcional - Anexo da mensagem (TIdAttachmentFile)
    {sAnexo := 'C:\teste.txt';
    if FileExists(sAnexo) then
    begin
      TIdAttachmentFile.Create(IdMessage.MessageParts, sAnexo);
    end;     }

    // Conexão e autenticação
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conexão ou autenticação: ' +
          E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
    except
      On E:Exception do
      begin
        MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  finally
    // desconecta do servidor
    IdSMTP.Disconnect;
    // liberação da DLL
    UnLoadOpenSSLLibrary;
    // liberação dos objetos da memória
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;

end.
