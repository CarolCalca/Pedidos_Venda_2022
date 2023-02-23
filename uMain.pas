unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uConnection, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, System.UITypes, FireDAC.Comp.Client,
  uClienteC, uClienteM, uProdutoC, uProdutoM, uPedGeralC, uPedGeralM, uPedItemC, uPedItemM,
  Datasnap.Provider;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCarregar: TButton;
    btnCancelar: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnAdicionar: TButton;
    dbgProdutos: TDBGrid;
    edtIdCliente: TEdit;
    edtIdProduto: TEdit;
    edtQtd: TEdit;
    edtValor: TEdit;
    edtNomeCliente: TEdit;
    edtDescProduto: TEdit;
    Panel4: TPanel;
    Label6: TLabel;
    lblTotal: TLabel;
    btnGravar: TButton;
    cdsProdutos: TClientDataSet;
    cdsProdutosidpeditem: TIntegerField;
    cdsProdutosidpedgeral: TIntegerField;
    cdsProdutosidproduto: TIntegerField;
    cdsProdutosdescricao: TStringField;
    cdsProdutosquantidade: TIntegerField;
    cdsProdutosvlrunitario: TFloatField;
    cdsProdutosvlrtotal: TFloatField;
    dsProdutos: TDataSource;
    cdsProdDel: TClientDataSet;
    cdsProdDelidpeditem: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure edtIdClienteChange(Sender: TObject);
    procedure edtIdClienteExit(Sender: TObject);
    procedure edtIdProdutoChange(Sender: TObject);
    procedure edtIdProdutoExit(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure dbgProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    const cVlrMask: String = '#,###,###,##0.00';

    procedure LimpaTela;
    function CalcVlrTotal: Double;
    function RetornaCliente(pIdCliente: String): String;
    function RetornaProduto(pIdProduto: String): String;
    function RetornaValorProduto(pIdProduto: String): String;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.btnAdicionarClick(Sender: TObject);
begin
  if (edtIdProduto.Text = EmptyStr) then
  begin
    MessageDlg('Por favor, preencha o produto.', mtWarning, [mbOk], 0, mbOk);
    edtIdProduto.SetFocus;
  end
  else if (StrToIntDef(edtQtd.Text, 0) = 0) then
  begin
    MessageDlg('Por favor, preencha a quantidade.', mtWarning, [mbOk], 0, mbOk);
    edtQtd.SetFocus;
  end
  else if (StrToFloatDef(edtValor.Text, 0) = 0) then
  begin
    MessageDlg('Por favor, preencha o valor unitário.', mtWarning, [mbOk], 0, mbOk);
    edtValor.SetFocus;
  end
  else
  begin
    cdsProdutos.DisableControls;

    try
      try
        if not (cdsProdutos.State in [dsEdit]) then
        begin
          cdsProdutos.Append;
          cdsProdutos.FieldByName('idpeditem').AsInteger := 0;
          cdsProdutos.FieldByName('idpedgeral').AsInteger := 0;
          cdsProdutos.FieldByName('idproduto').AsInteger := StrToInt(edtIdProduto.Text);
          cdsProdutos.FieldByName('descricao').AsString := edtDescProduto.Text;
        end;

        cdsProdutos.FieldByName('quantidade').AsInteger := StrToInt(edtQtd.Text);
        cdsProdutos.FieldByName('vlrunitario').AsFloat := StrToFloat(edtValor.Text);
        cdsProdutos.FieldByName('vlrtotal').AsFloat := (StrToFloat(edtValor.Text) * StrToInt(edtQtd.Text));
        cdsProdutos.Post;

        CalcVlrTotal;

        edtIdProduto.SetFocus;

      except on E:Exception do
        begin
          MessageDlg('Erro ao incluir/alterar o produto!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
          edtIdProduto.SetFocus;
        end;
      end;
    finally
      cdsProdutos.EnableControls;
    end;
  end;
end;

procedure TfMain.btnCancelarClick(Sender: TObject);
var
  vIdPedGeral: Integer;
  oPedGeralC: TPedGeralC;
begin
  oPedGeralC := TPedGeralC.Create;
  try
    try
      vIdPedGeral := StrToInt(InputBox('Cancelar pedido', 'Digite o número do pedido que deseja cancelar:', '0'));

      if (vIdPedGeral > 0) then
        if oPedGeralC.Excluir(vIdPedGeral) then
          MessageDlg('Pedido cancelado com sucesso!', mtInformation, [mbOk], 0, mbOk);

    except on E:Exception do
      MessageDlg('Número de pedido inválido!', mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(oPedGeralC);
  end;
end;

procedure TfMain.btnCarregarClick(Sender: TObject);
var
  I, vIdPedGeral: Integer;
  oPedGeralC: TPedGeralC;
  oPedGeralM: TPedGeralM;
begin
  LimpaTela;

  oPedGeralC := TPedGeralC.Create;
  oPedGeralM := TPedGeralM.Create;

  try
    try
      vIdPedGeral := StrToInt(InputBox('Carregar pedido', 'Digite o número do pedido que deseja carregar:', '0'));

      if (vIdPedGeral > 0) then
      begin
        oPedGeralM := oPedGeralC.Carregar(vIdPedGeral);

        if (oPedGeralM.IdPedGeral > 0) then
        begin
          edtIdCliente.Text := IntToStr(oPedGeralM.IdCliente);
          edtIdClienteExit(Sender);

          oPedGeralM.PedItem.First;
          for I := 0 to pred(oPedGeralM.PedItem.Count) do
          begin
            cdsProdutos.Append;
            cdsProdutos.FieldByName('IdPedItem').AsInteger := oPedGeralM.PedItem[I].IdPedItem;
            cdsProdutos.FieldByName('IdPedGeral').AsInteger := oPedGeralM.PedItem[I].IdPedGeral;
            cdsProdutos.FieldByName('IdProduto').AsInteger := oPedGeralM.PedItem[I].IdProduto;
            cdsProdutos.FieldByName('Descricao').AsString := RetornaProduto(IntToStr(oPedGeralM.PedItem[I].IdProduto));
            cdsProdutos.FieldByName('Quantidade').AsInteger := oPedGeralM.PedItem[I].Quantidade;
            cdsProdutos.FieldByName('VlrUnitario').AsFloat := oPedGeralM.PedItem[I].VlrUnitario;
            cdsProdutos.FieldByName('VlrTotal').AsFloat := oPedGeralM.PedItem[I].VlrTotal;
            cdsProdutos.Post;
          end;

          CalcVlrTotal;
        end
        else
          MessageDlg('Pedido não encontrado!', mtInformation, [mbOk], 0, mbOk);
      end;

    except on E:Exception do
      MessageDlg('Número de pedido inválido!', mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(oPedGeralM);
    FreeAndNil(oPedGeralC);
  end;
end;

procedure TfMain.btnGravarClick(Sender: TObject);
var
  oPedItemM: TPedItemM;
  oPedItemC: TPedItemC;
  oPedGeralM: TPedGeralM;
  oPedGeralC: TPedGeralC;
  vIdPedGeral: Integer;
begin
  if (edtIdCliente.Text = EmptyStr) then
  begin
    MessageDlg('Por favor, preencha o cliente.', mtWarning, [mbOk], 0, mbOk);
    edtIdCliente.SetFocus;
  end
  else if (cdsProdutos.IsEmpty) then
  begin
    MessageDlg('Por favor, adicione produtos ao pedido.', mtWarning, [mbOk], 0, mbOk);
    edtIdProduto.SetFocus;
  end
  else
  begin
    cdsProdutos.DisableControls;
    cdsProdDel.DisableControls;

    oPedItemC := TPedItemC.Create;
    oPedGeralM := TPedGeralM.Create;
    oPedGeralC := TPedGeralC.Create;

    TConnection.getConnection().TxOptions.AutoCommit := False;
    TConnection.getConnection().TxOptions.AutoStart := False;
    TConnection.getConnection().TxOptions.AutoStop := False;

    TConnection.getConnection().StartTransaction;

    try
      try
        cdsProdDel.First;
        while not cdsProdDel.Eof do
        begin
          oPedItemC.Excluir(cdsProdDel.FieldByName('IdPedItem').AsInteger);
          cdsProdDel.Next;
        end;

        cdsProdutos.First;
        vIdPedGeral := cdsProdutos.FieldByName('idpedgeral').AsInteger;

        while not cdsProdutos.Eof do
        begin
          oPedItemM := TPedItemM.Create;

          oPedItemM.IdPedItem := cdsProdutos.FieldByName('IdPedItem').AsInteger;
          oPedItemM.IdPedGeral := vIdPedGeral;
          oPedItemM.IdProduto := cdsProdutos.FieldByName('IdProduto').AsInteger;
          oPedItemM.Quantidade := cdsProdutos.FieldByName('Quantidade').AsInteger;
          oPedItemM.VlrUnitario := cdsProdutos.FieldByName('VlrUnitario').AsFloat;
          oPedItemM.VlrTotal := cdsProdutos.FieldByName('VlrTotal').AsFloat;

          oPedGeralM.PedItem.Add(oPedItemM);

          cdsProdutos.Next;
        end;

        oPedGeralM.IdPedGeral := vIdPedGeral;
        oPedGeralM.Data := Now();
        oPedGeralM.IdCliente := StrToInt(edtIdCliente.Text);
        oPedGeralM.VlrTotal := CalcVlrTotal;

        if (vIdPedGeral > 0) then
          oPedGeralC.Alterar(oPedGeralM)
        else
          oPedGeralC.Inserir(oPedGeralM);

        TConnection.getConnection().Commit;

        LimpaTela;
      except on E:Exception do
        begin
          TConnection.getConnection().Rollback;
          MessageDlg('Erro ao gravar o pedido!', mtError, [mbOk], 0, mbOk);
        end;
      end;
    finally
      TConnection.getConnection().TxOptions.AutoCommit := True;
      TConnection.getConnection().TxOptions.AutoStart := True;
      TConnection.getConnection().TxOptions.AutoStop := True;

      FreeAndNil(oPedItemM);
      FreeAndNil(oPedGeralC);
      FreeAndNil(oPedGeralM);
      FreeAndNil(oPedItemC);

      cdsProdutos.EnableControls;
      cdsProdDel.EnableControls;
    end;
  end;
end;

function TfMain.CalcVlrTotal: Double;
begin
  Result := 0;

  cdsProdutos.DisableControls;

  try
    cdsProdutos.First;
    while not cdsProdutos.Eof do
    begin
      Result := Result + cdsProdutos.FieldByName('vlrtotal').AsFloat;

      cdsProdutos.Next;
    end;

    lblTotal.Caption := 'R$ ' + FormatFloat(cVlrMask, Result);
  finally
    cdsProdutos.EnableControls;
  end;
end;

procedure TfMain.dbgProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_up then
    dbgProdutos.Datasource.Dataset.Prior;

  if Key = vk_down then
    dbgProdutos.Datasource.Dataset.Next;

  if (cdsProdutos.FieldByName('idproduto').AsInteger > 0) then
  begin
    if Key = vk_delete then
    begin
      if MessageDlg('Deseja excluir o item do pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        // adiciona em outro dataset, para excluir apenas ao gravar, na transação
        if (cdsProdutos.FieldByName('idpeditem').AsInteger > 0) then
        begin
          cdsProdDel.Append;
          cdsProdDel.FieldByName('idpeditem').AsInteger := cdsProdutos.FieldByName('idpeditem').AsInteger;
          cdsProdDel.Post;
        end;

        cdsProdutos.Delete;
      end;
    end;

    if Key = vk_return then
    begin
      dbgProdutos.Options := dbgProdutos.Options + [dgEditing];
      cdsProdutos.Edit;
    end;
  end;
end;

procedure TfMain.edtIdClienteChange(Sender: TObject);
begin
  btnCarregar.Enabled := (edtIdCliente.Text = EmptyStr);
  btnCancelar.Enabled := (edtIdCliente.Text = EmptyStr);

  edtNomeCliente.Text := EmptyStr;
end;

procedure TfMain.edtIdClienteExit(Sender: TObject);
begin
  edtNomeCliente.Text := RetornaCliente(edtIdCliente.Text);

  if (edtNomeCliente.Text = EmptyStr) then
    edtIdCliente.Text := EmptyStr;
end;

procedure TfMain.edtIdProdutoChange(Sender: TObject);
begin
  edtDescProduto.Text := EmptyStr;
  edtQtd.Text := '0';
  edtValor.Text := '0,00';
end;

procedure TfMain.edtIdProdutoExit(Sender: TObject);
begin
  edtDescProduto.Text := RetornaProduto(edtIdProduto.Text);
  edtValor.Text := RetornaValorProduto(edtIdProduto.Text);

  if (edtDescProduto.Text = EmptyStr) then
    edtIdProduto.Text := EmptyStr;
end;

procedure TfMain.edtValorExit(Sender: TObject);
var
  vValor: String;
begin
  vValor := EmptyStr;

  if edtValor.Text <> EmptyStr then
  begin
    vValor := StringReplace(edtValor.Text, '.', EmptyStr, [rfReplaceAll]);
    vValor := StringReplace(edtValor.Text, ',', EmptyStr, [rfReplaceAll]);

    if (Length(vValor) = 1) then
      vValor := '0,0' + vValor
    else if (Length(vValor) = 2) then
      vValor := '0,' + vValor
    else
      vValor := Copy(vValor, 1, Length(vValor)-2) + ',' + Copy(vValor, Length(vValor)-1, 2);

    vValor := FormatFloat(cVlrMask, StrToFloat(vValor));
  end
  else
    vValor := '0,00';

  edtValor.Text := vValor;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  TConnection.createDB();

  cdsProdutos.CreateDataSet;
  cdsProdDel.CreateDataSet;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  edtIdCliente.SetFocus;
end;

procedure TfMain.LimpaTela;
begin
  edtIdCliente.Text := EmptyStr;
  edtIdClienteExit(nil);
  edtIdProduto.Text := EmptyStr;
  edtIdProdutoExit(nil);
  edtQtd.Text := '0';
  edtValor.Text := '0,00';
  cdsProdutos.EmptyDataSet;
  cdsProdDel.EmptyDataSet;
end;

function TfMain.RetornaCliente(pIdCliente: String): String;
var
  oCliM: TClienteM;
  oCliC: TClienteC;
begin
  Result := EmptyStr;

  if (pIdCliente = EmptyStr) then
    pIdCliente := '0';

  if (pIdCliente <> '0') then
  begin
    oCliM := TClienteM.Create;
    oCliC := TClienteC.Create;

    try
      oCliM := oCliC.Carregar(StrToInt(pIdCliente));

      if (OCliM.IdCliente > 0) then
        Result := OCliM.Nome;
    finally
      FreeAndNil(OCliM);
      FreeAndNil(OCliC);
    end;
  end;
end;

function TfMain.RetornaProduto(pIdProduto: String): String;
var
  oProdM: TProdutoM;
  oProdC: TProdutoC;
begin
  Result := EmptyStr;

  if (pIdProduto = EmptyStr) then
    pIdProduto := '0';

  if (pIdProduto > '0') then
  begin
    oProdM := TProdutoM.Create;
    oProdC := TProdutoC.Create;

    try
      oProdM := oProdC.Carregar(StrToInt(pIdProduto));

      if (OProdM.IdProduto > 0) then
        Result := OProdM.Descricao;

    finally
      FreeAndNil(oProdM);
      FreeAndNil(oProdC);
    end;
  end;
end;

function TfMain.RetornaValorProduto(pIdProduto: String): String;
var
  oProdM: TProdutoM;
  oProdC: TProdutoC;
begin
  Result := '0,00';

  if (pIdProduto = EmptyStr) then
    pIdProduto := '0';

  if (pIdProduto > '0') then
  begin
    oProdM := TProdutoM.Create;
    oProdC := TProdutoC.Create;

    try
      oProdM := oProdC.Carregar(StrToInt(pIdProduto));

      if (OProdM.IdProduto > 0) then
        Result := FormatFloat(cVlrMask, OProdM.PrecoVenda);

    finally
      FreeAndNil(oProdM);
      FreeAndNil(oProdC);
    end;
  end;
end;

end.
