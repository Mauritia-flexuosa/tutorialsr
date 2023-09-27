# - Objetivo: Ter em mãos um mapa de cobertura da vegetação para uma área de interesse.
# - Marcio B Cure - 27/07/2023

# - Registre-se no GEE em https://code.earthengine.google.com/register

# - Dados da Coleção 8 do Mapbiomas: https://brasil.mapbiomas.org/colecoes-mapbiomas/



library(tidyverse)
library(terra)

# 1. Carregar os dados
mb8 <- rast("/home/mcure/Documents/mapbiomas/mapbiomas-brazil-collection-80-parquenacionaldachapadadosveadeiros-2022.tif")

plot(mb8)

# 2. Manipular os dados
# Área de interesse
e <- ext(-47.698479618452235, -47.65407925834481, -14.128625804871116, -14.100489679244411)

mb8_cortado <- crop(mb8, e)

plot(mb8_cortado)
# 3. Fazer um mapa de cobertura da vegetação

# Nomear as categorias de cobertura
categorias <- mb8_cortado$classification_2022 %>%
  unique %>%
  rename(categorias = classification_2022) %>%
  add_column(Tipo_de_vegetação = c("Floresta", "Savana", "Campo úmido", "Campo", "Pastagem"))

levels(mb8_cortado) <- categorias

mb8c_df <- as.data.frame(x = mb8_cortado, xy = T)

plot(mb8_cortado)

mb8c_df %>%
  ggplot(aes(x = x, y = y, fill = classification_2022))+
  geom_tile()

# 4. Customizar o mapa

mb8c_df %>%
  ggplot(aes(x = x, y = y, fill = Tipo_de_vegetação))+
  geom_tile()+
  scale_fill_manual(values = c("#1f8d49", "#7dc975", "#519799", "#d6bc74", "#edde8e"))+
  labs(x = "Longitude", y= "Latitude", fill = "Cobertura", title = "Mapa Jardim de Maithrea - PNCV")+
  geom_point(x = -47.68, y = -14.125, size = 2, shape = 5)


# 5. Baixar a figura

png("mapa.png")
mapa
dev.off()
