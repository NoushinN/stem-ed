
# Declare dependencies 
if (!exists("setup_sourced")) source(here::here("code", "setup.R"))

#---------------------------------------------------------------------

# Load thehydroxychloroquine time series data
hc_data <- fread("hydroxychloroquine time-series.csv")
glimpse(hc_data)
head(hc_data)

# Format the service month column to date (yyyy-mm-dd)
hc_data <- hc_data %>%
  mutate(`Service Month` = as.Date(as.yearmon(`Service Month`)))

#---------------------------------------------------------------------

# explore missing variables if any
vis_miss(hc_data) # this shows that 100% of data is present

#---------------------------------------------------------------------

# Figure 1
# Visualize total dispensed drugs for three disease indications 
## per health authority in time

hc_data %>%
  group_by(`Service Month`, `Health Authority Name`, Disease, `Dispense Count`) %>%
  ggplot(aes(x =  `Service Month`, y = `Dispense Count`)) +
  geom_point(aes(color = Disease, shape=`Health Authority Name`)) + 
  scale_shape_manual(values = c(4,8,15,16,17,18,21,22,3,42)) +
  scale_color_brewer(palette="Set1") +
  geom_smooth(aes(color = Disease, fill = Disease), method="lm", se=F) +
  labs(title="Scatter plot depicting dispensed drug counts within pharmacy service months", 
       subtitle="by Health Authorities and Disease indications", 
       caption="source: Econ27-hydroxychloroquine-time-series")  +
  theme(plot.title = element_text(color = "blue", size = 8, face = "bold"),
        plot.subtitle = element_text(color = "blue", size = 7))


#---

# Figure 2
# Visualize total client counts for the three disease indications 
## per health authority in time

hc_data %>%
  group_by(`Service Month`, `Health Authority Name`, Disease, `Distinct Client Count`) %>%
  ggplot(aes(x =  `Service Month`, y = `Distinct Client Count`)) +
  geom_point(aes(col=Disease, shape=`Health Authority Name`)) + 
  scale_shape_manual(values = c(4,8,15,16,17,18,21,22,3,42)) +
  scale_color_brewer(palette="Set1") +
  geom_smooth(aes(color = Disease, fill = Disease), method="lm", se=F) +
  labs(title="Scatter plot depicting distinct client counts within pharmacy service months", 
       subtitle="by Health Authorities and Disease indications", 
       caption="source: Econ27-hydroxychloroquine-time-series") +
  theme(plot.title = element_text(color = "blue", size = 8, face = "bold"),
        plot.subtitle = element_text(color = "blue", size = 7))
  
  
#---

# Figure 3
# Visualize total dispensed days for the three disease indications 
## per health authority in time

options("scipen" = 10)
hc_data %>%
  group_by(`Service Month`, `Health Authority Name`, Disease, `Dispensed Days Supplied`) %>%
  ggplot(aes(x =  `Service Month`, y = `Dispensed Days Supplied`)) +
  geom_point(aes(col=Disease, shape=`Health Authority Name`)) + 
  scale_shape_manual(values = c(4,8,15,16,17,18,21,22,3,42)) +
  scale_color_brewer(palette="Set1") +
  geom_smooth(aes(color = Disease, fill = Disease), method="lm", se=F) +
  labs(title="Scatter plot depicting total drug dispensed days within pharmacy service months", 
       subtitle="by Health Authorities and Disease indications", 
       caption="source: Econ27-hydroxychloroquine-time-series") +
  theme(plot.title = element_text(color = "blue", size = 8, face = "bold"),
        plot.subtitle = element_text(color = "blue", size = 7))

#---

# Figure 4
# Visualize total dispensed tablets for the three disease indications 
## per health authority in time

options("scipen" = 10)
hc_data %>%
  group_by(`Service Month`, `Health Authority Name`, Disease, `Dispensed Tablets`) %>%
  ggplot(aes(x =  `Service Month`, y = `Dispensed Tablets`)) +
  geom_point(aes(col=Disease, shape=`Health Authority Name`)) + 
  scale_shape_manual(values = c(4,8,15,16,17,18,21,22,3,42)) +
  scale_color_brewer(palette="Set1") +
  geom_smooth(aes(color = Disease, fill = Disease), method="lm", se=F) +
  labs(title="Scatter plot depicting total dispensed tablets within pharmacy service months", 
       subtitle="by Health Authorities and Disease indications", 
       caption="source: Econ27-hydroxychloroquine-time-series") +
  theme(plot.title = element_text(color = "blue", size = 8, face = "bold"),
        plot.subtitle = element_text(color = "blue", size = 7))

#---

# Figure 5
# Visualize total prescriber counts for the three disease indications 
## per health authority in time

