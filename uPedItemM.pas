unit uPedItemM;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs, System.Generics.Collections;

type
  TPedItemM = class
  private
    FIdPedItem: Integer;
    FIdPedGeral: Integer;
    FIdProduto: Integer;
    FQuantidade: Integer;
    FVlrUnitario: Double;
    FVlrTotal: Double;
    procedure SetIdPedItem(const Value: Integer);
    function GetIdPedItem:Integer;
    procedure SetIdPedGeral(const Value: Integer);
    function GetIdPedGeral:Integer;
    procedure SetIdProduto(const Value: Integer);
    function GetIdProduto:Integer;
    procedure SetQuantidade(const Value: Integer);
    function GetQuantidade:Integer;
    procedure SetVlrUnitario(const Value: Double);
    function GetVlrUnitario:Double;
    procedure SetVlrTotal(const Value: Double);
    function GetVlrTotal:Double;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clear();

    property IdPedItem: Integer read GetIdPedItem write SetIdPedItem;
    property IdPedGeral: Integer read GetIdPedGeral write SetIdPedGeral;
    property IdProduto: Integer read GetIdProduto write SetIdProduto;
    property Quantidade: Integer read GetQuantidade write SetQuantidade;
    property VlrUnitario: Double read GetVlrUnitario write SetVlrUnitario;
    property VlrTotal: Double read GetVlrTotal write SetVlrTotal;
  end;

 type
  TPedItemMList = class(TList<TPedItemM>)
  end;

implementation

{ TPedItemM }

procedure TPedItemM.Clear;
begin
  FIdPedItem := 0;
  FIdPedGeral := 0;
  FIdProduto := 0;
  FQuantidade := 0;
  FVlrUnitario := 0;
  FVlrTotal := 0;
end;

constructor TPedItemM.Create;
begin
  Self.Clear;
end;

destructor TPedItemM.Destroy;
begin
  //
  inherited;
end;

function TPedItemM.GetIdPedGeral: Integer;
begin
  Result := fIdPedGeral;
end;

function TPedItemM.GetIdPedItem: Integer;
begin
  Result := fIdPedItem;
end;

function TPedItemM.GetIdProduto: Integer;
begin
  Result := fIdProduto;
end;

function TPedItemM.GetQuantidade: Integer;
begin
  Result := fQuantidade;
end;

function TPedItemM.GetVlrTotal: Double;
begin
  Result := fVlrTotal;
end;

function TPedItemM.GetVlrUnitario: Double;
begin
  Result := fVlrUnitario;
end;

procedure TPedItemM.SetIdPedGeral(const Value: Integer);
begin
  FIdPedGeral := Value;
end;

procedure TPedItemM.SetIdPedItem(const Value: Integer);
begin
  FIdPedItem := Value;
end;

procedure TPedItemM.SetIdProduto(const Value: Integer);
begin
  FIdProduto := Value;
end;

procedure TPedItemM.SetQuantidade(const Value: Integer);
begin
  FQuantidade := Value;
end;

procedure TPedItemM.SetVlrTotal(const Value: Double);
begin
  FVlrTotal := Value;
end;

procedure TPedItemM.SetVlrUnitario(const Value: Double);
begin
  FVlrUnitario := Value;
end;

end.
