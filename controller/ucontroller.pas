Unit uController;

{$mode ObjFPC}{$H+}

Interface

Uses
  SysUtils,
  fpdf,
  fpjson,
  jsonparser,
  DataSet.Serialize,
  Horse;

Type

  { TMyFPDF }

  TMyFPDF = Class(TFPDF)
  Private
    Procedure Cabecalho;
    Procedure Infos;
    Procedure LinhaSIF;
    Procedure DadosBancarios;
    Procedure Observacoes;
    Procedure NotasDeRacao;
    Procedure Retangulo(vY: Double);
  Public
    Procedure Header; Override;
    Procedure Footer; Override;
    Class Procedure CreateNew;
  Const
    fpdir = 'C:\jpprojects\lazarus\FPDFLazarus\';
    fpfiledir = 'C:\jpprojects\lazarus\FPDFLazarus\files\';
  End;

Implementation

Var
  pdf:                                                          TMyFPDF;
  I:                                                            Integer;
  vW, vH, vY:                                                   Double;
  jsonObj, gCabecalho, gInformacoes, gDoencas, gDadosBancarios: TJSONObject;
  jsonData:                                                     TJSONData;
  gObservacoes:                                                 TJSONString;
  gNotasDeRacao:                                                TJSONArray;

Procedure TMyFPDF.Retangulo(vY: Double);
Begin
  Rect(10, vY, 190, GetY - vY);
End;

Procedure TMyFPDF.Cabecalho;
Begin
  vH := 6;
  vW := 190 / 3;

  SetFont('', 'B');
  Cell(GetStringWidth('NUMERO DO LOTE:') + 2, vH, 'NUMERO DO LOTE:');
  Cell(GetStringWidth(gCabecalho.Get('lote')) + 2, vH, gCabecalho.Get('lote'));
  Cell(4, vH, '-', '0', 0, 'C');
  Cell(GetStringWidth(gCabecalho.Get('nomeCliente')) + 2, vH, gCabecalho.Get('nomeCliente'));
  Cell(4, vH, '-', '0', 0, 'C');
  Cell(GetStringWidth('GALPAO') + 2, vH, 'GALPAO');
  Cell(GetStringWidth(gCabecalho.Get('galpao')) + 2, vH, gCabecalho.Get('galpao'), '0', 1);

  SetFont('', '');
  Cell(vW, vH, 'Endereço: ' + gCabecalho.Get('endereco'));
  Cell(vW, vH, 'Aves/m²: ' + gCabecalho.Get('avesM2'), '0', 0, 'R');
  Cell(vW, vH, 'Largura Galpão: ' + gCabecalho.Get('larguraGalpao'), '0', 1, 'R');

  Cell(vW, vH, 'Cidade: ' + gCabecalho.Get('cidade'));
  Cell(vW, vH, 'CPF: ' + gCabecalho.Get('cpf'), '0', 0, 'R');
  Cell(vW, vH, 'Comp. Galpão: ' + gCabecalho.Get('comprimentoGalpao'), '0', 1, 'R');

  Cell(vW, vH, 'Encerrado em: ' + gCabecalho.Get('dataEncerramento'));
  Cell(vW, vH, 'Vencimento: ' + gCabecalho.Get('vencimento'), '0', 0, 'R');
  Cell(vW, vH, 'Nro Inscrição: ' + gCabecalho.Get('numeroInscricao'), '0', 1, 'R');

  Cell(190 / 4, vH, 'Peso médio C/7 Dias: ' + gCabecalho.Get('pesoMedio7Dias'));
  Cell(190 / 4, vH, 'C/14 Dias: ' + gCabecalho.Get('pesoMedio14Dias'));
  Cell(190 / 4, vH, 'C/21 Dias: ' + gCabecalho.Get('pesoMedio21Dias'));
  Cell(190 / 4, vH, 'C/28 Dias: ' + gCabecalho.Get('pesoMedio28Dias'), '0', 1);

  Cell(vW, vH, 'Fornecedor de pintinhos: ' + gCabecalho.Get('fornecedorPintinhos'));
  Cell(vW, vH, 'Idade Matriz: ' + gCabecalho.Get('idadeMatriz'), '0', 0, 'R');
  Cell(vW, vH, 'PM Aloj.: ' + gCabecalho.Get('pmaloj'), '0', 1, 'R');

  Cell(190 / 2, vH, 'Lotes Sobre a Cama: ' + gCabecalho.Get('lotesSobreCama'));
  Cell(190 / 2, vH, 'Tabela de Remuneração: ' + gCabecalho.Get('tabelaRemuneracao'), '0', 1, 'R');
