unit uConnection;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQL, Vcl.Dialogs, Vcl.Forms,
  FireDAC.DApt, FireDAC.Stan.Param, System.UITypes, uClienteC, uClienteM,
  uProdutoC, uProdutoM;

type
  TConnection = class
    private
      class var oConnection : TFDConnection;
      class var oDriverLink : TFDPhysMySQLDriverLink;
      class procedure Config(pCriar: Boolean);
      class procedure Connect(pCriar: Boolean);
      class procedure InsereCliente();
      class procedure InsereProduto();
    public
      class function getConnection(pCriar: Boolean = False):TFDConnection;
      class function createDB():Boolean;
  end;

const
  cstDB_Driver: string = 'MySQL';
  cstDB_User: string = 'root';
  cstDB_Pass: string = 'root';
  cstDB_Name: string = 'dbPedidos';
  cstDB_Server: string = '127.0.0.1';
  cstDB_Port: string = '3306';


implementation

{ TConnection }

class function TConnection.getConnection(pCriar: Boolean = False): TFDConnection;
begin
  Result := nil;

  try
    TConnection.Connect(pCriar);
    Result := oConnection;
  except
    on E:Exception do
    begin
      ShowMessage('Não foi possível conectar ao banco de dados.' + #13 + E.Message);
      Application.Terminate;
    end;
  end;
end;

class procedure TConnection.Connect(pCriar: Boolean);
begin
  TConnection.Config(pCriar);
  if not oConnection.Connected then
    oConnection.Connected := True;
end;

class procedure TConnection.Config(pCriar: Boolean);
begin
  if not Assigned(oConnection) then
  begin
    if not Assigned(oDriverLink) then
    begin
      oDriverLink := TFDPhysMySQLDriverLink.Create(nil);
      oDriverLink.VendorLib := GetCurrentDir + '\libmysql.dll';
    end;

    oConnection := TFDConnection.Create(nil);
    oConnection.Params.Add('driverID='+cstDB_Driver);
    oConnection.Params.Add('server='+cstDB_Server);
    oConnection.Params.Add('port='+cstDB_Port);

    if not (pCriar) then
      oConnection.Params.Add('database='+cstDB_Name);

    oConnection.Params.Add('user_name='+cstDB_User);
    oConnection.Params.Add('password='+cstDB_Pass);
  end;
end;

class function TConnection.createDB: Boolean;
var
  qryDB: TFDQuery;
begin
  Result := False;

  qryDB := TFDQuery.Create(nil);

  try
    try
      qryDB.Connection := getConnection(True);

      qryDB.Close;
      qryDB.SQL.Clear;
      qryDB.SQL.Add('SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = :SCHEMA_NAME');
      qryDB.ParamByName('SCHEMA_NAME').AsString := cstDB_Name;
      qryDB.Open;

      if not qryDB.IsEmpty then
      begin
        FreeAndNil(oConnection);
        qryDB.Connection := getConnection();
      end
      else
      begin
        qryDB.Close;
        qryDB.SQL.Clear;
        qryDB.SQL.Add('CREATE SCHEMA IF NOT EXISTS `'+cstDB_Name+'`');
        qryDB.ExecSQL;

        FreeAndNil(oConnection);
        qryDB.Connection := getConnection();

        // Clientes
        qryDB.Close;
        qryDB.SQL.Clear;
        qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`cliente` ( ');
        qryDB.SQL.Add('  `idcliente` INT NOT NULL AUTO_INCREMENT,   ');
        qryDB.SQL.Add('  `nome` VARCHAR(150) NOT NULL,              ');
        qryDB.SQL.Add('  `cidade` VARCHAR(150) NULL,                ');
        qryDB.SQL.Add('  `uf` VARCHAR(2) NULL,                      ');
        qryDB.SQL.Add('  PRIMARY KEY (`idcliente`),                 ');
        qryDB.SQL.Add('  INDEX `idx_cidade` (`cidade` ASC) VISIBLE, ');
        qryDB.SQL.Add('  INDEX `idx_uf` (`uf` ASC) VISIBLE)         ');
        qryDB.ExecSQL;

        InsereCliente;

        // Produtos
        qryDB.Close;
        qryDB.SQL.Clear;
        qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`produto` ( ');
        qryDB.SQL.Add('  `idproduto` INT NOT NULL AUTO_INCREMENT,         ');
        qryDB.SQL.Add('  `descricao` VARCHAR(150) NOT NULL,               ');
        qryDB.SQL.Add('  `precovenda` DECIMAL(10,2) NOT NULL,             ');
        qryDB.SQL.Add('  PRIMARY KEY (`idproduto`),                       ');
        qryDB.SQL.Add('  INDEX `idx_descricao` (`descricao` ASC) VISIBLE) ');
        qryDB.ExecSQL;

        InsereProduto;

        // Pedidos Geral
        qryDB.Close;
        qryDB.SQL.Clear;
        qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`pedgeral`( ');
        qryDB.SQL.Add('  `idpedgeral` INT NOT NULL,                            ');
        qryDB.SQL.Add('  `data` DATETIME NOT NULL,                             ');
        qryDB.SQL.Add('  `idcliente` INT NOT NULL,                             ');
        qryDB.SQL.Add('  `vlrtotal` DECIMAL(10,2) NOT NULL,                    ');
        qryDB.SQL.Add('  PRIMARY KEY (`idpedgeral`),                           ');
        qryDB.SQL.Add('  INDEX `idx_data` (`data` ASC) INVISIBLE,              ');
        qryDB.SQL.Add('  INDEX `idx_idcliente` (`idcliente` ASC) VISIBLE,      ');
        qryDB.SQL.Add('  CONSTRAINT `fk_idcliente`                             ');
        qryDB.SQL.Add('  FOREIGN KEY (`idcliente`)                             ');
        qryDB.SQL.Add('  REFERENCES `'+cstDB_Name+'`.`cliente` (`idcliente`)   ');
        qryDB.SQL.Add('  ON DELETE NO ACTION                                   ');
        qryDB.SQL.Add('  ON UPDATE NO ACTION)                                  ');
        qryDB.ExecSQL;

        // Pedidos Itens
        qryDB.Close;
        qryDB.SQL.Clear;
        qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`peditem` ( ');
        qryDB.SQL.Add('  `idpeditem` INT NOT NULL AUTO_INCREMENT,              ');
        qryDB.SQL.Add('  `idpedgeral` INT NOT NULL,                            ');
        qryDB.SQL.Add('  `idproduto` INT NOT NULL,                             ');
        qryDB.SQL.Add('  `quantidade` INT NOT NULL,                            ');
        qryDB.SQL.Add('  `vlrunitario` DECIMAL(10,2) NOT NULL,                 ');
        qryDB.SQL.Add('  `vlrtotal` DECIMAL(10,2) NOT NULL,                    ');
        qryDB.SQL.Add('  PRIMARY KEY (`idpeditem`),                            ');
        qryDB.SQL.Add('  INDEX `idx_idpedgeral` (`idpedgeral` ASC) INVISIBLE,  ');
        qryDB.SQL.Add('  INDEX `idx_idproduto` (`idproduto` ASC) VISIBLE,      ');
        qryDB.SQL.Add('  CONSTRAINT `fk_idproduto`                             ');
        qryDB.SQL.Add('  FOREIGN KEY (`idproduto`)                             ');
        qryDB.SQL.Add('  REFERENCES `'+cstDB_Name+'`.`produto` (`idproduto`)   ');
        qryDB.SQL.Add('  ON DELETE NO ACTION                                   ');
        qryDB.SQL.Add('  ON UPDATE NO ACTION,                                  ');
        qryDB.SQL.Add('  CONSTRAINT `fk_idpedgeral`                             ');
        qryDB.SQL.Add('  FOREIGN KEY (`idpedgeral`)                             ');
        qryDB.SQL.Add('  REFERENCES `'+cstDB_Name+'`.`pedgeral` (`idpedgeral`)   ');
        qryDB.SQL.Add('  ON DELETE NO ACTION                                   ');
        qryDB.SQL.Add('  ON UPDATE NO ACTION)                                  ');
        qryDB.ExecSQL;
      end;

      Result := True;

    except on E:Exception do
      begin
        MessageDlg('Erro ao criar o banco de dados!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryDB);
  end;
end;

class procedure TConnection.InsereCliente;
var
  oCliM: TClienteM;
  oCliC: TClienteC;
begin
  oCliM := TClienteM.Create;
  oCliC := TClienteC.Create;

  try
    oCliM.Nome   := 'Miguel';
    oCliM.Cidade := 'Sao Paulo';
    oCliM.UF     := 'SP';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Helena';
    oCliM.Cidade := 'Rio de Janeiro';
    oCliM.UF     := 'RJ';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Arthur';
    oCliM.Cidade := 'Belo Horizonte';
    oCliM.UF     := 'MG';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Alice';
    oCliM.Cidade := 'Brasilia';
    oCliM.UF     := 'DF';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Benicio';
    oCliM.Cidade := 'Salvador';
    oCliM.UF     := 'BA';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Laura';
    oCliM.Cidade := 'Fortaleza';
    oCliM.UF     := 'CE';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Theo';
    oCliM.Cidade := 'Sao Paulo';
    oCliM.UF     := 'SP';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Manuela';
    oCliM.Cidade := 'Sao Paulo';
    oCliM.UF     := 'SP';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Heitor';
    oCliM.Cidade := 'Sao Paulo';
    oCliM.UF     := 'SP';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Sophia';
    oCliM.Cidade := 'Manaus';
    oCliM.UF     := 'AM';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Davi';
    oCliM.Cidade := 'Rio de Janeiro';
    oCliM.UF     := 'RJ';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Isabella';
    oCliM.Cidade := 'Rio de Janeiro';
    oCliM.UF     := 'RJ';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Bernardo';
    oCliM.Cidade := 'Sao Paulo';
    oCliM.UF     := 'SP';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Luisa';
    oCliM.Cidade := 'Curitiba';
    oCliM.UF     := 'PR';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Noah';
    oCliM.Cidade := 'Recife';
    oCliM.UF     := 'PE';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Cecilia';
    oCliM.Cidade := 'Goiania';
    oCliM.UF     := 'GO';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Gabriel';
    oCliM.Cidade := 'Sao Paulo';
    oCliM.UF     := 'SP';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Maite';
    oCliM.Cidade := 'Belem';
    oCliM.UF     := 'PA';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Samuel';
    oCliM.Cidade := 'Porto Alegre';
    oCliM.UF     := 'RS';

    oCliC.Inserir(oCliM);
    oCliM.Clear;

    oCliM.Nome   := 'Eloa';
    oCliM.Cidade := 'Guarulhos';
    oCliM.UF     := 'SP';

    oCliC.Inserir(oCliM);
  finally
    FreeAndNil(oCliM);
    FreeAndNil(oCliC);
  end;
end;

class procedure TConnection.InsereProduto;
var
  oProdM: TProdutoM;
  oProdC: TProdutoC;
begin
  try
    oProdM := TProdutoM.Create;
    oProdC := TProdutoC.Create;

    oProdM.Descricao  := 'Arroz';
    oProdM.PrecoVenda := 24.99;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Feijao';
    oProdM.PrecoVenda := 9.9;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Cafe';
    oProdM.PrecoVenda := 11.9;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Macarrao';
    oProdM.PrecoVenda := 3.55;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Farinha de trigo';
    oProdM.PrecoVenda := 6.5;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Ovo';
    oProdM.PrecoVenda := 0.90;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Salgadinho';
    oProdM.PrecoVenda := 9.9;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Refrigerante 2l';
    oProdM.PrecoVenda := 7.3;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Chocolate';
    oProdM.PrecoVenda := 5.4;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Miojo';
    oProdM.PrecoVenda := 1.99;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Leite';
    oProdM.PrecoVenda := 4.5;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Achocolatado';
    oProdM.PrecoVenda := 7.8;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Leite em po';
    oProdM.PrecoVenda := 10.2;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Vassoura';
    oProdM.PrecoVenda := 10.7;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Limpador multiuso';
    oProdM.PrecoVenda := 12.6;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Sacos de lixo 50l';
    oProdM.PrecoVenda := 13.8;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Bolacha';
    oProdM.PrecoVenda := 2.7;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Iogurte';
    oProdM.PrecoVenda := 5.9;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Biscoito';
    oProdM.PrecoVenda := 8.6;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Oleo';
    oProdM.PrecoVenda := 11.5;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Vinagre';
    oProdM.PrecoVenda := 3.9;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Sal';
    oProdM.PrecoVenda := 2.3;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Acucar';
    oProdM.PrecoVenda := 3.2;

    oProdC.Inserir(oProdM);
    oProdM.Clear;

    oProdM.Descricao  := 'Pao de forma';
    oProdM.PrecoVenda := 7.5;

    oProdC.Inserir(oProdM);
  finally
    FreeAndNil(oProdM);
    FreeAndNil(oProdC);
  end;
end;

end.
