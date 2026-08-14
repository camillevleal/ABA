# install.packages(c("tidyverse", "scales"))
library(tidyverse)
library(scales)

# 1) Dados
df <- tribble(
  ~Source, ~`28S rRNA`, ~`18S rRNA`, ~`COX1 mitochondrial`,
  "Present study",          93,        89,        83,
  "Vargas et al. (2012)",    NA,        NA,        25,
  "Erpenbeck et al. (2016)", 72,        NA,        60,
  "Yang et al. (2017)",      59,        NA,        84,
  "Erpenbeck et al. (2020)", 72,        NA,        65,
  "Galitz et al. (2024)",    95,        NA,        70
)

# 2) Formato longo para plot
long <- df %>%
  pivot_longer(-Source, names_to = "Marker", values_to = "Success") %>%
  mutate(
    Source = factor(Source, levels = rev(df$Source)),  # mantém ordem da tabela (topo -> base)
    is_present = Source == "Present study",
    label = if_else(is.na(Success), "–", paste0(Success, "%"))
  )

# calc a posição y do "Present study"
y_ps <- which(levels(long$Source) == "Present study")

p_heat <- ggplot(long, aes(x = Marker, y = Source, fill = Success)) +
  geom_tile(color = "white", linewidth = 0.6) +
  geom_text(aes(label = label),
            size = 4, fontface = "bold",
            color = if_else(is.na(long$Success), "grey40", "white")) +
  geom_tile(
    data = long %>% filter(is_present),
    fill = NA, color = "black", linewidth = 1.2
  ) +
  # selo fora da grade (na direita)
  annotate("label",
           x = Inf, y = y_ps,
           label = "First attempt\n(first-pass)",
           fontface = "bold",
           label.size = 0.6,
           hjust = 1.1, vjust = 0.5) +
  scale_fill_gradient(
    low = "#3B82F6", high = "#0B1F3B",
    na.value = "grey85",
    limits = c(0, 100)
  ) +
  labs(
    x = NULL, y = NULL, fill = "Success rate",
    title = "Marker recovery success rates across studies",
    subtitle = "Present study obtained first-pass (no protocol optimization cycles)"
  ) +
  coord_cartesian(clip = "off") +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(face = "bold"),
    axis.text.y = element_text(size = 10),
    plot.title = element_text(face = "bold"),
    legend.position = "right",
    plot.margin = margin(10, 45, 10, 10)  # margem direita extra pro selo
  )

p_heat

# 4) Export (paper-friendly)
ggsave("Figure_success_heatmap.pdf", p_heat, width = 8.2, height = 4.6, useDingbats = FALSE)
ggsave("Figure_success_heatm



