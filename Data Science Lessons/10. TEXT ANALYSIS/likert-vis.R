
# load dependencies
packages <- c("here", "data.table", "tidyverse", "tabplot", "RColorBrewer", "MASS", "likert", "gmodels",
              "leaflet", "rgdal", "bcdata", "ggridges", "plotly", "ggplot2", "psych", "Hmisc", "FSA",
              "shiny", "lattice", "mapview", "htmltools", "DT", "sf", "bcmaps", "dplyr", "wesanderson")
lapply(packages, library, character.only = TRUE)

#-------------------------------------------------------------------------------

# load data into R
dat1_service <- readxl::read_xlsx(here("Data.xlsx"), sheet = 1)
dat2_demo <- readxl::read_xlsx(here("Data.xlsx"), sheet = 2)
dat3_resp <- readxl::read_xlsx(here("Data.xlsx"), sheet = 3)
dat4_code <- readxl::read_xlsx(here("Data.xlsx"), sheet = 4)

#-------------------------------------------------------------------------------

# join tables for integrated analysis
dat1_2 <- left_join(dat1_service, dat2_demo, by = "respno")
dat_1_2_3 <- left_join(dat1_2, dat3_resp, by = "respno")

#-------------------------------------------------------------------------------

# data clean-up
factor(dat1_2$received_service)
yes <- c("1", "Y", "Yes", "Yes very emphatic!", "Yes!")
no <- c("0", "Did not receive service", "Didn't rcv svc",  "N", "No")

dat1_2$received_service[dat1_2$received_service %in% yes] <- "1"
dat1_2$received_service[dat1_2$received_service %in% no] <- "0"


# count number of respondants who received services vs. not
dat1_2 %>%
  group_by(gender) %>%
  filter(received_service == 0) %>%
  summarise(count = n()) 

# summary statistics
summary(dat1_2)
describe(dat1_2)
tableplot(dat1_2)

#-------------------------------------------------------------------------------

# ggplot visualizations

# respondants distribution
qplot(x = dat1_2$received_service, y = dat1_2$region, xlab = "services", ylab = "total respondents", 
         main = "distribution of respondents", geom="boxplot", fill = dat1_2$gender)

qplot(x = dat1_2$received_service, y = dat1_2$year_of_birth,  xlab = "service recipients", ylab = "age range", 
         main = "Distribution of age", geom="boxplot", fill = dat1_2$gender)


# Plot 1
ggplot(dat1_2) + geom_bar(aes(x = as.numeric(dat1_2$received_service), fill = gender)) +
  facet_wrap(~ received_service, scales = "fixed") +
  theme_classic() +
  scale_fill_manual(values=wes_palette(n=2, name="GrandBudapest2")) +
  labs(title = "Distribution of gender", x = "respondants")


# Plot 2
ggplot(dat1_2) + geom_bar(aes(x = as.numeric(dat1_2$received_service), fill = gender)) +
  facet_wrap(~ region, scales = "fixed") +
  theme_classic() +
  scale_fill_manual(values=wes_palette(n=2, name="GrandBudapest2")) +
  labs(title = "Gender distribution in all regions", x = "respondants")


# Plot 3
ggplot(dat1_2) + geom_boxplot(aes(x = as.numeric(dat1_2$received_service), y = year_of_birth, fill = gender)) +
  facet_wrap(~ region, scales = "fixed") +
  theme_classic() +
  scale_fill_manual(values=wes_palette(n=2, name="GrandBudapest2")) +
  labs(title = "Distribution of gender", x = "respondants")

#-------------------------------------------------------------------------------

# map visualizations
pal_ct <- colorRampPalette(brewer.pal(9, "BrBG"))
pal_cd <- colorRampPalette(brewer.pal(9, "YlOrBr"))
pal_csd <- colorRampPalette(brewer.pal(9, "Set3"))
pal_fsa <- colorRampPalette(brewer.pal(9, "Pastel1"))

# cds
cd <- read_sf(here("shp-files", "lcd_000a16a_e.shp")) %>%
  filter(PRNAME == "British Columbia / Colombie-Britannique") %>%
  filter(CDNAME %in% CDNAME) %>%
  st_transform(3005)

mapview(cd, col.regions = pal_cd(100))

ggplot2::ggplot() +
  geom_sf(data = bc_neighbours(), fill = NA) +
  geom_sf(data = cd, aes(fill = CDNAME))


#-------------------------------------------------------------------------------

# likert scale question

str(dat3_resp)
dat3_likert <- dat3_resp[2:6]
as.data.frame(dat3_likert)
dat3_likert[is.na(dat3_likert)] <- 0


dat3_likert$service_quality = factor(dat3_likert$service_quality,
                                     levels = c("0","1", "2", "3", "4", "5", "6", "7", "8", "9"),
                                     ordered = TRUE)

dat3_likert$treated_fairly = factor(dat3_likert$treated_fairly,
                                    levels = c("0","1", "2", "3", "4", "5", "6", "7", "8", "9"),
                                    ordered = TRUE)

