unit FormularioCadastroClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON, Vcl.Mask,
  XMLDoc, XMLIntf, IdMessage, IniFiles, IdText, IdSMTP,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdAttachmentFile,
  IPPeerClient, Data.Bind.Components, Data.Bind.ObjectScope, REST.Client,
  REST.Response.Adapter, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Datasnap.DSClientRest, Rest.Types;

type
  TFormCadastroClientes = class(TForm)
    btnCEP: TButton;
    edtCEP: TMaskEdit;
    edtNome: TEdit;
    edtIdentidade: TEdit;
    edtCPF: TMaskEdit;
    edtTelefone: TMaskEdit;
    edtEmail: TEdit;
    edtLogradouro: TEdit;
    edtNumero: TMaskEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtPais: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    btnConfirma: TButton;
    btnSair: TButton;
    FDMemTable1: TFDMemTable;
    procedure btnCEPClick(Sender: TObject);
    procedure btnConfirmaClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
    procedure GravarXML;
    procedure EnviarEmail;
    function  PrepararBody : String;
    function ObterJsonREST : String;
  public
    { Public declarations }
  end;

var
  FormCadastroClientes: TFormCadastroClientes;

implementation

{$R *.dfm}

procedure TFormCadastroClientes.btnCEPClick(Sender: TObject);
var varValor : TJSonValue;
begin
  if (Trim(edtCEP.Text) = '') then
    MessageDlg('O CEP precisa ser informado.', mtInformation, [mbOK], 0)
  else
  begin
    varValor := TJSonObject.ParseJSONValue(ObterJsonREST);

    try
      edtCidade.Text := varValor.GetValue<string>('data.results[0].localidade');
      edtBairro.Text := varValor.GetValue<string>('data.results[0].bairro');
      edtEstado.Text := varValor.GetValue<string>('data.results[0].uf');
    except
      Application.MessageBox(PChar('CEP inválido.'),'Atenção',MB_OK + MB_ICONINFORMATION);
    end;

    varValor.Free;
    end;
end;

function TFormCadastroClientes.ObterJsonREST : String;
var varRESTClient1: TRESTClient;
    varRESTRequest1: TRESTRequest;
    varRESTResponse1: TRESTResponse;
    varREstResponseDataSetAdapter1 : TRESTResponseDataSetAdapter;
begin
  varRESTClient1 := TRESTClient.Create(Nil);
  varRESTClient1.BaseURL := 'http://viacep.com.br/ws/' + edtCEP.text + '/json/';

  varRESTRequest1  := TRESTRequest.Create(Nil);
  varRESTResponse1 := TRESTResponse.Create(Nil);

  varRESTRequest1.Client   := varRESTClient1;
  varRESTRequest1.Response := varRESTResponse1;

  varRESTRequest1.Execute;
  if FDMemTable1 <> Nil then
  begin
    varREstResponseDataSetAdapter1 := TRESTResponseDataSetAdapter.Create(Nil);
    varREstResponseDataSetAdapter1.Dataset  := FDMemTable1;
    varREstResponseDataSetAdapter1.Response := varRESTResponse1;
    varRESTResponseDataSetAdapter1.Active   := True;
  end;

  Result := '{"data":{"results":[' + varRESTResponse1.Content + ']}}';
end;

procedure TFormCadastroClientes.GravarXML;
var varXMLDocument: TXMLDocument;
    varNodePrincipal, varNodeRegistro, varNodeEndereco: IXMLNode;
begin
  varXMLDocument := TXMLDocument.Create(Self);
  try
    varXMLDocument.Active := True;
    varNodePrincipal := varXMLDocument.AddChild('Cliente');

    varNodeRegistro := varNodePrincipal.AddChild('DadosPessoais');
    varNodeRegistro.ChildValues['Nome']       := edtNome.Text;
    varNodeRegistro.ChildValues['Identidade'] := edtIdentidade.Text;
    varNodeRegistro.ChildValues['CPF']        := edtCPF.Text;
    varNodeRegistro.ChildValues['Telefone']   := edtTelefone.Text;
    varNodeRegistro.ChildValues['Email']      := edtEmail.Text;

    varNodeEndereco := varNodeRegistro.AddChild('Endereco');
    varNodeEndereco.ChildValues['CEP']         := edtCEP.Text;
    varNodeEndereco.ChildValues['Logradouro']  := edtLogradouro.Text;
    varNodeEndereco.ChildValues['Numero']      := edtNumero.Text;
    varNodeEndereco.ChildValues['Complemento'] := edtComplemento.Text;
    varNodeEndereco.ChildValues['Bairro']      := edtBairro.Text;
    varNodeEndereco.ChildValues['Cidade']      := edtCidade.Text;
    varNodeEndereco.ChildValues['Estado']      := edtEstado.Text;
    varNodeEndereco.ChildValues['Pais']        := edtPais.Text;

    varXMLDocument.SaveToFile('C:\Desenvolvimento\InfoSis\Cliente.xml');
  finally
    varXMLDocument.Free;
  end;
