unit uPedItemC;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, System.UITypes, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, VCL.Dialogs,
  uPedItemM;

type
  TPedItemC = class
  private

  public
    function Inserir(oPedItemM: TPedItemM): Boolean;
    function Alterar(oPedItemM: TPedItemM): Boolean;
    function Excluir(pIdPedItem: Integer): Boolean;
    function ExcluirPed(pIdPedGeral: Integer): Boolean;
    function Carregar(pIdPedItem: Integer): TPedItemM;
  end;

implementation

uses uConnection;

{ TPedItemC }

function TPedItemC.Alterar(oPedItemM: TPedItemM): Boolean;
var
  qAux: TFDQuery;
begin
  Result := False;

  qAux := TFDQuery.Create(nil);
  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('UPDATE peditem SET quantidade = :quantidade, vlrunitario = :vlrunitario, vlrtotal = :vlrtotal');
      qAux.SQL.Add('WHERE idpeditem = :idpeditem');
      qAux.ParamByName('idpeditem').AsInteger := oPedItemM.IdPedItem;
      qAux.ParamByName('quantidade').AsInteger := oPedItemM.Quantidade;
      qAux.ParamByName('vlrunitario').AsFloat := oPedItemM.VlrUnitario;
      qAux.ParamByName('vlrtotal').AsFloat := oPedItemM.VlrTotal;
      qAux.ExecSQL;

      Result := True;
    except on E:Exception do
      MessageDlg('Erro ao alterar o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

function TPedItemC.Carregar(pIdPedItem: Integer): TPedItemM;
var
  qAux: TFDQuery;
begin
  Result := TPedItemM.Create;

  qAux := TFDQuery.Create(nil);
  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('SELECT * FROM peditem WHERE idpeditem = :idpeditem');
      qAux.ParamByName('idpeditem').AsInteger := pIdPedItem;
      qAux.Open;

      if not qAux.IsEmpty then
      begin
        if Assigned(qAux.FindField('idpeditem')) then
          Result.IdPedItem := qAux.FieldByName('idpeditem').AsInteger;
        if Assigned(qAux.FindField('idpedgeral')) then
          Result.IdPedGeral := qAux.FieldByName('idpedgeral').AsInteger;
        if Assigned(qAux.FindField('idproduto')) then
          Result.IdProduto := qAux.FieldByName('idproduto').AsInteger;
        if Assigned(qAux.FindField('quantidade')) then
          Result.Quantidade := qAux.FieldByName('quantidade').AsInteger;
        if Assigned(qAux.FindField('vlrunitario')) then
          Result.VlrUnitario := qAux.FieldByName('vlrunitario').AsFloat;
        if Assigned(qAux.FindField('vlrtotal')) then
          Result.VlrTotal := qAux.FieldByName('vlrtotal').AsFloat;
      end;

    except on E:Exception do
      MessageDlg('Erro ao carregar o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

function TPedItemC.Excluir(pIdPedItem: Integer): Boolean;
var
  qAux: TFDQuery;
begin
  Result := False;

  qAux := TFDQuery.Create(nil);
  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('DELETE FROM peditem WHERE idpeditem = :idpeditem');
      qAux.ParamByName('idpeditem').AsInteger := pIdPedItem;
      qAux.ExecSQL;

      Result := True;
    except on E:Exception do
      MessageDlg('Erro ao excluir o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

function TPedItemC.ExcluirPed(pIdPedGeral: Integer): Boolean;
var
  qAux: TFDQuery;
begin
  Result := False;

  qAux := TFDQuery.Create(nil);
  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('DELETE FROM peditem WHERE idpedgeral = :idpedgeral');
      qAux.ParamByName('idpedgeral').AsInteger := pIdPedGeral;
      qAux.ExecSQL;

      Result := True;
    except on E:Exception do
      MessageDlg('Erro ao excluir os produtos do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

function TPedItemC.Inserir(oPedItemM: TPedItemM): Boolean;
var
  qAux: TFDQuery;
begin
  Result := False;

  qAux := TFDQuery.Create(nil);
  try
    try
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('INSERT INTO peditem (idpedgeral, idproduto, quantidade, vlrunitario, vlrtotal) ');
      qAux.SQL.Add('VALUES (:idpedgeral, :idproduto, :quantidade, :vlrunitario , :vlrtotal) ');
      qAux.ParamByName('idpedgeral').AsInteger := oPedItemM.IdPedGeral;
      qAux.ParamByName('idproduto').AsInteger := oPedItemM.IdProduto;
      qAux.ParamByName('quantidade').AsInteger := oPedItemM.Quantidade;
      qAux.ParamByName('vlrunitario').AsFloat := oPedItemM.VlrUnitario;
      qAux.ParamByName('vlrtotal').AsFloat := oPedItemM.VlrTotal;
      qAux.ExecSQL;

      Result := True;
    except on E:Exception do
      MessageDlg('Erro ao incluir o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

end.
