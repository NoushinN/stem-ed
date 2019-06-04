###DEMO for text data analysis with R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for text analysis by Julia Silge)


# Load dplyr and tidytext
library(dplyr)
library(tidytext)

# can use 4 lexicons according to need for data analysis
# search using ??get_sentiments(): "afinn", "bing", "nrc", "loughran"
## e.g.: get_sentiments("bing")

# get sentiment_data
url = "https://d1p17r2m4rzlbo.cloudfront.net/wp-content/uploads/2016/03/Airline-Sentiment-2-w-AA.csv"
sentiment_data <- read_csv(url)


negative_sents <- sentiment_data %>%
  # Filter to only choose the words associated with sadness
  filter(airline_sentiment == "negative") %>%
  # Group by word
  group_by(negativereason) %>%
  # Use the summarize verb to find the mean frequency
  summarize(airline_sentiment_conf = mean(`airline_sentiment:confidence`)) %>%
  # Arrange to sort in order of descending frequency
  arrange(desc(airline_sentiment_conf))

negative_sents %>%
  top_n(20) %>%
  mutate(word = reorder(negativereason, airline_sentiment_conf)) %>%
  ggplot(aes(negativereason, airline_sentiment_conf)) +
  geom_col() +
  coord_flip()
