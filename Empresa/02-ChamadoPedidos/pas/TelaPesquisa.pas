unit TelaPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Math;

type
  TLPedidos = class(TCollectionItem)
  public
      PedidoDados,
      PedidoNumero,
      PedidoDataLiberacao,
      PedidoRazaoSocial: String;
  end;

  TfrmTelaPesquisa = class(TForm)
    PnlInfo: TPanel;
    PnlResul: TPanel;
    LbOpcoes: TLabel;
    LbRazouCod: TLabel;
    CbOpcoes: TComboBox;
    EdRazouCod: TEdit;
    BttEncCa: TButton;
    StringGrid: TStringGrid;
    procedure BttEncCaClick(Sender: TObject);
    procedure EdRazouCodChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure StringGridClick(Sender: TObject);
    procedure StringGridEnter(Sender: TObject);
    procedure StringGridExit(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    CPedidos: TLPedidos;
    LPedidos: TCollection;
    Var Opera: Integer;
    Function FILTER(a: STRING):STRING;
  public
    { Public declarations }
    Procedure RESIZEDBGRID;
  end;

var
  frmTelaPesquisa: TfrmTelaPesquisa;

implementation

{$R *.dfm}

uses ConexaoQuery, TelaPrincipal, TelaPedidos;

function tbKeyIsDown(const Key: Integer): Boolean;
begin
  Result:= GetKeyState(Key) and 128 > 0;
end;

function AjustarStr(S: String; T: Integer): String;
begin
    while Length(S) < T do begin
          S:= S+' ';
          if Length(S) < T then begin
             S:= Copy(S, 1, T);
          end;
    end;
    Result:= S;
    S:= '';
end;

function TfrmTelaPesquisa.FILTER(a: STRING): STRING;
var
    I: integer;
begin
    with StringGrid do begin
         Options:= [goRowSelect, goRangeSelect];
         Align:= AlClient;
         with Font do begin
              Size:= 13;
              Name:= 'Courier New';
              Color:= RGB(028,035,098);
         end;
         ColCount:= 5;
         RowCount:= 2;
         FixedRows:= 1;
         Selection:= TGridrect(Rect(4,1,4,1));
         DefaultRowHeight:= 20;
         ColWidths[00]:= Width;
         ColWidths[01]:= 0;
         ColWidths[02]:= 0;
         ColWidths[03]:= 0;
         ColWidths[04]:= 0;
         for I := 0 to RowCount -1 do Rows[I].Clear;
         LPedidos:= TCollection.Create(TLPedidos);
         with LPedidos do begin
              Clear;
              CPedidos:= TLPedidos(Add);
              with CPedidos do begin
                   PedidoDados:= AjustarStr('Pedido',07)+
                                 AjustarStr(' � ',3)+
                                 AjustarStr('Data Libera��o',19)+
                                 AjustarStr(' � ',3)+
                                 AjustarStr('Nome Raz�o Social',0)
                                 ;
              end;
              with DM do begin
                   with FDQuery1 do begin
                        Close;
                        with SQL do begin
                             Clear;
                             Add('SELECT "CodPedido","DtaLib","RazaoSocial" '
                                +'FROM cadan."CLILIBERADOS" '
                                +'WHERE 1=1'
                             );
                             case Opera of
                                  0: Add('AND "RazaoSocial" LIKE '''+PrimeiraLetraMaiusculaNome(a)+'%'' ');
                                  1: Add('AND "CodPedido" LIKE '''+PrimeiraLetraMaiusculaNome(a)+'%'' ');
                             end;
                             Add('ORDER BY "RazaoSocial" ASC');
                             Prepared:= True;
                             Open;
                             if not IsEmpty then begin
                                    Enabled:= True;
                                    First;
                                    while not Eof do begin
                                              with LPedidos do begin
                                                   CPedidos:= TLPedidos(Add);
                                                   with CPedidos do begin
                                                        PedidoNumero:= FormatFloat('0000000', StrToFloat(Fields[00].AsString));
                                                        PedidoDataLiberacao:= Fields[01].AsString;
                                                        PedidoRazaoSocial:= Fields[02].AsString;
                                                        PedidoDados:= AjustarStr(PedidoNumero,7)+
                                                                      AjustarStr(' � ',3)+
                                                                      AjustarStr(PedidoDataLiberacao,19)+
                                                                      AjustarStr(' � ',3)+
                                                                      AjustarStr(PedidoRazaoSocial,0)
                                                                      ;
                                                   end;
                                              end;
                                              Next;
                                    end;
                             end else begin
                                 with LPedidos do begin
                                      CPedidos:= TLPedidos(Add);
                                      CPedidos.PedidoDados:= '';
                                 end;
                             end;
                        end;
                        Close;
                   end;
                   for I:= 0 to Count - 1 do begin
                       RowCount:= Count;
                       with TLPedidos(Items[I]) do begin
                            Cells[00,I]:= PedidoDados;
                            Cells[01,I]:= PedidoNumero;
                            Cells[02,I]:= PedidoDataLiberacao;
                            Cells[03,I]:= PedidoRazaoSocial;
                            Cells[04,I]:= '';
                       end;
                   end;
              end;
         end;
    end;
end;

procedure TfrmTelaPesquisa.RESIZEDBGRID;
var
    I: integer;
begin
    if Length(Trim(EdRazouCod.Text)) = 0 then begin
        with StringGrid do begin
             Options:= [goRowSelect, goRangeSelect];
             Align:= AlClient;
             with Font do begin
                  Size:= 13;
                  Name:= 'Courier New';
                  Color:= RGB(028,035,098);
             end;
             ColCount:= 5;
             RowCount:= 2;
             FixedRows:= 1;
             Selection:= TGridrect(Rect(4,1,4,1));
             DefaultRowHeight:= 20;
             ColWidths[00]:= Width;
             ColWidths[01]:= 0;
             ColWidths[02]:= 0;
             ColWidths[03]:= 0;
             ColWidths[04]:= 0;
             for I := 0 to RowCount -1 do Rows[I].Clear;
             LPedidos:= TCollection.Create(TLPedidos);
             with LPedidos do begin
                  Clear;
                  CPedidos:= TLPedidos(Add);
                  with CPedidos do begin
                       PedidoDados:= AjustarStr('Pedido',07)+
                                     AjustarStr(' � ',3)+
                                     AjustarStr('Data Libera��o',19)+
                                     AjustarStr(' � ',3)+
                                     AjustarStr('Nome Raz�o Social',0)
                                     ;
                  end;
                  with DM do begin
                       with FDQuery1 do begin
                            Close;
                            with SQL do begin
                                 Clear;
                                 Add('SELECT "CodPedido","DtaLib","RazaoSocial" '
                                    +'FROM cadan."CLILIBERADOS" '
                                    +'WHERE 1=1 '
                                    +'ORDER BY "RazaoSocial" ASC'
                                 );
                                 Prepared:= True;
                                 Open;
                                 if not IsEmpty then begin
                                        Enabled:= True;
                                        First;
                                        while not Eof do begin
                                                  with LPedidos do begin
                                                       CPedidos:= TLPedidos(Add);
                                                       with CPedidos do begin
                                                            PedidoNumero:= FormatFloat('0000000', StrToFloat(Fields[00].AsString));
                                                            PedidoDataLiberacao:= Fields[01].AsString;
                                                            PedidoRazaoSocial:= Fields[02].AsString;
                                                            PedidoDados:= AjustarStr(PedidoNumero,7)+
                                                                          AjustarStr(' � ',3)+
                                                                          AjustarStr(PedidoDataLiberacao,19)+
                                                                          AjustarStr(' � ',3)+
                                                                          AjustarStr(PedidoRazaoSocial,0)
                                                                          ;
                                                       end;
                                                  end;
                                                  Next;
                                        end;
                                 end else begin
                                     with LPedidos do begin
                                          CPedidos:= TLPedidos(Add);
                                          CPedidos.PedidoDados:= '';
                                     end;
                                 end;
                            end;
                            Close;
                       end;
                       for I:= 0 to Count - 1 do begin
                           RowCount:= Count;
                           with TLPedidos(Items[I]) do begin
                                Cells[00,I]:= PedidoDados;
                                Cells[01,I]:= PedidoNumero;
                                Cells[02,I]:= PedidoDataLiberacao;
                                Cells[03,I]:= PedidoRazaoSocial;
                                Cells[04,I]:= '';
                           end;
                       end;
                   end;
             end;
        end;
    end;
end;

procedure TfrmTelaPesquisa.StringGridClick(Sender: TObject);
begin
    with StringGrid do begin
         if tbKeyIsDown(VK_CONTROL) then begin
            Cells[4, Row]:= 'x';
         end else begin
             Cells[4, Row]:= '';
         end;
    end;
end;

procedure TfrmTelaPesquisa.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
    Status: string;
begin
    with StringGrid do begin
         Status:= Trim(Cells[04, Arow]);
         with Canvas do begin
              with Font do begin
                   Color:= clBlack;
                   Style:= [];
                   if Status = 'x' then begin
                      Color:= clRed;
                      Style:= [TFontStyle.fsBold];
                   end;
              end;
              FillRect(Rect);
              TextOut(Rect.Left + 6, Rect.Top, Cells[ACol, ARow]);
         end;
    end;
end;

procedure TfrmTelaPesquisa.StringGridEnter(Sender: TObject);
begin
    frmPrincipal.Timer1.Enabled:= False;
end;

procedure TfrmTelaPesquisa.StringGridExit(Sender: TObject);
begin
    frmPrincipal.Timer1.Enabled:= True;
end;

procedure TfrmTelaPesquisa.BttEncCaClick(Sender: TObject);
var
    Row_Selected: String;
    I,
    GridTop,
    GridBotton: Integer;
begin
    case CbOpcoes.ItemIndex of
         0: Operacao:= 3;
         1: Operacao:= 4;
    end;
    with StringGrid do begin
         GridTop:= 1;
         GridBotton:= RowCount - 1;
         for I:= GridTop to GridBotton do begin
             Row_Selected:= Cells[01, I];
             if Cells[04, I] = 'x' then begin
                DM.EncaminharCaixa(Row_Selected);
             end;
         end;
    end;
    if Length(Trim(EdRazouCod.Text)) <> 0 then
       EdRazouCod.OnChange(Self)
    else
        RESIZEDBGRID;
end;

procedure TfrmTelaPesquisa.EdRazouCodChange(Sender: TObject);
begin
     if Length(Trim(EdRazouCod.Text)) <> 0 then begin
         case CbOpcoes.ItemIndex of
              0:begin
                Opera:= 0;
                FILTER(EdRazouCod.Text);
              end;
              1:begin
                Opera:= 1;
                FILTER(EdRazouCod.Text);
              end;
         end;
     end;
end;

procedure TfrmTelaPesquisa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    frmPrincipal.PopupMenu.Items.Find('Pedidos Liberados').Enabled:= True;
end;

procedure TfrmTelaPesquisa.FormCreate(Sender: TObject);
Var
  LargScreen,
  AltScreen:Integer;
  Larg_PnInfo,
  Tam_Font_PnInfo:String;
begin
  LargScreen:= Screen.Width;
  AltScreen:= Screen.Height;

  windowState:= wsMaximized;

  ClientHeight:=AltScreen;
  ClientWidth:=LargScreen;
  With PnlInfo do begin
      Left:= 5;
      Larg_PnInfo:= FloatToStr(Round(LargScreen * Power(3,-1)));
      Tam_Font_PnInfo:= FloatToStr(Round(StrToFloat(Larg_PnInfo) * Power(20,-1)));
      width:= LargScreen div 3; //strtoInt(Larg_PnInfo);
      Height:= AltScreen - 80;
      Caption:='';
      KeyPreview:= True;
      Color:= $0062231C;
      with Font do begin
           Size:= StrToInt(Tam_Font_PnInfo);
           Style:= [fsBold];
      end;

      with LbOpcoes do begin
          Top:= 5;
          Left:= 25;
          Caption:= 'Escolha uma das op��es:';
          Font.Color:= $0000B9FB;
          Visible:= True;
      end;

      with CbOpcoes do begin
          Top:= LbOpcoes.Top + LbOpcoes.Height + 15;
          Left:= LbOpcoes.Left;
          Width:= LbOpcoes.Width;

          Items.Add('Raz�o Social');
          Items.Add('C�digo do Pedido');
          Style:= csDropDownList;
          ItemIndex:=0;
          Visible:= True;
      end;

      with LbRazOuCod do begin
          Top:= CbOpcoes.Top + CbOpcoes.Height + 15;
          Left:= LbOpcoes.Left;
          Caption:= 'Preencha o campo abaixo'
                   +#13
                   +'de acordo com a escolha'
                   +#13
                   +'acima.';
                   Font.Color:= $0000B9FB;
          Visible:= True;
      end;

      with EdRazOuCod do begin
          Top:= LbRazOuCod.Top + LbRazOuCod.Height + 15;
          Left:= LbOpcoes.Left;
          Width:= CbOpcoes.Width;
          CharCase:= ecUpperCase;
          Text:= '';
          Visible:= True;
      end;

      with BttEncCa do begin
          Top:= EdRazOuCod.Top + EdRazOuCod.Height + 15;
          Left:= LbOpcoes.Left;
          Width:= CbOpcoes.Width;
          Height:= CbOpcoes.Height * 2;
          Caption:= 'Encaminhar ao caixa';
          Visible:= True;
      end;
  end;

  with PnlResul do begin
        Left:= 5 + PnlInfo.Left + PnlInfo.Width;
        Width:= LargScreen - PnlInfo.Width - 15;
        Height:= PnlInfo.Height;
        Color:= $0062231C;
  end;

end;

procedure TfrmTelaPesquisa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    frmTelaPesquisa.Close
  end;

  if Key = VK_F1 then
  begin
    EdRazOuCod.Clear;
  end;
end;

procedure TfrmTelaPesquisa.FormShow(Sender: TObject);
begin
    RESIZEDBGRID;
    MakeFullyVisible(Screen.Monitors[0]);
end;

end.