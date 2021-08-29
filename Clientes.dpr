program Clientes;

uses
  Vcl.Forms,
  uClientes in 'uClientes.pas' {fClientes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfClientes, fClientes);
  Application.Run;
end.
