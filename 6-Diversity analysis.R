library(tidyverse)

df <- read.csv("/Users/lealc/Library/CloudStorage/OneDrive-SmithsonianInstitution/Documents/Manuscripts/Molecular Biodiversity/Supplementary Table 1 Metadata.csv")  # carregue seu dataset

# padroniza nomes (opcional)
df2 <- df %>%
  rename(
    sample_id = `Locality`,
    method    = `Collection_method`,
    depth_m   = Depth,
    family    = Family,
    motu      = `MOTU`
  ) %>%
  mutate(
    depth_m = as.numeric(depth_m),
    method = factor(method),
    # ajuste esse corte para o seu conceito de mesofótico
    zone = case_when(
      depth_m <= 200 ~ "Mesophotic",
      depth_m > 200  ~ "Deep",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(sample_id), !is.na(method), !is.na(motu))

#Filtering - mesophotic-only
df2_meso <- df2 %>% filter(zone == "Mesophotic")

motu_pa <- df2_meso %>%
  distinct(sample_id, method, motu) %>%
  mutate(present = 1) %>%
  pivot_wider(names_from = motu, values_from = present, values_fill = 0)

# Matriz presença/ausência: amostra x MOTU - TOTAL
#motu_pa <- df2 %>%
#  distinct(sample_id, method, motu) %>%
#  mutate(present = 1) %>%
#  pivot_wider(names_from = motu, values_from = present, values_fill = 0)

# Funções de diversidade (Shannon/Simpson) em presença/ausência
shannon <- function(x){
  p <- x/sum(x)
  p <- p[p > 0]
  -sum(p * log(p))
}
simpson_gini <- function(x){
  p <- x/sum(x)
  1 - sum(p^2)
}

alpha <- motu_pa %>%
  rowwise() %>%
  mutate(
    motu_richness = sum(c_across(where(is.numeric))),
    shannon = shannon(c_across(where(is.numeric))),
    simpson = simpson_gini(c_across(where(is.numeric)))
  ) %>%
  ungroup() %>%
  select(sample_id, method, motu_richness, shannon, simpson)

alpha

library(ggplot2)

p_shannon <- ggplot(alpha, aes(x = method, y = shannon, fill = method)) +
  geom_violin(trim = FALSE, alpha = 0.35, color = NA) +
  geom_boxplot(width = 0.18, outlier.shape = NA, alpha = 0.6) +
  geom_jitter(width = 0.08, height = 0, alpha = 0.7, size = 1.6) +
  labs(x = NULL, y = "Shannon index") +
  theme_classic(base_size = 12) +
  theme(legend.position = "none")

p_simpson <- ggplot(alpha, aes(x = method, y = simpson, fill = method)) +
  geom_violin(trim = FALSE, alpha = 0.35, color = NA) +
  geom_boxplot(width = 0.18, outlier.shape = NA, alpha = 0.6) +
  geom_jitter(width = 0.08, height = 0, alpha = 0.7, size = 1.6) +
  labs(x = NULL, y = "Simpson (1 - D)") +
  theme_classic(base_size = 12) +
  theme(legend.position = "none")

p_rich <- ggplot(alpha, aes(x = method, y = motu_richness, fill = method)) +
  geom_violin(trim = FALSE, alpha = 0.35, color = NA) +
  geom_boxplot(width = 0.18, outlier.shape = NA, alpha = 0.6) +
  geom_jitter(width = 0.08, height = 0, alpha = 0.7, size = 1.6) +
  labs(x = NULL, y = "MOTU richness per locality") +
  theme_classic(base_size = 12) +
  theme(legend.position = "none")

library(tidyverse)
library(ggplot2)

# 1) Preparar uma tabela de presença de famílias por método (e zona)
fam_tbl <- df2 %>%
  filter(!is.na(family), family != "") %>%
  distinct(method, zone, family)

# Função para calcular shared/exclusive dentro de um subconjunto (Total ou Mesophotic)
get_overlap_counts <- function(dat){
  arms <- dat %>% filter(method == "ARMS") %>% pull(family) %>% unique()
  rov  <- dat %>% filter(method == "ROV")  %>% pull(family) %>% unique()
  
  shared   <- intersect(arms, rov)
  arms_only <- setdiff(arms, rov)
  rov_only  <- setdiff(rov, arms)
  
  tibble(
    method = c("ARMS", "ARMS", "ROV", "ROV"),
    component = c("Shared", "ARMS-only", "Shared", "ROV-only"),
    n = c(length(shared), length(arms_only), length(shared), length(rov_only))
  )
}

# 2) Total (todas as zonas)
counts_total <- get_overlap_counts(fam_tbl %>% filter(!is.na(zone))) %>%
  mutate(scope = "Total")

# 3) Mesophotic-only
counts_meso <- get_overlap_counts(fam_tbl %>% filter(zone == "Mesophotic")) %>%
  mutate(scope = "Mesophotic only")

counts_plot <- bind_rows(counts_total, counts_meso) %>%
  mutate(
    method = factor(method, levels = c("ARMS","ROV")),
    scope = factor(scope, levels = c("Mesophotic only", "Total")),
    component = factor(component, levels = c("Shared","ARMS-only","ROV-only"))
  )

# 4) Plot: barras empilhadas + facet por escopo
p_overlap <- ggplot(counts_plot, aes(x = method, y = n, fill = component)) +
  geom_col(width = 0.65) +
  geom_text(aes(label = n),
            position = position_stack(vjust = 0.5),
            size = 3.6, color = "white", fontface = "bold") +
  facet_wrap(~scope) +
  labs(x = NULL, y = "Number of families", fill = NULL) +
  theme_classic(base_size = 12) +
  theme(legend.position = "top")

p_overlap

p_overlap <- p_overlap +
  scale_fill_manual(values = c(
    "Shared" = "grey55",
    "ARMS-only" = "#D64C4C",
    "ROV-only" = "#00B3B3"
  ))

#install.packages("iNEXT")
library(iNEXT)

# Cria lista com abundâncias por método (contagem de registros por MOTU)
motu_abund <- df2 %>%
  count(method, motu, name = "abund") %>%
  group_by(method) %>%
  summarise(vec = list(setNames(abund, motu)), .groups = "drop")

abund_list <- setNames(motu_abund$vec, motu_abund$method)

out <- iNEXT(abund_list, q = 0, datatype = "abundance")  # q=0 = riqueza (MOTUs)
p_rare <- ggiNEXT(out, type = 1) +  # sample-size rarefaction/extrapolation
  labs(x = "Sample size", y = "MOTUs (q = 0)") +
  theme_classic(base_size = 12)

#install.packages("patchwork")
library(patchwork)

final <- (p_rich + p_shannon) / (p_simpson + p_overlap) +
  plot_annotation(tag_levels = "A")

final
ggsave("Figure_ARMS_ROV_pretty.pdf", final, width = 9, height = 7, useDingbats = FALSE)
ggsave("Figure_ARMS_ROV_pretty.png", final, width = 9, height = 7, dpi = 300)

