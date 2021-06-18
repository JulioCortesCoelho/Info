program ProjetoClientes;

uses
  Vcl.Forms,
  FormularioCadastroClientes in 'FormularioCadastroClientes.pas' {FormCadastroClientes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormCadastroClientes, FormCadastroClientes);
  Application.Run;
end.
