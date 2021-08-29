object fClientes: TfClientes
  Left = 0
  Top = 0
  Caption = ' Clientes'
  ClientHeight = 403
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object LabelNome: TLabel
    Left = 28
    Top = 28
    Width = 32
    Height = 14
    Caption = 'Nome'
  end
  object LabelIdentidade: TLabel
    Left = 28
    Top = 56
    Width = 59
    Height = 14
    Caption = 'Identidade'
  end
  object LabelCPF: TLabel
    Left = 302
    Top = 56
    Width = 20
    Height = 14
    Caption = 'CPF'
  end
  object LabelTelefone: TLabel
    Left = 28
    Top = 84
    Width = 49
    Height = 14
    Caption = 'Telefone'
  end
  object LabelEmail: TLabel
    Left = 28
    Top = 112
    Width = 27
    Height = 14
    Caption = 'Email'
  end
  object EditNome: TEdit
    Left = 97
    Top = 25
    Width = 400
    Height = 22
    TabOrder = 0
  end
  object EditIdentidade: TEdit
    Left = 97
    Top = 53
    Width = 160
    Height = 22
    TabOrder = 1
  end
  object EditCPF: TEdit
    Left = 337
    Top = 53
    Width = 160
    Height = 22
    TabOrder = 2
  end
  object EditTelefone: TEdit
    Left = 97
    Top = 81
    Width = 160
    Height = 22
    TabOrder = 3
  end
  object EditEmail: TEdit
    Left = 97
    Top = 109
    Width = 400
    Height = 22
    TabOrder = 4
  end
  object GroupBoxEndereco: TGroupBox
    Left = 28
    Top = 145
    Width = 469
    Height = 209
    Caption = ' Endere'#231'o '
    TabOrder = 5
    object LabelCEP: TLabel
      Left = 12
      Top = 29
      Width = 21
      Height = 14
      Caption = 'CEP'
    end
    object LabelLogradouro: TLabel
      Left = 12
      Top = 57
      Width = 62
      Height = 14
      Caption = 'Logradouro'
    end
    object LabelNumero: TLabel
      Left = 12
      Top = 85
      Width = 43
      Height = 14
      Caption = 'Numero'
    end
    object LabelComplemento: TLabel
      Left = 172
      Top = 85
      Width = 76
      Height = 14
      Caption = 'Complemento'
    end
    object LabelBairro: TLabel
      Left = 12
      Top = 113
      Width = 30
      Height = 14
      Caption = 'Bairro'
    end
    object LabelCidade: TLabel
      Left = 12
      Top = 141
      Width = 36
      Height = 14
      Caption = 'Cidade'
    end
    object LabelPais: TLabel
      Left = 12
      Top = 169
      Width = 20
      Height = 14
      Caption = 'Pa'#237's'
    end
    object LabelUF: TLabel
      Left = 396
      Top = 141
      Width = 14
      Height = 14
      Caption = 'UF'
    end
    object ButtonBuscarCEP: TButton
      Left = 162
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = ButtonBuscarCEPClick
    end
    object EditCEP: TDBEdit
      Left = 83
      Top = 26
      Width = 73
      Height = 22
      DataField = 'CEP'
      DataSource = ds_dados
      TabOrder = 0
    end
    object EditLogradouro: TDBEdit
      Left = 83
      Top = 54
      Width = 374
      Height = 22
      DataField = 'Logradouro'
      DataSource = ds_dados
      TabOrder = 2
    end
    object EditNumero: TDBEdit
      Left = 83
      Top = 82
      Width = 73
      Height = 22
      DataSource = ds_dados
      TabOrder = 3
    end
    object EditComplemento: TDBEdit
      Left = 254
      Top = 82
      Width = 203
      Height = 22
      DataField = 'Complemento'
      DataSource = ds_dados
      TabOrder = 4
    end
    object EditBairro: TDBEdit
      Left = 83
      Top = 110
      Width = 374
      Height = 22
      DataField = 'Bairro'
      DataSource = ds_dados
      TabOrder = 5
    end
    object EditCidade: TDBEdit
      Left = 83
      Top = 138
      Width = 295
      Height = 22
      DataField = 'Localidade'
      DataSource = ds_dados
      TabOrder = 6
    end
    object EditPais: TDBEdit
      Left = 83
      Top = 166
      Width = 295
      Height = 22
      DataSource = ds_dados
      TabOrder = 7
    end
    object ComboBoxUF: TDBComboBox
      Left = 416
      Top = 138
      Width = 41
      Height = 22
      DataField = 'UF'
      DataSource = ds_dados
      Items.Strings = (
        'AC'
        'AL'
        'AM'
        'AP'
        'BA'
        'CE'
        'DF'
        'ES'
        'GO'
        'MA'
        'MG'
        'MS'
        'MT'
        'PA'
        'PB'
        'PE'
        'PI'
        'PR'
        'RJ'
        'RN'
        'RO'
        'RR'
        'RS'
        'SC'
        'SE'
        'SP'
        'TO')
      TabOrder = 8
    end
  end
  object ButtonSalvar: TButton
    Left = 341
    Top = 367
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 6
    OnClick = ButtonSalvarClick
  end
  object ButtonCancelar: TButton
    Left = 422
    Top = 367
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 7
    OnClick = ButtonCancelarClick
  end
  object ButtonEnviarEmail: TButton
    Left = 28
    Top = 367
    Width = 83
    Height = 25
    Caption = 'Enviar e-mail'
    TabOrder = 8
    OnClick = ButtonEnviarEmailClick
  end
  object cds_dados: TClientDataSet
    PersistDataPacket.Data = {
      F70000009619E0BD010000001800000008000000000003000000F70003434550
      01004900000001000557494454480200020009000A4C6F677261646F75726F01
      00490000000100055749445448020002003C000B436F6D706C656D656E746F01
      00490000000100055749445448020002003C0002554601004900000001000557
      494454480200020002000642616972726F010049000000010005574944544802
      0002003C00044942474501004900000001000557494454480200020014000755
      6E69646164650100490000000100055749445448020002003C000A4C6F63616C
      69646164650100490000000100055749445448020002003C000000}
    Active = True
    Aggregates = <>
    IndexFieldNames = 'cep'
    Params = <>
    Left = 379
    Top = 136
    object cds_dadosCEP: TStringField
      FieldName = 'CEP'
      Size = 9
    end
    object cds_dadosUF: TStringField
      FieldName = 'UF'
      Size = 2
    end
    object cds_dadosBairro: TStringField
      FieldName = 'Bairro'
      Size = 60
    end
    object cds_dadosLocalidade: TStringField
      FieldName = 'Localidade'
      Size = 60
    end
    object cds_dadosLogradouro: TStringField
      FieldName = 'Logradouro'
      Size = 60
    end
    object cds_dadosComplemento: TStringField
      FieldName = 'Complemento'
      Size = 60
    end
    object cds_dadosIBGE: TStringField
      FieldName = 'IBGE'
    end
    object cds_dadosUnidade: TStringField
      FieldName = 'Unidade'
      Size = 60
    end
  end
  object ds_dados: TDataSource
    DataSet = cds_dados
    Left = 427
    Top = 136
  end
end
