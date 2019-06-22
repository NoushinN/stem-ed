###DEMO for text data analysis with R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for text analysis)

# load package dependencies
library(tidyverse)

# Print twitter_data
url = "https://d1p17r2m4rzlbo.cloudfront.net/wp-content/uploads/2016/03/Airline-Sentiment-2-w-AA.csv"
airline_data <- read_csv(url)

# Print just the negative sentiments in airline_data
airline_data %>%
  filter(airline_sentiment == "negative")

# Start with the data frame
airline_data %>%
  # Group the data by whether or not the sentiment is negative
  group_by(airline_sentiment) %>%
  # Compute the mean, min, and max follower counts
  summarize(
    avg_sentiments = mean(`airline_sentiment:confidence`),
    min_followers = min(`airline_sentiment:confidence`),
    max_followers = max(`airline_sentiment:confidence`)
  )


# Counting user types
airline_data %>%
  # Filter for just the sentiments
  filter(airline_sentiment == "negative") %>%
  # Count the number of verified and non-verified users
  count(airline_sentiment)


# summarizing user types
airline_data %>%
  # Group by whether or not a user is verified
  group_by(airline_sentiment) %>%
  summarize(
    # Compute the average confidence
    airline_sentiment_conf = mean(`airline_sentiment:confidence`),
    # Count the number of users in each category
    n = n()
  )


#-------------------------------------------------------------------------------

# load package dependencies
library(tidyverse)
library(tidytext)

tidy_data <- airline_data %>%
  # Tokenize the airline_data
  unnest_tokens(word, text)

tidy_data %>%
  # Compute word counts
  count(word) %>%
  # Arrange the counts in descending order
  arrange(desc(n))


tidy_data <- tidy_data %>%
  # Tokenize the twitter data
  unnest_tokens(word, word) %>%
  # Remove stop words
  anti_join(stop_words)

tidy_data %>%
  # Filter for just the sentiments
  filter(airline_sentiment == "negative") %>%
  # Compute word counts and arrange in descending order
  count(word) %>%
  arrange(desc(n))

# it looks like negative sentimates may come from time and cancelled services

# counting by reordering
word_counts <- tidy_data %>%
  # Count words by whether or not its a complaint
  count(word, airline_sentiment) %>%
  # Group by whether or not its a complaint
  group_by(airline_sentiment) %>%
  # Keep the top 20 words
  top_n(20, n) %>%
  # Ungroup before reordering word as a factor by the count
  ungroup() %>%
  mutate(word2 = fct_reorder(word, n))
#-------------------------------------------------------------------------------

# visualizing word counts with negative sentiments
word_counts <- tidy_data %>%
  # Filter for just the sentiments
  filter(airline_sentiment == "negative") %>%
  # Compute word counts
  count(word) %>%
  # Keep words with count greater than 500
  filter(n > 500)

# Create a bar plot using word_counts with x = word
ggplot(word_counts, aes(x = word, y = n)) +
  geom_col() +
  # Flip the plot coordinates
  coord_flip()

# Visualizing non-complaints with positive sentiments
word_counts <- tidy_data %>%
  # Filter for just the sentiments
  filter(airline_sentiment == "positive") %>%
  # Compute word counts
  count(word) %>%
  # Keep words with count greater than 100
  filter(n > 100)

# Create a bar plot using word_counts with x = word
ggplot(word_counts, aes(x = word, y = n)) +
  geom_col() +
  # Flip the plot coordinates
  coord_flip() +
  # Title the plot "Positive Sentiment Word Counts"
  ggtitle("Positive Sentiment Word Counts")

#-------------------------------------------------------------------------------

# Improving word count plots

custom_stop_words <- tribble(
  # Column names should match stop_words
  ~word,  ~lexicon,
  # Add http, win, and t.co as custom stop words
  "http", "CUSTOM",
  "win",  "CUSTOM",
  "t.co", "CUSTOM"
)

# Bind the custom stop words to stop_words
stop_words2 <- stop_words %>%
  bind_rows(custom_stop_words)


# Visualizing word counts using factors
word_counts <- tidy_data %>%
  # Filter for just the sentiments
  filter(airline_sentiment == "positive") %>%
  count(word) %>%
  # Keep terms that occur more than 100 times
  filter(n > 100) %>%
  # Reorder word as an ordered factor by word counts
  mutate(word2 = fct_reorder(word, n))

# Plot the new word column with type factor
ggplot(word_counts, aes(x = word2, y = n)) +
  geom_col() +
  coord_flip() +
  # Title the plot "Positive Sentiment Word Counts"
  ggtitle("Positive Sentiment Word Counts")

