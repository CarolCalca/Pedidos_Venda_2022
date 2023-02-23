program pedidos_venda_2022;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uConnection in 'uConnection.pas',
  uClienteC in 'uClienteC.pas',
  uProdutoC in 'uProdutoC.pas',
  uClienteM in 'uClienteM.pas',
  uProdutoM in 'uProdutoM.pas',
  uPedGeralC in 'uPedGeralC.pas',
  uPedGeralM in 'uPedGeralM.pas',
  uPedItemC in 'uPedItemC.pas',
  uPedItemM in 'uPedItemM.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