End;

Procedure TMyFPDF.Header;
Begin
  SetFont('Arial', 'B', 12);
  Image(fpfiledir + 'logo.png', 10, 4, 30); // TROCAR LOGO
  Cell(30);
  Cell(120, -7, 'RESUMO DOS DADOS POR LOTES E PERÍODO', '0', 0, 'C');
  SetFont('Arial', 'BI', 7);
  Cell(0, -9, Format('Emissão: %s', [DateTimeToStr(Now)]), '0', 0, 'R');
  Ln(2);

  vY := GetY;

  Cabecalho;

  Retangulo(vY);
End;

Procedure TMyFPDF.Infos;
Var
  vListaInfos: TStringArray;
Begin
  vW := 190 / 4;
  vH := 6;
  vY := GetY;

  vListaInfos := ['Data de Entrada: ', 'Mortalidade (%): ', 'Quantidade de Aves: ',
    'Peso Bruto: ', 'Linhagem: ', 'Sexo: ', 'Viabilidade', 'Morte Inicial: ',
    'Peso Médio: ', 'Premix: ', 'Conversão Alimentar: ', 'Técnico: ', 'C.A.A.: ',
    'Ração Pré-Inicial: ', 'C.A.A. / Média (Últimos 28 dias): ', 'Ração Inicial: ',
    'Dif C.A.A. / Média: ', 'Ração Crescimento 1: ', 'Adição R$/C.A.A.: ',
    'Ração Crescimento 2: ', 'G.P.D.: ', 'Ração Final: ', 'Idade Média (Dias): ',
    'Retorno (DEF): ', 'Fator Produção: ', 'R$ Vac, Med, Desinf, Outros: ',
    'Total Apanhadas: ', 'R$ Medicamentos e Insumos por Kg: ', 'Total Consumidas: ',
    'Total Ração: ', 'Valor p/ Cabeça: ', 'Adiantamento: ', 'Total Bruto: ',
    'Desconto: ', 'Contribuição Sindical ( - ): ', 'Bonificação Calo de Pé ( + ): ',
    'Bonificação Check List ( + ): ', 'Bonificação Por Melhoria ( + ): ',
    'Valor p/ Cabeça Final: ', 'Total Líquido: '];

  SetFont('', '');
  For I := 0 To High(vListaInfos) Do
    If I >= 34 Then
    Begin
      If vListaInfos[I] = 'Total Líquido: ' Then
      Begin
        SetFont('', 'B');
        Cell(vW * 2, vH);
        Cell(vW, vH, vListaInfos[I]);
        Cell(vW, vH, gInformacoes.Items[I].Value, '0', 1, 'R');
      End
      Else
      Begin
        Cell(vW * 2, vH);
        Cell(vW, vH, vListaInfos[I]);
        Cell(vW, vH, gInformacoes.Items[I].Value, '0', 1, 'R');
      End;
    End
    Else If (I Mod 2) <> 0 Then
    Begin
      Cell(vW, vH, vListaInfos[I]);
      Cell(vW, vH, gInformacoes.Items[I].Value, '0', 1, 'R');
    End
    Else
    Begin
      Cell(vW, vH, vListaInfos[I]);
      Cell(vW, vH, gInformacoes.Items[I].Value, '0', 0, 'R');
    End;

  Retangulo(vY);
