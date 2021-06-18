object FormCadastroClientes: TFormCadastroClientes
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 404
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 8
    Top = 51
    Width = 19
    Height = 13
    Caption = 'CPF'
  end
  object Label3: TLabel
    Left = 111
    Top = 51
    Width = 52
    Height = 13
    Caption = 'Identidade'
  end
  object Label4: TLabel
    Left = 238
    Top = 51
    Width = 42
    Height = 13
    Caption = 'Telefone'
  end
  object Label5: TLabel
    Left = 7
    Top = 91
    Width = 24
    Height = 13
    Caption = 'Email'
  end
  object Label6: TLabel
    Left = 7
    Top = 139
    Width = 19
    Height = 13
    Caption = 'CEP'
  end
  object Label7: TLabel
    Left = 7
    Top = 187
    Width = 55
    Height = 13
    Caption = 'Logradouro'
  end
  object Label8: TLabel
    Left = 7
    Top = 235
    Width = 37
    Height = 13
    Caption = 'N'#250'mero'
  end
  object Label9: TLabel
    Left = 63
    Top = 235
    Width = 65
    Height = 13
    Caption = 'Complemento'
  end
  object Label10: TLabel
    Left = 159
    Top = 235
    Width = 28
    Height = 13
    Caption = 'Bairro'
  end
  object Label11: TLabel
    Left = 7
    Top = 283
    Width = 33
    Height = 13
    Caption = 'Cidade'
  end
  object Label12: TLabel
    Left = 159
    Top = 283
    Width = 13
    Height = 13
    Caption = 'UF'
  end
  object Label13: TLabel
    Left = 208
    Top = 283
    Width = 19
    Height = 13
    Caption = 'Pais'
  end
  object btnCEP: TButton
    Left = 87
    Top = 156
    Width = 97
    Height = 25
    Caption = 'Obter Endere'#231'o'
    TabOrder = 6
    OnClick = btnCEPClick
  end
  object edtCEP: TMaskEdit
    Left = 8
    Top = 158
    Width = 73
    Height = 21
    EditMask = '00000\-999;0;_'
    MaxLength = 9
    TabOrder = 5
    Text = ''
  end
  object edtNome: TEdit
    Left = 8
    Top = 24
    Width = 321
    Height = 21
    TabOrder = 0
  end
  object edtIdentidade: TEdit
    Left = 111
    Top = 67
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtCPF: TMaskEdit
    Left = 8
    Top = 67
    Width = 95
    Height = 21
    EditMask = '000.000.000-00;0;_'
    MaxLength = 14
    TabOrder = 1
    Text = ''
  end
  object edtTelefone: TMaskEdit
    Left = 238
    Top = 67
    Width = 87
    Height = 21
    EditMask = '!\(99\)00000-0000;0;_'
    MaxLength = 14
    TabOrder = 3
    Text = ''
  end
  object edtEmail: TEdit
    Left = 8
    Top = 110
    Width = 321
    Height = 21
    TabOrder = 4
  end
  object edtLogradouro: TEdit
    Left = 8
    Top = 206
    Width = 321
    Height = 21
    TabOrder = 7
  end
  object edtNumero: TMaskEdit
    Left = 8
    Top = 254
    Width = 47
    Height = 21
    EditMask = '999999;0;_'
    MaxLength = 6
    TabOrder = 8
    Text = ''
  end
  object edtComplemento: TEdit
    Left = 63
    Top = 254
    Width = 84
    Height = 21
    TabOrder = 9
  end
  object edtBairro: TEdit
    Left = 159
    Top = 254
    Width = 170
    Height = 21
    TabOrder = 10
  end
  object edtCidade: TEdit
    Left = 8
    Top = 302
    Width = 139
    Height = 21
    TabOrder = 11
  end
  object edtEstado: TEdit
    Left = 159
    Top = 302
    Width = 34
    Height = 21
    TabOrder = 12
  end
  object edtPais: TEdit
    Left = 208
    Top = 302
    Width = 121
    Height = 21
    TabOrder = 13
  end
  object btnConfirma: TButton
    Left = 87
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Confirma'
    TabOrder = 14
    OnClick = btnConfirmaClick
  end
  object btnSair: TButton
    Left = 168
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 15
    OnClick = btnSairClick
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 272
    Top = 344
  end
end
