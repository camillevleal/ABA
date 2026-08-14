# install.packages(c("tidyverse", "sf", "rnaturalearth", "rnaturalearthdata"))
library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Exemplo de dados (substitua pelos seus)
sites <- tibble::tribble(
  ~site, ~lon, ~lat, ~motu_richness, ~n_samples,
  "Alderdice",-92.0,28.1,6,8,
  "Blake Escarpment Mid",-77.2,31.5,2,2,
  "Blake Escarpment North",-76.9,32.1,1,1,
  "Blake Escarpment South",-77.3,30.9,2,2,
  "Blake Plateau South",-79.0,28.4,3,4,
  "Blake Spur Wall",-76.2,30.2,2,3,
  "Bright",-93.3,27.9,10,13,
  "Canaveral Deep",-79.6,28.2,1,4,
 "Deep Mound 2 - Blake Plateau",-77.3,30.8,1,3,
 "DeSoto 04 (DSR04)",-87.3,29.6,3,6,
  "DeSoto 13",-87.0,30.1,1,2,
  "DeSoto 7 (DSR07)",-86.9,30.1,2,3,
  "Desoto Rim, Desoto2",-86.7,30.1,4,4,
  "Desoto Rim, Desoto7",-86.8,30.1,3,5,
  "Diaphus",-90.7,28.1,14,16,
  "EFGB",-93.6,27.9,17,24,
  "Habitat Response One",-78.4,31.0,1,1,
  "Key West",-81.9,24.0,2,2,
  "Key West Scarp-Florida Strait",-81.8,24.0,1,4,
  "L&W Pinnacles and Scamp Reefs, Scamp1",-87.8,29.3,1,2,
  "Lander-01; DeSoto Rim",-86.9,30.1,3,4,
  "McGrail",-92.6,28.0,2,2,
  "Miami Terrace",-79.9,25.6,3,4,
  "Million Mounds South",-79.3,28.5,2,2,
  "Pinnicles Trend; Pinn09",-88.0,29.4,1,2,
  "Pinnicles Trend; Pinn10",-88.2,29.3,1,2,
  "Pinnicles Trend; Pinn16a",-88.3,29.2,3,5,
  "Pinnicles Trend; Pinn4",-88.6,29.2,6,9,
  "Pinnicles Trend; Pinn9a",-88.0,29.4,2,2,
  "Pourtales Terrace ",-80.7,24.4,1,1,
  "Reef Tracts",-77.9,31.2,3,3,
  "Retriever Seamount",-66.2,39.8,1,2,
  "Roughtongue Reef, 40Fathom1",-87.6,29.4,1,1,
  "Roughtongue Reef, CAT1",-87.6,29.4,1,2,
  "Roughtongue Reef, CORK1",-87.5,29.4,1,2,
  "Roughtongue Reef, Pinn1",-87.5,29.4,3,3,
  "Roughtongue Reef, Porgy1",-87.6,29.4,1,1,
  "Shark Rock, Savannah Banks",-79.1,31.6,1,2,
  "Stetson",-94.3,28.2,4,7,
  "Stetson Mesa Mound Field One",-79.3,30.4,1,2,
  "Stetson Mesa Mound Field Two",-79.2,30.4,1,1,
  "Stetson Mesa South Scarp",-79.6,29.7,1,1,
  "Stetson Mesa West",-79.5,29.9,1,1,
  "The Pinnicles; Alabama Alps Reef; Pinn16",-88.3,29.3,1,1,
  "Viosca Knolls;Viosca Knolls East: Viosca8",-88.0,29.2,1,1,
  "WF1 (West Florida)",-86.6,30.0,1,1,
  "WFL01 (West Florida Shelf)",-86.6,30.0,1,1,
  "WFL12 (West Florida Shelf)",-86.2,29.6,2,3
)

# Base do mapa (mundo) + recorte opcional (ajuste ao seu estudo)
world <- ne_countries(scale = "medium", returnclass = "sf")

# Converte pontos para sf
sites_sf <- st_as_sf(sites, coords = c("lon", "lat"), crs = 4326)

# Plot
p_map <- ggplot() +
  geom_sf(data = world, fill = "grey95", color = "grey70", linewidth = 0.2) +
  geom_sf(data = sites_sf,
          aes(size = n_samples, color = motu_richness),
          alpha = 0.9) +
  coord_sf(xlim = c(min(sites$lon) - 2, max(sites$lon) + 2),
           ylim = c(min(sites$lat) - 2, max(sites$lat) + 2),
           expand = FALSE) +
  labs(
    title = "MOTU richness across sampling sites",
    subtitle = "Point color indicates number of MOTUs; point size indicates number of samples",
    color = "MOTUs",
    size = "Samples"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major = element_line(color = "grey90", linewidth = 0.2),
    axis.title = element_blank()
  )

p_map

# Export
ggsave("Figure_MOTU_map.pdf", p_map, width = 7.5, height = 5.2, useDingbats = FALSE)
ggsave("Figure_MOTU_map.png", p_map, width = 7.5, height = 5.2, dpi = 300)