End;

Procedure TMyFPDF.LinhaSIF;
Var
  vListaInfos: TStringArray;
Begin
  vH := 6;
  vW := 190 / 10;
  vY := GetY;
  SetFont('Arial', 'B', 8);

  Cell(0, vH - 2, '"Condenação de Linhas SIF em (%)"', '0', 1);

  vListaInfos := ['Cont. Asa', 'Cont. Coxa', 'Check List', 'Calo Pé', 'Calo Peito',
    'Celulite', 'Dermatose', 'Papo Cheio', 'Artrite', 'Aerossaculite'];

  SetFont('Arial', '');

  For I := 0 To High(vListaInfos) Do
    If I = High(vListaInfos) Then
      Cell(vW, vH, vListaInfos[I], '0', 1, 'C')
    Else
      Cell(vW, vH, vListaInfos[I], '0', 0, 'C');

  For I := 0 To Pred(gDoencas.Count) Do
    If gDoencas.Items[I].Value = '' Then
      If I = Pred(gDoencas.Count) Then
        Cell(vW, vH, '0', '0', 1, 'C')
      Else
        Cell(vW, vH, '0', '0', 0, 'C')

    Else
    If I = Pred(gDoencas.Count) Then
      Cell(vW, vH, gDoencas.Items[I].Value, '0', 1, 'C')
    Else
      Cell(vW, vH, gDoencas.Items[I].Value, '0', 0, 'C');

  Retangulo(vY);
End;

Procedure TMyFPDF.DadosBancarios;
Begin
  vH := 6;
  vY := GetY;

  SetFont('Arial', 'B');
  Cell(36, vH, 'Dados Bancários:', '0');

  SetFont('Arial', '');
  Cell(26, vH, 'Banco:', '0');
  Cell(20, vH, gDadosBancarios.Get('banco'), '0', 1);

  Cell(36);
  Cell(26, vH, 'Agência:', '0');
  Cell(20, vH, gDadosBancarios.Get('agencia'), '0', 1);

  Cell(36);
  Cell(26, vH, 'Conta-Corrente:', '0');
  Cell(20, vH, gDadosBancarios.Get('contaCorrente'), '0', 1);

  Retangulo(vY);
End;

Procedure TMyFPDF.Observacoes;
Begin
  vH := 20;
  vY := GetY;

  SetFont('Arial', 'B');
  Cell(26, vH, 'Observações:', '0');
  SetFont('Arial', '');
  multicell(0, vH, WrapText(gObservacoes.Value, 110));

  Retangulo(vY);
End;

Procedure TMyFPDF.NotasDeRacao;
Var
  P:                                Integer;
  qtdTotal, consumoTotal, vlrTotal: Double;
  lista:                            TStringArray;
  lJson:                            TJSONObject;
  q, c, v:                          String;
