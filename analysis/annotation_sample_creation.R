# clear environment

rm(list =  ls())

# load libraries

library(lexRankr)
library(dplyr)

# read in data

data <- read.csv("./all_texts_commissioner_speeches.csv")
data <- data %>% 
  mutate(speech_id = row_number())

# unnest sentences

df_sent <- lexRankr::unnest_sentences(data, output = sents, input = text)

# create sentence triplets

df_grouped <- df_sent %>%
  group_by(speech_id) %>%
  mutate(triplet_id = paste(speech_id, ceiling(sent_id / 3), sep = "_")) %>%  
  group_by(speech_id, triplet_id) %>%
  summarise(
    title = first(title),
    date = first(date),
    link = first(link),
    date_character = first(date_character),
    source = first(source),
    year = first(year),
    sents = paste(sents, collapse = " "))

# create annotation sample

set.seed(123)
df_sample <- sample_frac(df_grouped, 0.01)

# save output file (csv)

write.csv(df_sample, file = "./annotation_sample_eu_commissioner_speeches.csv", 
          fileEncoding = "utf-8")