dat3_likert$knowledge = factor(dat3_likert$knowledge,
                               levels = c("0","1", "2", "3", "4", "5", "6", "7", "8", "9"),
                               ordered = TRUE)

dat3_likert$satisfaction_with_time = factor(dat3_likert$satisfaction_with_time,
                                            levels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9"),
                                            ordered = TRUE)

dat3_likert$privacy_security = factor(dat3_likert$privacy_security,
                                      levels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9"),
                                      ordered = TRUE)

# confidence interval
str(dat3_likert)
summary(dat3_likert)
describe(dat3_likert)

summary(dat3_likert$privacy_security, digits=4)
summary(dat3_likert$knowledge, digits=4)
summary(dat3_likert$satisfaction_with_time, digits=4)
summary(dat3_likert$treated_fairly, digits=4)
summary(dat3_likert$service_quality, digits=4)


#-------------------------------------------------------------------------------


# We can calculate a 95% confidence interval for a sample mean by adding and subtracting 1.96 standard errors to the point estimate 
mean <- mean(as.numeric(dat3_likert$privacy_security))
sd <- sd(as.numeric(dat3_likert$privacy_security))
no <- length(dat3_likert$privacy_security)
se = sd / sqrt(no)
lci <- mean - qt(1 - (0.05 / 2), no - 1) * se
uci <- mean + qt(1 - (0.05 / 2), no - 1) * se


# or use dplyr to calculate confidence interval for each variable

dat3_likert %>%
  select(privacy_security) %>%
  mutate(mean = mean(as.numeric(dat3_likert$privacy_security)),
         sd = sd(as.numeric(dat3_likert$privacy_security)),
         no = length(dat3_likert$privacy_security)) %>%
  mutate(se = sd / sqrt(no),
         lci = mean - qt(1 - (0.05 / 2), no - 1) * se,
         uci = mean + qt(1 - (0.05 / 2), no - 1) * se)


dat3_likert %>%
  select(satisfaction_with_time) %>%
  mutate(mean = mean(as.numeric(dat3_likert$satisfaction_with_time)),
         sd = sd(as.numeric(dat3_likert$satisfaction_with_time)),
         no = length(dat3_likert$satisfaction_with_time)) %>%
  mutate(se = sd / sqrt(no),
         lci = mean - qt(1 - (0.05 / 2), no - 1) * se,
         uci = mean + qt(1 - (0.05 / 2), no - 1) * se)


dat3_likert %>%
  select(service_quality) %>%
  mutate(mean = mean(as.numeric(dat3_likert$service_quality)),
         sd = sd(as.numeric(dat3_likert$service_quality)),
         no = length(dat3_likert$service_quality)) %>%
  mutate(se = sd / sqrt(no),
         lci = mean - qt(1 - (0.05 / 2), no - 1) * se,
         uci = mean + qt(1 - (0.05 / 2), no - 1) * se)


dat3_likert %>%
  select(treated_fairly) %>%
  mutate(mean = mean(as.numeric(dat3_likert$treated_fairly)),
         sd = sd(as.numeric(dat3_likert$treated_fairly)),
         no = length(dat3_likert$treated_fairly)) %>%
  mutate(se = sd / sqrt(no),
         lci = mean - qt(1 - (0.05 / 2), no - 1) * se,
         uci = mean + qt(1 - (0.05 / 2), no - 1) * se)


dat3_likert %>%
  select(knowledge) %>%
  mutate(mean = mean(as.numeric(dat3_likert$knowledge)),
         sd = sd(as.numeric(dat3_likert$knowledge)),
         no = length(dat3_likert$knowledge)) %>%
  mutate(se =sd / sqrt(no),
         lci = mean - qt(1 - (0.05 / 2), no - 1) * se,
         uci = mean + qt(1 - (0.05 / 2), no - 1) * se)

#-------------------------------------------------------------------------------

# visualizations of likert scaled data
dat3_likert <- as.data.frame(dat3_likert)
likert(dat3_likert)
Result = likert(dat3_likert)


boxplot(dat3_likert$privacy_security, ylab="Likert scores",
        xlab="privacy_security")

plot(Result,
     type="bar",  cex.lab=15,
     centered = FALSE, cex.axis=100)

plot(Result,
     type="density",
     facet = TRUE, 
     bw = 0.5)

plot(Result, 
     type="heat",
     low.color = "white", 
     high.color = "blue",
     text.color = "black", 
     text.size = 4.5, 
     cex.lab=15, 
     cex.axis=100,
     cex = 0.5,
     wrap = 50)

#-------------------------------------------------------------------------------

# additional visuals of comparison

dat3 = xtabs(~ privacy_security + satisfaction_with_time, data=dat3_likert)

prop.table(dat3, margin = 1)

barplot(dat3,
        beside=TRUE,
        legend=TRUE,
        ylim=c(0, 400),  # adjust to remove legend overlap
        xlab="Likert score",
        ylab="Frequency")


