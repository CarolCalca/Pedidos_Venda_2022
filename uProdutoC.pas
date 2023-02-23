unit uProdutoC;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs,
  FireDAC.Stan.Param, System.UITypes, uProdutoM;

type
  TProdutoC = class
  private

  public
    function Inserir(oProdutoM: TProdutoM): Boolean;
    function Carregar(pIdProduto: Integer): TProdutoM;
  end;

implementation

uses uConnection;

{ TProdutoC }

function TProdutoC.Carregar(pIdProduto: Integer): TProdutoM;
var
  qAux: TFDQuery;
begin
  Result := TProdutoM.Create;

  try
    try
      qAux := TFDQuery.Create(nil);
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('SELECT * FROM produto WHERE idproduto = :idproduto');
      qAux.ParamByName('idproduto').AsInteger := pIdProduto;
      qAux.Open;

      if not qAux.IsEmpty then
      begin
        if Assigned(qAux.FindField('idproduto')) then
          Result.IdProduto := qAux.FieldByName('idproduto').AsInteger;
        if Assigned(qAux.FindField('descricao')) then
          Result.Descricao := qAux.FieldByName('descricao').AsString;
        if Assigned(qAux.FindField('precovenda')) then
          Result.PrecoVenda := qAux.FieldByName('precovenda').AsFloat;
      end;

    except on E:Exception do
      MessageDlg('Erro ao carregar o Produto!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

function TProdutoC.Inserir(oProdutoM: TProdutoM): Boolean;
var
  qAux: TFDQuery;
begin

  try
    try
      qAux := TFDQuery.Create(nil);
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('INSERT INTO produto (descricao, precovenda) VALUES (:descricao, :precovenda)');
      qAux.ParamByName('descricao').AsString := oProdutoM.Descricao;
      qAux.ParamByName('precovenda').AsFloat := oProdutoM.PrecoVenda;
      qAux.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao inserir o Produto!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qAux);
  end;
end;


end.
