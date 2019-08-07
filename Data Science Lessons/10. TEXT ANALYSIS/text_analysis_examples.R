###DEMO for text data analysis with R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for text analysis by Julia Silge)


# Load dplyr and tidytext
library(dplyr)
library(tidytext)
library(tidyr)

# can use 4 lexicons according to need for data analysis
# search using ??get_sentiments(): "afinn", "bing", "nrc", "loughran"
## e.g.: get_sentiments("bing")

# get sentiment_data
url = "https://d1p17r2m4rzlbo.cloudfront.net/wp-content/uploads/2016/03/Airline-Sentiment-2-w-AA.csv"
sentiment_data <- read_csv(url)

# check built-in sentiments
percents <- sentiment_data %>%
  count(airline_sentiment) %>%
  rename(total_count = n) %>%
  mutate(percent = total_count / sum(total_count) * 100) %>%
  # Arrange by percent
  arrange(percent)

# tokenize text comments
sentiment_data %>%
  unnest_tokens(word, text) %>%
  count(word, sort = TRUE)

# visualizing airline sentiments
# note: get_sentiments isn't plotted here
tidy <- sentiment_data %>%
  unnest_tokens(word, text) %>%
  left_join(percents, by = "airline_sentiment") %>%
  # Implement sentiment analysis with the "nrc" lexicon
  inner_join(get_sentiments("nrc")) %>%
  # Find how many sentiment words each song has
  count(word, airline_sentiment, sort = TRUE) %>%
  ggplot(aes(as.factor(airline_sentiment), n)) +
  # Make a boxplot
  geom_boxplot()

# modeling sentiments:
summary(lm(n ~ airline_sentiment, data = tidy))


# compare group_by() with ungroup()
negative_sents1 <- sentiment_data %>%
  # Filter to only choose the words associated with sadness
  filter(airline_sentiment == "negative") %>%
  # Group by word
  group_by(negativereason) %>%
  # Use the summarize verb to find the mean frequency
  summarize(airline_sentiment_conf = mean(`airline_sentiment:confidence`)) %>%
  # Arrange to sort in order of descending frequency
  arrange(desc(airline_sentiment_conf))

#ungroup()
negative_sents2 <- sentiment_data %>%
  # Filter to only choose the words associated with sadness
  filter(airline_sentiment == "negative") %>%
  # Group by word
  group_by(negativereason) %>%
  # Use the summarize verb to find the mean frequency
  summarize(airline_sentiment_conf = mean(`airline_sentiment:confidence`)) %>%
  # Arrange to sort in order of descending frequency
  arrange(desc(airline_sentiment_conf)) %>%
  ungroup()

# compare plots1 and 2 with one another
require(gridExtra)
plot1 <- negative_sents1 %>%
  top_n(20) %>%
  mutate(word = reorder(negativereason, airline_sentiment_conf)) %>%
  ggplot(aes(negativereason, airline_sentiment_conf)) +
  geom_col() +
  coord_flip()


plot2 <-negative_sents2 %>%
  top_n(20) %>%
  mutate(word = reorder(negativereason, airline_sentiment_conf)) %>%
  ggplot(aes(negativereason, airline_sentiment_conf)) +
  geom_point() +
  coord_flip()
grid.arrange(plot1, plot2, ncol=2)

#-------------------------------------------------------------------------------

# Sentiment changes through a text
tidy_shakespeare %>%
  # Implement sentiment analysis using "bing" lexicon
  inner_join(get_sentiments("bing")) %>%
  # Count using four arguments
  count(title, type, index = linenumber %/% 70, sentiment)

#-------------------------------------------------------------------------------

# Calculating net sentiments
tidy_sentiment_data <- sentiment_data %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, airline_sentiment) %>%
  # Spread sentiment and n across multiple columns
  spread(sentiment, n, fill = 0) %>%
  # Use mutate to find net sentiment
  mutate(sentiment = positive - negative) %>%
  # Put index on x-axis, sentiment on y-axis, and map comedy/tragedy to fill
  ggplot(aes(word, sentiment, fill = airline_sentiment)) +
  # Make a bar chart with geom_col()
  geom_col() +
  # Separate panels with facet_wrap()
  facet_wrap(~ airline_sentiment, scales = "free_x")

#-------------------------------------------------------------------------------

# Visualizing sentiment over time
# Load the lubridate package
library(lubridate)

# sentiment change over time
sentiment_data %>%
  # Define date for judgement
  mutate(date = mdy_hm(`_last_judgment_at`)) %>%
  #mutate(date = floor_date(date, unit = "6 months")) %>%
  # Group by date
  group_by(date) %>%
  #ungroup() %>%
  count(airline_sentiment) %>%
  rename(total_count = n) %>%
  mutate(percent = total_count / sum(total_count) * 100) %>%
  # Arrange by percent
  arrange(percent) %>%
  na.omit() %>%
  # Implement sentiment analysis using the NRC lexicon
  #inner_join(get_sentiments("nrc"))
  ggplot(aes(date, percent, color = airline_sentiment)) +
  geom_line(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, lty = 2) +
  expand_limits(y = 0)


# sentiment change over time
sentiment_data %>%
  # Define date for judgement
  mutate(date = mdy_hm(`_last_judgment_at`)) %>%
  #mutate(date = floor_date(date, unit = "6 months")) %>%
  # Group by date
  group_by(date) %>%
  #ungroup() %>%
  count(airline_sentiment) %>%
  rename(total_count = n) %>%
  mutate(percent = total_count / sum(total_count) * 100) %>%
  # Arrange by percent
  arrange(percent) %>%
  na.omit() %>%
  # Implement sentiment analysis using the NRC lexicon
  #inner_join(get_sentiments("nrc"))
  ggplot(aes(date, percent, color = airline_sentiment)) +
  # Make facets by word
  facet_wrap(~airline_sentiment) +
  geom_line(size = 1.5, show.legend = FALSE) +
  expand_limits(y = 0)



