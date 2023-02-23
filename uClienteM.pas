unit uClienteM;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs;

type
  TClienteM = class
  private
    FIdCliente: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
    procedure SetIdCliente(const Value: Integer);
    function GetIdCliente:Integer;
    procedure SetNome(const Value: string);
    function GetNome:string;
    procedure SetCidade(const Value: string);
    function GetCidade:string;
    procedure SetUF(const Value: string);
    function GetUF:string;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clear();

    property IdCliente: Integer read GetIdCliente write SetIdCliente;
    property Nome: string read GetNome write SetNome;
    property Cidade: string read GetCidade write SetCidade;
    property UF: string read GetUF write SetUF;
  end;

implementation

{ TClienteM }

procedure TClienteM.Clear;
begin
  FIdCliente := 0;
  FNome := EmptyStr;
  FCidade := EmptyStr;
  FUF := EmptyStr;
end;

constructor TClienteM.Create;
begin
  Self.Clear;
end;

destructor TClienteM.Destroy;
begin
  //
  inherited;
end;

function TClienteM.GetCidade: string;
begin
  Result := fCidade;
end;

function TClienteM.GetIdCliente: Integer;
begin
  Result := fIdCliente;
end;

function TClienteM.GetNome: string;
begin
  Result := fNome;
end;

function TClienteM.GetUF: string;
begin
  Result := fUF;
end;

procedure TClienteM.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TClienteM.SetIdCliente(const Value: Integer);
begin
  FIdCliente := Value;
end;

procedure TClienteM.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TClienteM.SetUF(const Value: string);
begin
  FUF := Value;
end;

end.
