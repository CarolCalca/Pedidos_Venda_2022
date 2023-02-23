unit uPedGeralC;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, System.UITypes, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  Vcl.Dialogs, uPedGeralM, uPedItemC, uPedItemM;

type
  TPedGeralC = class
  private
    class function getId(): Integer;
  public
    function Inserir(oPedGeralM: TPedGeralM): Boolean;
    function Alterar(oPedGeralM: TPedGeralM): Boolean;
    function Excluir(pIdPedGeral: Integer): Boolean;
    function Carregar(pIdPedGeral: Integer): TPedGeralM;
  end;

implementation

uses uConnection;

{ TProdutoC }

class function TPedGeralC.getId: Integer;
var
  qAux: TFDQuery;
begin
  Result := 0;

  qAux := TFDQuery.Create(nil);
  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('SELECT MAX(idpedgeral) AS ID_ATUAL FROM pedgeral');
      qAux.Open;

      if not (qAux.IsEmpty) then
        Result := qAux.FieldByName('ID_ATUAL').AsInteger + 1
      else
        Result := 1;

    except on E:Exception do
      MessageDlg('Erro ao pesquisar a chave do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

function TPedGeralC.Alterar(oPedGeralM: TPedGeralM): Boolean;
var
  qAux: TFDQuery;
  I: Integer;
  oPedItemC: TPedItemC;
begin
  qAux := TFDQuery.Create(nil);

  oPedItemC := TPedItemC.Create;

  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('UPDATE pedgeral SET vlrtotal = :vlrtotal');
      qAux.SQL.Add('WHERE idpedgeral = :idpedgeral');
      qAux.ParamByName('idpedgeral').AsInteger := oPedGeralM.Idpedgeral;
      qAux.ParamByName('vlrtotal').AsFloat := oPedGeralM.VlrTotal;
      qAux.ExecSQL;

      for I := 0 to pred(oPedGeralM.PedItem.Count) do
      begin
        oPedGeralM.PedItem[I].IdPedGeral := oPedGeralM.Idpedgeral;

        if (oPedGeralM.PedItem[I].IdPedItem > 0) then
          oPedItemC.Alterar(oPedGeralM.PedItem[I])
        else
          oPedItemC.Inserir(oPedGeralM.PedItem[I]);
      end;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao alterar o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(oPedItemC);
    FreeAndNil(qAux);
  end;
end;

function TPedGeralC.Carregar(pIdPedGeral: Integer): TPedGeralM;
var
  qAux: TFDQuery;
  oPedItemM: TPedItemM;
begin
  Result := TPedGeralM.Create;

  qAux := TFDQuery.Create(nil);
  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('SELECT * FROM pedgeral WHERE idpedgeral = :idpedgeral');
      qAux.ParamByName('idpedgeral').AsInteger := pIdPedGeral;
      qAux.Open;

      if not qAux.IsEmpty then
      begin
        if Assigned(qAux.FindField('idpedgeral')) then
          Result.IdPedGeral := qAux.FieldByName('idpedgeral').AsInteger;
        if Assigned(qAux.FindField('data')) then
          Result.Data := qAux.FieldByName('data').AsDateTime;
        if Assigned(qAux.FindField('idcliente')) then
          Result.IdCliente := qAux.FieldByName('idcliente').AsInteger;
        if Assigned(qAux.FindField('vlrtotal')) then
          Result.VlrTotal := qAux.FieldByName('vlrtotal').AsFloat;

        qAux.Close;
        qAux.SQL.Clear;
        qAux.SQL.Add('SELECT * FROM peditem WHERE idpedgeral = :idpedgeral');
        qAux.ParamByName('idpedgeral').AsInteger := pIdPedGeral;
        qAux.Open;

        qAux.First;
        while not qAux.Eof do
        begin
          oPedItemM := TPedItemM.Create;

          oPedItemM.IdPedItem := qAux.FieldByName('IdPedItem').AsInteger;
          oPedItemM.IdPedGeral := qAux.FieldByName('IdPedGeral').AsInteger;
          oPedItemM.IdProduto := qAux.FieldByName('IdProduto').AsInteger;
          oPedItemM.Quantidade := qAux.FieldByName('Quantidade').AsInteger;
          oPedItemM.VlrUnitario := qAux.FieldByName('VlrUnitario').AsFloat;
          oPedItemM.VlrTotal := qAux.FieldByName('VlrTotal').AsFloat;

          Result.PedItem.Add(oPedItemM);

          qAux.Next;
        end;

      end;

      except on E:Exception do
        MessageDlg('Erro ao carregar o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(oPedItemM);
    FreeAndNil(qAux);
  end;
end;

function TPedGeralC.Excluir(pIdPedGeral: Integer): Boolean;
var
  qAux: TFDQuery;
  oPedItemC: TPedItemC;
begin
  Result := False;

  oPedItemC := TPedItemC.Create;

  qAux := TFDQuery.Create(nil);
  try
    try
      oPedItemC.ExcluirPed(pIdPedGeral);

      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('DELETE FROM pedgeral WHERE idpedgeral = :idpedgeral');
      qAux.ParamByName('idpedgeral').AsInteger := pIdPedGeral;
      qAux.ExecSQL;

      Result := True;
    except on E:Exception do
      MessageDlg('Erro ao excluir o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(oPedItemC);
    FreeAndNil(qAux);
  end;
end;

function TPedGeralC.Inserir(oPedGeralM: TPedGeralM): Boolean;
var
  qAux: TFDQuery;
  vId, I: Integer;
  oPedItemC: TPedItemC;
begin
  Result := False;

  vId := TPedGeralC.getId();

  if (vId > 0) then
  begin

    qAux := TFDQuery.Create(nil);

    oPedItemC := TPedItemC.Create;

    try
      try
        qAux.Connection := TConnection.getConnection();

        qAux.Close;
        qAux.SQL.Clear;
        qAux.SQL.Add('INSERT INTO pedgeral (idpedgeral, data, idcliente, vlrtotal)');
        qAux.SQL.Add(' VALUES (:idpedgeral, :data, :idcliente, :vlrtotal)');
        qAux.ParamByName('idpedgeral').AsInteger := vId;
        qAux.ParamByName('data').AsDateTime := oPedGeralM.Data;
        qAux.ParamByName('idcliente').AsInteger := oPedGeralM.IdCliente;
        qAux.ParamByName('vlrtotal').AsFloat := oPedGeralM.VlrTotal;
        qAux.ExecSQL;

        for I := 0 to pred(oPedGeralM.PedItem.Count) do
        begin
          oPedGeralM.PedItem[I].IdPedGeral := vId;

          if (oPedGeralM.PedItem[I].IdPedItem > 0) then
            oPedItemC.Alterar(oPedGeralM.PedItem[I])
          else
            oPedItemC.Inserir(oPedGeralM.PedItem[I]);
        end;

        Result := True;
      except on E:Exception do
        MessageDlg('Erro ao incluir o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    finally
      FreeAndNil(oPedItemC);
      FreeAndNil(qAux);
    end;
  end;
end;

end.