end;

procedure TFormCadastroClientes.btnConfirmaClick(Sender: TObject);
begin
  if (Application.MessageBox(PChar('Confirma o cadastro?'),'Confirmação',MB_YESNO + MB_ICONQUESTION) = IDYES) then
  begin
    GravarXML;
    EnviarEmail;
  end;
end;

procedure TFormCadastroClientes.EnviarEmail;
var varIdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    varIdSMTP: TIdSMTP;
    varIdMessage: TIdMessage;
    varIdText: TIdText;
    varAnexo: string;
begin
  varIdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  varIdSMTP := TIdSMTP.Create(Self);
  varIdMessage := TIdMessage.Create(Self);

  try
    varIdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    varIdSSLIOHandlerSocket.SSLOptions.Mode   := sslmClient;

    varIdSMTP.IOHandler := varIdSSLIOHandlerSocket;
    varIdSMTP.UseTLS    := utUseImplicitTLS;
    varIdSMTP.AuthType  := satDefault;
    varIdSMTP.Port      := 465;
    varIdSMTP.Host      := 'smtp.mail.yahoo.com';
    varIdSMTP.Username  := 'juliocortescoelho@yahoo.com';
    varIdSMTP.Password  := 'yyysurmuixrhgkaq';

    varIdMessage.From.Address           := 'juliocortescoelho@yahoo.com';
    varIdMessage.From.Name              := 'Júlio Coelho';
    varIdMessage.ReplyTo.EMailAddresses := varIdMessage.From.Address;
    varIdMessage.Recipients.Add.Text    := 'juliocortescoelho@yahoo.com';
    varIdMessage.Subject                := 'Processo de Seleção - Info';
    varIdMessage.Encoding               := meMIME;

    varIdText := TIdText.Create(varIdMessage.MessageParts);
    varIdText.Body.Add(PrepararBody);
    varIdText.ContentType := 'text/plain; charset=iso-8859-1';

    varAnexo := 'C:\Desenvolvimento\InfoSis\Teste.xml';
    if FileExists(varAnexo) then
    begin
      TIdAttachmentFile.Create(varIdMessage.MessageParts, varAnexo);
    end;

    try
      Screen.Cursor := crHourGlass;
      varIdSMTP.Connect;
      varIdSMTP.Authenticate;
      Screen.Cursor := crArrow;
    except
      on E:Exception do
      begin
        MessageDlg('Erro de conexão ou autenticação: ' +
        E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    try
      varIdSMTP.Send(varIdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
    except
      On E:Exception do
      begin
        MessageDlg('Erro ao enviar a mensagem: ' +
        E.Message, mtWarning, [mbOK], 0);
      end;
    end;

  finally
    varIdSMTP.Disconnect;
    UnLoadOpenSSLLibrary;
    FreeAndNil(varIdMessage);
    FreeAndNil(varIdSSLIOHandlerSocket);
    FreeAndNil(varIdSMTP);
  end;
end;

function TFormCadastroClientes.PrepararBody: String;
var varBody : String;
begin
  varBody := 'Informações do Cliente '             + #13 + #13 +
             'Nome: '        + edtNome.Text        + #13 +
             'Identidade: '  + edtIdentidade.Text  + #13 +
             'CPF: '         + edtCPF.Text         + #13 +
             'Telefone: '    + edtTelefone.Text    + #13 +
             'Emai: '        + edtEmail.Text       + #13 +
             'CEP: '         + edtCEP.Text         + #13 +
             'Logradouro: '  + edtLogradouro.Text  + #13 +
             'Número: '      + edtNumero.Text      + #13 +
             'Complemento: ' + edtComplemento.Text + #13 +
             'Bairro: '      + edtBairro.Text      + #13 +
             'Cidade: '      + edtCidade.Text      + #13 +
             'Estado: '      + edtEstado.Text      + #13 +
             'Pais: '        + edtPais.Text        + #13 + #13 + #13 +
             'Segue em anexo o arquivo XML. '      + #13 + #13 +
             'Atenciosamente';

  Result := varBody;
end;

procedure TFormCadastroClientes.btnSairClick(Sender: TObject);
begin
  Self.Close;
end;

end.



