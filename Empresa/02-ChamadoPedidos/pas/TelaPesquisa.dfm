object frmTelaPesquisa: TfrmTelaPesquisa
  Left = 0
  Top = 0
  Caption = 'Pedidos Liberados'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlInfo: TPanel
    Left = 8
    Top = 8
    Width = 281
    Height = 283
    Caption = 'PnlInfo'
    Color = 6431516
    ParentBackground = False
    TabOrder = 0
    object LbOpcoes: TLabel
      Left = 32
      Top = 24
      Width = 47
      Height = 13
      Caption = 'LbOpcoes'
    end
    object LbRazouCod: TLabel
      Left = 32
      Top = 43
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object CbOpcoes: TComboBox
      Left = 32
      Top = 62
      Width = 145
      Height = 21
      TabOrder = 0
      Text = 'CbOpcoes'
    end
    object EdRazouCod: TEdit
      Left = 32
      Top = 89
      Width = 121
      Height = 21
      TabOrder = 1
      OnChange = EdRazouCodChange
    end
    object BttEncCa: TButton
      Left = 32
      Top = 116
      Width = 75
      Height = 25
      Caption = 'BttEncCa'
      TabOrder = 2
      OnClick = BttEncCaClick
    end
  end
  object PnlResul: TPanel
    Left = 295
    Top = 8
    Width = 332
    Height = 283
    Caption = 'Panel1'
    Color = 6431516
    ParentBackground = False
    TabOrder = 1
    object StringGrid: TStringGrid
      Left = 0
      Top = 0
      Width = 310
      Height = 265
      ColCount = 1
      DefaultColWidth = 20
      DrawingStyle = gdsGradient
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedRowDefAlign]
      TabOrder = 0
      OnClick = StringGridClick
      OnDrawCell = StringGridDrawCell
      OnEnter = StringGridEnter
      OnExit = StringGridExit
    end
  end
end
