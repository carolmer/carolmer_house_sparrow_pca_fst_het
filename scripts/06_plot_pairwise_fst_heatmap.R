library(tidyverse)

lines <- readLines("pairwise_fst_summary.txt")

fst <- tibble(line = lines) %>%
  mutate(
    comp = str_extract(line, "pairwise_fst/[^:]+"),
    comp = str_remove(comp, "pairwise_fst/"),
    pop1 = str_extract(comp, "^[A-Z]+"),
    pop2 = str_extract(comp, "(?<=_vs_)[A-Z]+"),
    FST = as.numeric(str_extract(line, "-?[0-9]+\\.[0-9]+$"))
  ) %>%
  select(pop1, pop2, FST)

fst_full <- bind_rows(
  fst,
  fst %>% transmute(pop1 = pop2, pop2 = pop1, FST = FST),
  tibble(pop1 = unique(c(fst$pop1, fst$pop2)),
         pop2 = unique(c(fst$pop1, fst$pop2)),
         FST = 0)
)

p <- ggplot(fst_full, aes(pop1, pop2, fill = FST)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(FST, 3)), size = 3) +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Pairwise FST", fill = "FST")

ggsave("figures/pairwise_FST_heatmap.png", p, width = 8, height = 7)
