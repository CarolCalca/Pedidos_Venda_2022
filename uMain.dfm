object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'Pedidos'
  ClientHeight = 511
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      584
      41)
    object Label1: TLabel
      Left = 19
      Top = 3
      Width = 202
      Height = 35
      Caption = 'Pedidos de Venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -28
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object btnCarregar: TButton
      Left = 358
      Top = 10
      Width = 100
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Carregar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCarregarClick
    end
    object btnCancelar: TButton
      Left = 464
      Top = 10
      Width = 100
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancelar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 584
    Height = 429
    Align = alClient
    TabOrder = 1
    DesignSize = (
      584
      429)
    object Label2: TLabel
      Left = 41
      Top = 20
      Width = 39
      Height = 15
      Caption = 'Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 34
      Top = 56
      Width = 46
      Height = 15
      Caption = 'Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 15
      Top = 91
      Width = 65
      Height = 15
      Caption = 'Quantidade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 215
      Top = 91
      Width = 73
      Height = 15
      Caption = 'Valor unit'#225'rio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object btnAdicionar: TButton
      Left = 425
      Top = 83
      Width = 135
      Height = 25
      Caption = 'Adicionar Produto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnAdicionarClick
    end
    object dbgProdutos: TDBGrid
      Left = 5
      Top = 120
      Width = 571
      Height = 304
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dsProdutos
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick]
      TabOrder = 5
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = dbgProdutosKeyDown
    end
    object edtIdCliente: TEdit
      Left = 86
      Top = 14
      Width = 61
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 0
      OnChange = edtIdClienteChange
      OnExit = edtIdClienteExit
    end
    object edtIdProduto: TEdit
      Left = 86
      Top = 50
      Width = 61
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 1
      OnChange = edtIdProdutoChange
      OnExit = edtIdProdutoExit
    end
    object edtQtd: TEdit
      Left = 86
      Top = 85
      Width = 110
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 2
      Text = '0'
    end
    object edtValor: TEdit
      Left = 294
      Top = 85
      Width = 110
      Height = 21
      Hint = 'Preencha apenas com n'#250'meros.'
      Alignment = taRightJustify
      MaxLength = 12
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '0,00'
      OnExit = edtValorExit
    end
    object edtNomeCliente: TEdit
      Left = 153
      Top = 14
      Width = 407
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 6
    end
    object edtDescProduto: TEdit
      Left = 153
      Top = 50
      Width = 407
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 7
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 470
    Width = 584
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      584
      41)
    object Label6: TLabel
      Left = 19
      Top = 12
      Width = 104
      Height = 19
      Caption = 'Total do Pedido:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object lblTotal: TLabel
      Left = 129
      Top = 12
      Width = 49
      Height = 19
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object btnGravar: TButton
      Left = 464
      Top = 8
      Width = 100
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Gravar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnGravarClick
    end
  end
  object cdsProdutos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 217
    object cdsProdutosidpeditem: TIntegerField
      FieldName = 'idpeditem'
      Visible = False
    end
    object cdsProdutosidpedgeral: TIntegerField
      FieldName = 'idpedgeral'
      Visible = False
    end
    object cdsProdutosidproduto: TIntegerField
      DisplayLabel = 'Id'
      FieldName = 'idproduto'
      Visible = False
    end
    object cdsProdutosdescricao: TStringField
      DisplayLabel = 'Produto'
      DisplayWidth = 55
      FieldName = 'descricao'
      Size = 150
    end
    object cdsProdutosquantidade: TIntegerField
      DisplayLabel = 'Quantidade'
      FieldName = 'quantidade'
    end
    object cdsProdutosvlrunitario: TFloatField
      DisplayLabel = 'Valor Unit.'
      FieldName = 'vlrunitario'
      DisplayFormat = '#,###,###,##0.00'
      EditFormat = '#,###,###,##0.00'
    end
    object cdsProdutosvlrtotal: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'vlrtotal'
      DisplayFormat = '#,###,###,##0.00'
    end
  end
  object dsProdutos: TDataSource
    DataSet = cdsProdutos
    Left = 40
    Top = 217
  end
  object cdsProdDel: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 273
    object cdsProdDelidpeditem: TIntegerField
      FieldName = 'idpeditem'
    end
  end
end
