unit uProdutoM;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs;

type
  TProdutoM = class
  private
    FIdProduto: Integer;
    FDescricao: string;
    FPrecoVenda: Double;
    procedure SetIdProduto(const Value: Integer);
    function GetIdProduto:Integer;
    procedure SetDescricao(const Value: string);
    function GetDescricao:string;
    procedure SetPrecoVenda(const Value: Double);
    function GetPrecoVenda:Double;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clear();

    property IdProduto: Integer read GetIdProduto write SetIdProduto;
    property Descricao: string read GetDescricao write SetDescricao;
    property PrecoVenda: Double read GetPrecoVenda write SetPrecoVenda;
  end;

implementation

{ TProdutoM }

procedure TProdutoM.Clear;
begin
  FIdProduto := 0;
  FDescricao := EmptyStr;
  FPrecoVenda := 0;
end;

constructor TProdutoM.Create;
begin
  Self.Clear;
end;

destructor TProdutoM.Destroy;
begin
  //
  inherited;
end;

function TProdutoM.GetDescricao: string;
begin
  Result := fDescricao;
end;

function TProdutoM.GetIdProduto: Integer;
begin
  Result := fIdProduto;
end;

function TProdutoM.GetPrecoVenda: Double;
begin
  Result := fPrecoVenda;
end;

procedure TProdutoM.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TProdutoM.SetIdProduto(const Value: Integer);
begin
  FIdProduto := Value;
end;

procedure TProdutoM.SetPrecoVenda(const Value: Double);
begin
  FPrecoVenda := Value;
end;

end.