# Counting by product and reordering
word_counts <- tidy_data %>%
  # Count words by all sentiments
  count(word, airline_sentiment) %>%
  # Group by airline_sentiment
  group_by(airline_sentiment) %>%
  # Keep the top 20 words
  top_n(20, n) %>%
  # Ungroup before reordering word as a factor by the count
  ungroup() %>%
  mutate(word2 = fct_reorder(word, n))


# Include a color aesthetic tied to sentiments
ggplot(word_counts, aes(x = word2, y = n, fill = airline_sentiment)) +
  # Don't include the lengend for the column plot
  geom_col(show.legend = FALSE) +
  # Facet by sentiments and make the y-axis free
  facet_wrap(~ airline_sentiment, scales = "free_y") +
  # Flip the coordinates and add a title: "Sentiment Word Counts"
  coord_flip() +
  ggtitle("Sentiment Word Counts")

#-------------------------------------------------------------------------------

# Plotting word clouds
# Load the wordcloud package
library(wordcloud)

# Compute word counts and assign to word_counts
word_counts <- tidy_data %>%
  count(word)

wordcloud(
  # Assign the word column to words
  words = word_counts$word,
  # Assign the count column to freq
  freq = word_counts$n,
  max.words = 30
)

# Compute complaint word counts and assign to word_counts
word_counts <- tidy_data %>%
  # Filter for just the sentiments
  filter(airline_sentiment == "positive") %>%
  count(word)

# Create a complaint word cloud of the top 50 terms, colored red
wordcloud(
  words = word_counts$word,
  freq = word_counts$n,
  max.words = 50,
  colors = "red"
)

#-------------------------------------------------------------------------------

## Sentiment dictionaries build in tidytext library, let's explore/visualize

get_sentiments("bing")
get_sentiments("bing") %>%
  count(sentiment)

get_sentiments("afinn")
get_sentiments("afinn") %>%
  summarize(
    min = min(score),
    max = max(score)
  )

get_sentiments("loughran")
sentiment_counts <- get_sentiments("loughran") %>%
  count(sentiment) %>%
  mutate(sentiment2 = fct_reorder(sentiment, n))

ggplot(sentiment_counts, aes(x = sentiment2, y=n)) +
         geom_col() +
         coord_flip() +
         labs(
           title = "sentiment counts in loughran dictionary",
           x = "counts",
           y = "sentiment"
         )

# Count the number of words associated with each sentiment in nrc
get_sentiments("nrc") %>%
  count(sentiment) %>%
  # Arrange the counts in descending order
  arrange(desc(n))

# Pull in the nrc dictionary, count the sentiments and reorder them by count
sentiment_counts <- get_sentiments("nrc") %>%
  count(sentiment) %>%
  mutate(sentiment2 = fct_reorder(sentiment, n))

# Visualize sentiment_counts using the new sentiment factor column
ggplot(sentiment_counts, aes(x = sentiment2, y = n)) +
  geom_col() +
  coord_flip() +
  # Change the title to "Sentiment Counts in NRC", x-axis to "Sentiment", and y-axis to "Counts"
  labs(
    title = "Sentiment Counts in NRC",
    x = "Sentiment",
    y = "Counts"
  )

#-------------------------------------------------------------------------------

# Need to append sentiment dictionaries to tokenized and clean data
## can use inner_join()

# Join tidy_data and the loughran sentiment dictionary
sentiment_Review <- tidy_data %>%
  inner_join(get_sentiments("loughran")) %>%
  count(sentiment) %>%
  arrange(desc(n))

# counting positive and negative sentiments only
sentiment_Review2 <- sentiment_Review %>%
  filter(sentiment %in% c("positive", "negative"))


# Join tidy_data and the NRC sentiment dictionary
sentiment_twitter <- tidy_data %>%
  inner_join(get_sentiments("nrc"))

# Count the sentiments in tidy_data
sentiment_twitter %>%
  count(sentiment) %>%
  # Arrange the sentiment counts in descending order
  arrange(desc(n))

# Visualizing sentiments with NRC sentiment dictionary
word_counts <- tidy_data %>%
  # Append the NRC dictionary and filter for positive, fear, and trust
  inner_join(get_sentiments("nrc")) %>%
  filter(sentiment %in% c("positive", "fear", "trust")) %>%
  # Count by word and sentiment and take the top 10 of each
  count(word, sentiment) %>%
  group_by(sentiment) %>%
  top_n(10, n) %>%
  ungroup() %>%
  # Create a factor called word2 that has each word ordered by the count
  mutate(word2 = fct_reorder(word, n))

