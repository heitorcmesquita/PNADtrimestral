#Baixando arquivo .zip do site da PNAD IBGE
temp <- tempfile()
download.file("ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Tabelas/2020/2020_2_trimestre/pnadc_202002_tabelas_uf.zip", temp, mode = "wb")

#Estruturando a base que receberá os dados
basePNAD <- as.data.frame("")
basePNAD$Ano <- ""
basePNAD$Tri <- ""
basePNAD$Estimativa <- ""
basePNAD$Indicador <- ""
colnames(basePNAD)[1] <- "Sigla"

#  Carregando Planilhas auxiliares que permitirão o acesso às pastas de trabalhode cada UF, e que darão nome aos indicadores
ListaPNAD <- readxl::read_excel("Lista PNAD.xlsx", 1)
ListaIndicadores <- readxl::read_excel("Lista PNAD.xlsx", 2)

# Iteração 1: Navegando por cada pasta de trabalho (uma por UF) dentro do arquivo .zip baixado anteriormente
for (i in 1:length(ListaPNAD$`Lista dentro do arquivo zip`)){
  
# Iteração 2: Passando por cada planilha dentro da pasta de trabalho carregada
# na Iteração I. Cada planilha é um indicador 
  for (j in 9:78){

# Lendo a pasta de trabalho do estado [i] e a planilha do indicador [j]    
    buscar <- readxl::read_excel(unzip(temp, ListaPNAD$`Lista dentro do arquivo zip`[i]),j, skip = 7)

    # Eliminando linhas e colunas que não serão utilizadas, Renomenado colunas paraserem iguais à basePNAD criada anteriormente
    buscar <- head(buscar,-6)
    buscar <- buscar[, 1:5]
    colnames(buscar)[1] <- "Ano"
    colnames(buscar)[2] <- "Tri"
    buscar[3] <- NULL
    buscar[3] <- NULL
    colnames(buscar)[3] <- "Estimativa"

    # Colocando o nome do indicador ao lado do número
    buscar$Indicador <- ""
    buscar$Indicador <- ListaIndicadores$Indicador[j]

    # Colocando a Sigla da UF ao lado do indicador
    buscar$Sigla <- ""
    buscar$Sigla <- ListaPNAD$Sigla[i]

    # Unindo a base do indicador iterado à basePNAD
    basePNAD <- rbind(basePNAD, buscar)
    }
}

write.csv(basePNAD, "basePNAD.csv", row.names = FALSE)