options("scipen" = 10)
hc_data %>%
  group_by(`Service Month`, `Health Authority Name`, Disease, `Distinct Prescriber Count`) %>%
  ggplot(aes(x =  `Service Month`, y = `Distinct Prescriber Count`)) +
  geom_point(aes(col=Disease, shape=`Health Authority Name`)) + 
  scale_shape_manual(values = c(4,8,15,16,17,18,21,22,3,42)) +
  scale_color_brewer(palette="Set1") +
  geom_smooth(aes(color = Disease, fill = Disease), method="lm", se=F) +
  labs(title="Scatter plot depicting total prescribers within pharmacy service months", 
       subtitle="by Health Authorities and Disease indications", 
       caption="source: Econ27-hydroxychloroquine-time-series") +
  theme(plot.title = element_text(color = "blue", size = 8, face = "bold"),
        plot.subtitle = element_text(color = "blue", size = 7))


#---------------------------------------------------------------------

# STATISTICAL TESTS
# Compare means in health authorities

hc_data %>%
  group_by(`Health Authority Name`) %>%
  summarise(mean_disp_count = mean(`Dispense Count`), 
            median_disp_count = median(`Dispense Count`),
            IQR_disp_count = IQR(`Dispense Count`),
            sd_disp_count = sd(`Dispense Count`),
            se_disp_count = sd(`Dispense Count`)/sqrt(n())) %>%
  arrange(desc(mean_disp_count)) %>%
  kable(caption = "Statistics for Dispense Count") %>%
  kable_styling(latex_options= c("scale_down", "striped", "hold_position"),
                full_width = F)


hc_data %>%
  group_by(Disease) %>%
  summarise(mean_disp_count = mean(`Dispense Count`), 
            median_disp_count = median(`Dispense Count`),
            IQR_disp_count = IQR(`Dispense Count`),
            sd_disp_count = sd(`Dispense Count`),
            se_disp_count = sd(`Dispense Count`)/sqrt(n())) %>%
  arrange(desc(mean_disp_count)) %>%
  kable(caption = "Statistics for Dispense Count") %>%
  kable_styling(latex_options= c("scale_down", "striped", "hold_position"),
                full_width = F)

#---------------------------------------------------------------------

# Format the data for statistical testing
hc_data_stats <- hc_data %>%
  filter(!`Health Authority Name` == "Total") %>%
  rename(HA = `Health Authority Name`,
         clnt_count = `Distinct Client Count`,
         disp_count = `Dispense Count`,
         disp_days = `Dispensed Days Supplied`,
         disp_tabs = `Dispensed Tablets`,
         prsc_count = `Distinct Prescriber Count`)

# compute manova (# MANOVA test)
# check variance among HA's
res.manova1 <- manova(cbind(clnt_count,
                            disp_count,
                            disp_days,
                            disp_tabs,
                            prsc_count) 
                     ~ HA, data = hc_data_stats)
summary(res.manova1)

# Look to see which differ
summary.aov(res.manova1)

# From the output above, it can be seen that all variables are highly significantly different among HA's

#---------------------------------------------------------------------

# check variance among disease indications
res.manova2 <- manova(cbind(clnt_count,
                            disp_count,
                            disp_days,
                            disp_tabs,
                            prsc_count) 
                      ~ Disease, data = hc_data_stats)
summary(res.manova2)

# Look to see which differ
summary.aov(res.manova2)

#---------------------------------------------------------------------

# two-way anova test
res.aov1 <- aov(clnt_count ~ HA + Disease, 
                data = hc_data_stats)

res.aov2 <- aov(disp_count ~ HA + Disease, 
                data = hc_data_stats)

summary(res.aov1)
plot(res.aov1, 1) # 1. Homogeneity of variances
plot(res.aov1, 2) # 2. Normality

summary(res.aov2)
plot(res.aov2, 1) # 1. Homogeneity of variances
plot(res.aov2, 2) # 2. Normality

#As the ANOVA test is significant, we can compute Tukey HSD 
## Tukey Honest Significant Differences, R function: TukeyHSD())
### performs multiple pairwise-comparison between the means of groups. 
### The function TukeyHD() takes the fitted ANOVA as an argument.

res.aov3 <- aov(disp_count ~ HA + Disease + 
                  HA:Disease, 
                data = hc_data_stats)
summary(res.aov3)
plot(res.aov3, 1) # 1. Homogeneity of variances
plot(res.aov3, 2) # 2. Normality

TukeyHSD(res.aov3, which = "Disease")
TukeyHSD(res.aov3, which = "HA")
TukeyHSD(res.aov3, which = c("Disease", "HA"))