Begin
  vW := 190 / 8;
  vH := 6;
  vY := GetY;

  SetFont('', 'B');
  Cell(0, vH, 'Relação de Despesas', '0', 1, 'C');
  Retangulo(vY);

  vY := GetY;
  Cell(97, vH, 'Valor Total:', '0', 0, 'R');
  Cell(93, vH, '0,00', '0', 1, 'L');
  Retangulo(vY);

  vY := GetY;
  Cell(0, vH, 'Notas de Ração', '0', 1, 'C');

  lista := ['Data', 'Ração', 'Nota', 'Quantidade', 'Consumo', 'Vlr. Unitário', 'Vlr. Total'];
  For I := 0 To High(lista) Do
    If lista[I] = 'Ração' Then
      Cell(vW * 2, vH, lista[I])
    Else
      Cell(vW, vH, lista[I]);

  Ln();
  Retangulo(vY);

  qtdTotal     := 0;
  consumoTotal := 0;
  vlrTotal     := 0;

  SetFont('', '');
  For I := 0 To Pred(gNotasDeRacao.Count) Do
  Begin
    lJson        := gNotasDeRacao.Items[I] As TJSONObject;
    q            := lJson.Get('quantidade');
    c            := lJson.Get('consumo');
    v            := lJson.Get('valorTotal');
    qtdTotal     := (qtdTotal + StrToFloat(q.Replace('.', '').Replace(',', '')));
    consumoTotal := (consumoTotal + StrToFloat(c.Replace('.', '').Replace(',', '')));
    vlrTotal     := (vlrTotal + StrToFloat(v.Replace('.', '').Replace(',', '')));
    For P := 0 To 6 Do
      If lista[P] = 'Ração' Then
        Cell(190 / 4, vH, lJson.Items[P].Value)
      Else If P = 0 Then
        Cell(190 / 8, vH, lJson.Items[P].Value, 'L')
      Else If P = 6 Then
        Cell(190 / 8, vH, lJson.Items[P].Value, 'R', 1)
      Else
        Cell(190 / 8, vH, lJson.Items[P].Value);

  End;

  qtdTotal     := qtdTotal / 100;
  consumoTotal := consumoTotal / 100;
  vlrTotal     := vlrTotal / 100;
  Line(10, GetY, 200, GetY);

  vY := GetY;
  SetFont('', 'B');
  Cell(69);
  Cell(GetStringWidth('Quantidade Total:') + 3, vH, 'Quantidade Total:');
  Cell(17, vH, qtdTotal.ToString);
  Cell(GetStringWidth('Consumo Total:') + 3, vH, 'Consumo Total:');
  Cell(17, vH, consumoTotal.ToString);
  Cell(GetStringWidth('Valor Total:') + 3, vH, 'Valor Total:');
  Cell(17, vH, vlrTotal.ToString);
  Retangulo(vY);

End;

Procedure TMyFPDF.Footer;
Begin
  vW := 190 / 3;
  vH := 10;
  SetY(-15); // Position at 1.5 cm from bottom
  SetFont('Arial', 'I', 7);
  Cell(vW, vH, 'Avesoft - Frango de Corte', '0', 0, 'L');
  Cell(vW, vH, Format('%s', [IntToStr(pdf.PageNo())]), '0', 0, 'C');
  Cell(vW, vH, 'Avecom - (34) 3235 - 4982', '0', 0, 'R');
End;

Procedure GetPDF(Req: THorseRequest; Res: THorseResponse);
Begin
  jsonData := GetJSON(Req.Body);
  jsonObj  := jsonData As TJSONObject;

  gCabecalho      := TJSONObject.Create;
  gCabecalho      := jsonObj.Elements['cabecalho'] As TJSONObject;
  gInformacoes    := jsonObj.Elements['informacoes'] As TJSONObject;
  gDoencas        := jsonObj.Elements['doencas'] As TJSONObject;
  gDadosBancarios := jsonObj.Elements['dadosBancarios'] As TJSONObject;
  gObservacoes    := jsonObj.Elements['observacoes'] As TJSONString;
  gNotasDeRacao   := jsonObj.Elements['notasDeRacao'] As TJSONArray;

  pdf := TMyFPDF.Create();
  Try
    pdf.AddPage();
    pdf.Infos;
    pdf.LinhaSIF;
    pdf.DadosBancarios;
    pdf.Observacoes;
    pdf.NotasDeRacao;
    pdf.SetFont('Arial', '', 9);
    pdf.SaveToFile(pdf.fpdir + 'resumo-dados-lotes-periodos.pdf');
  Finally
    FreeAndNil(pdf);
  End;

  Res.ContentType('application/json').Send(jsonData.AsJSON);
End;

Class Procedure TMyFPDF.CreateNew;
Begin
  THorse.Get('/download-pdf', @GetPDF);
End;

End.
