unit uPedGeralM;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs, uPedItemM;

type
  TPedGeralM = class
  private
    FIdPedGeral: Integer;
    FData: TDateTime;
    FIdCliente: Integer;
    FVlrTotal: Double;
    oPedItem: TPedItemMList;
    procedure SetIdPedGeral(const Value: Integer);
    function GetIdPedGeral:Integer;
    procedure SetData(const Value: TDateTime);
    function GetData:TDateTime;
    procedure SetIdCliente(const Value: Integer);
    function GetIdCliente:Integer;
    procedure SetVlrTotal(const Value: Double);
    function GetVlrTotal:Double;
    procedure SetPedItem(const Value: TPedItemMList);
    function GetPedItem:TPedItemMList;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clear();

    property IdPedGeral: Integer read GetIdPedGeral write SetIdPedGeral;
    property Data: TDateTime read GetData write SetData;
    property IdCliente: Integer read GetIdCliente write SetIdCliente;
    property VlrTotal: Double read GetVlrTotal write SetVlrTotal;
    property PedItem: TPedItemMList read GetPedItem write SetPedItem;
  end;

implementation

{ TPedGeralM }

procedure TPedGeralM.Clear;
begin
  FIdPedGeral := 0;
  FData := 0;
  FIdCliente := 0;
  FVlrTotal := 0;

  oPedItem.Clear;
end;

constructor TPedGeralM.Create;
begin
  oPedItem := TPedItemMList.Create();

  Self.Clear;
end;

destructor TPedGeralM.Destroy;
begin
  FreeAndNil(oPedItem);
  inherited;
end;

function TPedGeralM.GetData: TDateTime;
begin
  Result := fData;
end;

function TPedGeralM.GetIdCliente: Integer;
begin
  Result := fIdCliente;
end;

function TPedGeralM.GetIdPedGeral: Integer;
begin
  Result := fIdPedGeral;
end;

function TPedGeralM.GetPedItem: TPedItemMList;
begin
  Result := oPedItem;
end;

function TPedGeralM.GetVlrTotal: Double;
begin
  Result := fVlrTotal;
end;

procedure TPedGeralM.SetData(const Value: TDateTime);
begin
  FData := Value;
end;

procedure TPedGeralM.SetIdCliente(const Value: Integer);
begin
  FIdCliente := Value;
end;

procedure TPedGeralM.SetIdPedGeral(const Value: Integer);
begin
  FIdPedGeral := Value;
end;

procedure TPedGeralM.SetPedItem(const Value: TPedItemMList);
begin
  oPedItem := Value;
end;

procedure TPedGeralM.SetVlrTotal(const Value: Double);
begin
  FVlrTotal := Value;
end;

end.
