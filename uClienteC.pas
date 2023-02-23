unit uClienteC;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs,
  FireDAC.Stan.Param, System.UITypes, uClienteM;

type
  TClienteC = class
  private

  public  
    function Inserir(oClienteM: TClienteM): Boolean;
    function Carregar(pIdCliente: Integer): TClienteM;
  end;

implementation

uses uConnection;

{ TClienteC }

function TClienteC.Carregar(pIdCliente: Integer): TClienteM;
var
  qAux: TFDQuery;
begin
  Result := TClienteM.Create;
  
  try
    try
      qAux := TFDQuery.Create(nil);
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('SELECT * FROM cliente WHERE idcliente = :idcliente');
      qAux.ParamByName('idcliente').AsInteger := pIdCliente;
      qAux.Open;

      if not qAux.IsEmpty then
      begin
        if Assigned(qAux.FindField('idcliente')) then
          Result.IdCliente := qAux.FieldByName('idcliente').AsInteger;
        if Assigned(qAux.FindField('nome')) then
          Result.Nome := qAux.FieldByName('nome').AsString;
        if Assigned(qAux.FindField('cidade')) then
          Result.Cidade := qAux.FieldByName('cidade').AsString;
        if Assigned(qAux.FindField('uf')) then
          Result.UF := qAux.FieldByName('uf').AsString;
      end;

    except on E:Exception do
      MessageDlg('Erro ao carregar o Cliente!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  finally
    FreeAndNil(qAux);
  end;
end;

function TClienteC.Inserir(oClienteM: TClienteM): Boolean;
var
  qAux: TFDQuery;
begin

  try
    try
      qAux := TFDQuery.Create(nil);
      qAux.Connection := TConnection.getConnection();

      qAux.Close;
      qAux.SQL.Clear;
      qAux.SQL.Add('INSERT INTO cliente (nome, cidade, uf) VALUES (:nome, :cidade, :uf)');
      qAux.ParamByName('nome').AsString := oClienteM.Nome;
      qAux.ParamByName('cidade').AsString := oClienteM.Cidade;
      qAux.ParamByName('uf').AsString := oClienteM.UF;
      qAux.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao inserir o Cliente!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qAux);
  end;
end;


end.