# Create a bar plot out of the word counts colored by sentiment
ggplot(word_counts, aes(x = word2, y = n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  # Create a separate facet for each sentiment with free axes
  facet_wrap(~ sentiment, scales = "free") +
  coord_flip() +
  # Title the plot "Sentiment Word Counts" with "Words" for the x-axis
  labs(
    title = "Sentiment Word Counts",
    x = "Words"
  )

#-------------------------------------------------------------------------------

## Improving sentiment analysis using spread() and mutate() in tidyr
## reshaping data first
tidy_data %>%
  # Append the NRC sentiment dictionary
  inner_join(get_sentiments("nrc")) %>%
  # Count by complaint label and sentiment
  count(airline_sentiment, sentiment) %>%
  # Spread the sentiment and count columns
  spread(sentiment, n)

# grouping the data
sentiment_data1 <-tidy_data %>%
  # Append the afinn sentiment dictionary
  inner_join(get_sentiments("afinn")) %>%
  # Group by both airline_sentiment, airlines
  group_by(airline_sentiment, airline) %>%
  # Summarize the data with an aggregate_score = sum(score)
  summarize(aggregate_score = sum(score)) %>%
  # Spread the complaint_label and aggregate_score columns
  spread(airline_sentiment, aggregate_score) %>%
  mutate(overall_sentiment = positive + negative)

# visualizing the data
sentiment_data2 <- tidy_data %>%
  # Append the bing sentiment dictionary
  inner_join(get_sentiments("bing")) %>%
  # Count by airline_sentiment, airline
  count(airline_sentiment, airline) %>%
  # Spread the sentiment and count columns
  spread(airline_sentiment, n) %>%
  # Compute overall_sentiment = positive - negative
  mutate(overall_sentiment = positive - negative)

# Create a bar plot out of overall sentiment by complaint level, colored by a complaint label factor
ggplot(
  sentiment_data1,
  aes(x = airline, y = overall_sentiment, fill = as.factor(overall_sentiment))
) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  # Title the plot "Overall Sentiment by Complaint Type," with an "Airline Twitter Data" subtitle
  labs(
    title = "Overall Sentiment by Airline",
    subtitle = "Airline Data"
  )

#-------------------------------------------------------------------------------

# Natural Language Processing
## Latent Dirichlet allocation to unsupervised learning
## i.e. looking for patterns rather than predicting = unsupervised learning

# document term matrices (dtm) using cast_dtm()
# Start with the tidied data
tidy_data %>%
  # Count each word used in each tweet
  count(word, tweet_id) %>%
  # Use the word counts by tweet words to create a DTM
  cast_dtm(tweet_id, word, n)

# Assign the DTM to tidy_data
dtm_data <- tidy_data %>%
  count(word, tweet_id) %>%
  # Cast the word counts by tweet into a DTM
  cast_dtm(tweet_id, word, n)

# Coerce dtm_twitter into a matrix called matrix_twitter
matrix_twitter <- as.matrix(dtm_data)

# Print rows 1 through 5 and columns 90 through 95
matrix_twitter[1:5, 90:95]

#-------------------------------------------------------------------------------

# Running topic models using LDA() function in topicmodels library
library(topicmodels)

# Cast the word counts by tweet into a DTM
# Run an LDA with 2 topics and a Gibbs sampler
lda_out <- LDA(
  dtm_data,
  k = 2,
  method = "Gibbs",
  control = list(seed = 42)
)

# Glimpse the topic model output
glimpse(lda_out)

# Tidy the matrix of word probabilities
lda_topics <- lda_out %>%
  tidy(matrix = "beta")

# Arrange the topics by word probabilities in descending order
lda_topics %>%
  arrange(desc(beta))

# Run an LDA with 3 topics and a Gibbs sampler
lda_out2 <- LDA(
  dtm_data,
  k = 3,
  method = "Gibbs",
  control = list(seed = 42)
)

# Tidy the matrix of word probabilities
lda_topics2 <- lda_out2 %>%
  tidy(matrix = "beta")

# Arrange the topics by word probabilities in descending order
lda_topics2 %>%
  arrange(desc(beta))

## interpreting topics is more of an art form
## visualizing helps the interpretation but is ultimately a subjective decision

## naming three topics
# Select the top 15 terms by topic and reorder term
word_probs2 <- lda_topics2 %>%
  group_by(topic) %>%
  top_n(15, beta) %>%
  ungroup() %>%
  mutate(term2 = fct_reorder(term, beta))

# Plot word probs, color and facet based on topic
ggplot(
  word_probs2,
  aes(term2, beta, fill = as.factor(topic))
) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()


