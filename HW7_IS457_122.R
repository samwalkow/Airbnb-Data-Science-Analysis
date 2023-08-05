# Do not remove any of the comments. These are marked by #

# HW 7 - Due Monday April 8, 2018 in moodle and hardcopy in class. 

# (1) Upload R file to Moodle with filename: HW7_IS457_YOURCLASSID.R
# (2) Do not remove any of the comments. These are marked by #

## For this assignment we will work with regular expressions. 
## First, we will have some warmup questions, then proceed to extract insights from a text file about hackers.

# Part 1.  Regular Expressions Warmup (14 pt)

# Q1. Find words in test_1 which start with lowercase 'i' using grep. Please explain what does grep return? (2 pt)

test_1 = c("introduction", "to", "data", "science", "457", "information","instance")

grep("^[i]", test_1, value = TRUE)

# Grep returns the indices that match the pattern I specified, so I used the agruement value = TRUE to get the words back instead of just the indicies. 


# Q2. Find the strings that could be our netID. The result should be the index of the string that matches.
# (lower case letters + number, with letters first and then numbers) (2 pt)

test_2 = c("mxian111", "ANSA111", "Jeffery", "199", "Jeff333", "linz22", "wod123","kk24","asde$sad")

grep("^[[:lower:]]+[[:alpha:]][[:digit:]]", test_2)


# Q3. Find website addresses of the format www.letters.xxx . (2 pt)
# Here "xxx" means any alpha numeric characters with length of 3. 
# Letters can be any alpha numeric characters of any length.
# Return the strings that match. (Hint: see the help document of grep())

test_3 = c("aaa@illinois.edu", "www.nothing.nothing", "scholar.google.com", "ischool.illinois.edu",
           "data . gmail.com", "read.readme.us", "www.jstor.org", "www.gmail.com")

grep("w{3}\\.", test_3, value = T)
grep("w{3}\\.[[:alnum:]]+\\.[[:alnum:]]{3}$", test_3, value = T)


## We will practice capturing groups in Q4, Q5, Q6.

# Q4. Use regexec() to execute a regular expression to find properly formatted website address in test_3. 
#Save it as test_3_reg_exec. We will allow addresses in the format letter.letter.letter.
#For example, "ischool.illinois.edu" is allowed. (2 pt)

test_3_reg_exec = regexec("[[:alpha:]]+\\.[[:alpha:]]+\\.[[:alpha:]]+", test_3)
test_3_reg_exec


# Q5. What type of object is test_3_reg_exec? What type of information does it contain? (2 pt)

class(test_3_reg_exec)

# This is a list data type and it contains whether or not an item matches the pattern specified, the length of that item (if is matches), what index was used, and if it was evaulated using bytes


# Q6. Use regmatches() to get a list of the text matches from test_3_reg_exec. Call this 'reg_match_list'.
# What is the format and what information does reg_match_list contain? (4 pt)

reg_match_list = regmatches(test_3, test_3_reg_exec)
class(reg_match_list)

# The format is a list, and this list contains just the text from test_3 pulled out of the rest_3_reg_exec list that is applying a pattern to a string. So we can see what text matches the pattern specified.


# Part 2. Arguments about hackers (79 pt)

# We will now look at a piece of news arguing whether computer hacking is a crime as an example of
# how to process the data to get the arguments of each person into a form we can use.
# We can then look at interesting properties like the number of words for each argument.

# Q7. (4 pt)
# (1) Use readLines() to load the hackers data from the hackers.txt file. 
# Name it hackers_data. MAKE SURE to use the encoding 'UTF-8'. Print the head of hackers_data. (1 pt)

hackers_data = readLines("hackers.txt", encoding = "UTF-8")
head(hackers_data)
class(hackers_data)

# (2) What is the format of hackers_data? How many parts does it have? 
# What kind of information does each part contain? (3 pt)

#The hackers_data variable is one long character class type. So it contains all of the text as characters in a single variable. There are two parts to the text (as labelled within the text). Each part contains names, dates, and the speech of what each person says, like a transcript. It looks like several conversations between a group of people. 


# Q8. Separate out "The Digital Frontier" section in the file. (3 pt)
# First, find the start point and end point of the digital frontier section using grep() and 
# specific header names in the file.
# Then subset only those lines which are included in "The Digital Frontier".
# Call this DF_data. Do not remove empty lines here.
# Print the length of DF_data, the result should be 466.

## Important: In the following questions, we will focus on DF_data.

b = grep("[[:upper:]] \\[", hackers_data)

beginning = grep("[[:upper:]][[:alpha:][:punct:]][[:alpha:]] \\[", hackers_data)
end1 = grep("[*]$+", hackers_data)
book_ends = seq(from = beginning[1], to = end1[10]-2)
new = seq(from = b[1], to = end1[10]-2)
data = hackers_data[new]

DF_data = hackers_data[book_ends]
length(DF_data)
DF_data

# Q9. How do you know when a new argument starts? (1 pt)

# For example
# "HARPER'S [Day 1, 9:00 A.M.]:  When the computer was young, the word hacking was
# used to describe the work of brilliant students who explored and expanded the
# uses to which this new technology might be employed.  There was even talk of a
# "hacker ethic."  Somehow, in the succeeding years, the word has taken on dark
# connotations, suggestion the actions of a criminal.  What is the hacker ethic,
# and does it survive?"

# This is considered one argument. 
# There are three elements: name of the presenter, time, and main context.

# I know an argument starts when I see the all caps name of a person, followed by the date. There is also a blank line before and after each argument. 


# Q10. Our goal is to create a list object which contains information about each argument.
# The first step is to get the start positions (in which line the argument starts) of 
# each argument in DF_data (how you answer Q9?). Print the start positions. (3 pt)

# Check: the first three start positions are: 1, 8, 22.

arg_s = grep("^$", DF_data)
arg_start = c(1, arg_s+1)
arg_start
length(arg_start)

# Q11. We will first focus on the first argument presented by HARPER'S as an example.
# Extract the first argument presented by HARPER'S from DF_data using the start position you found in Q10.
# Name it as harper_arg and print it out; there should be no empty lines here. (2 pt)

harper_arg = DF_data[arg_start[1]:(arg_start[2]-2)]
harper_arg


# Q12. Reformat harper_arg. (9 pt)
# As we can see, the data in harper_arg is not in a easy-to-reference format.
# We need to extract the name of presenter, time, and main content from harper_arg and transfrom it into a list.
# (1) extract the name of presenter and time from harper_arg.
# Name them as harper_presenter and harper_time. (6 pt)
# Hint: recall how we did Q4-Q6 in Part 1, use regexpr() and regmatches().

length(harper_arg)
presenter = regexpr("^[A-Z\\']+\\s{1}", harper_arg)
presenter
harper_presenter = regmatches(harper_arg, presenter)
harper_presenter
time = regexpr("\\[Day[A-Z0-9,:. ]+\\]", harper_arg)
time
harper_time = regmatches(harper_arg, time)
harper_time


# (2) Merge together the separate lines of harper_arg into a single character string/element.
# That is, one charactor vector (contains all sentences) for that argument.
# First find where to split the vector for the argument part, so that we can exclude the information of presenter and time,
# and only the main content remains. Name the main content as harper_text.
## The length of harper_text should be 1. (3 pt)

harper_everything = paste(harper_arg, collapse = " ")
harper_split = strsplit(harper_everything, split= ':  ')
harper_text = harper_split[[1]][2]
harper_text


# (3) Finally, combine harper_presenter, harper_time and harper_text together as a list.
# Call this list harper_list, it should be a list of 3 elements. (2 pt)

harper_list = list(harper_presenter, harper_time, harper_text)
harper_list
class(harper_list)

# Q13. Now we are going to transform all the arguments in DF_data
# into an easy-to-reference format as what we have done in Q12.

# To start with, calculate the number of arguments in "The Digital Frontier".
# Create a new list object named 'arguments'. 
# Each element of the list is a sublist that contains three elements ('presenter', 'time' and 'text').

# For each argument, merge together the separate lines of text into a single character element.
# That is, one character vector (containing all sentences) for that argument.
# This will be the 'text' element in the sublist.

# Extract the presenter name and time into two character vectors (also remove indentation).
# This will be the 'presenter' element and 'time' element in the sublist for that argument. (20 pt)
# Check: the length of the list "arguments" should be 55.


b = grep("[[:upper:]] \\[", hackers_data, value =T)
end = c(grep("^$", DF_data)+1, 466)

DF_data_1 = append(data, c("",""), after = length(DF_data)) 
df_args = DF_data_1[arg_start[2]:end[2]-1]

arguments = list(" ")
for (i in 1:55){
  df_args = data[arg_start[i]:end[i]-1]
  name = regexpr("^[A-Z\\']+\\s{1}", df_args)
  name_match = regmatches(df_args, name)
  date = regexpr("\\[Day[A-Z0-9,:. ]+\\]", df_args)
  date_match = regmatches(df_args, date)
  everything = paste(df_args, collapse = " ")
  everything_match = strsplit(everything, split= ':  ')
  everything_text = everything_match[[1]][2]
  arguments[[i]] = list(name_match[1], date_match, everything_text)
  returnValue(arguments) 
}

length(arguments)

# Q14. Create a dataframe using the list "arguments", there should be two columns: presenter name and
# the number of arguments (correspond to each presenter); sort the rows of the dataframe by the number 
# of arguments in descending order.
# Print the first 8 rows of the datafram and find out which presenters have the most arguments. (8 pt)

arg_count = as.data.frame(table(unlist(lapply(arguments, `[[`, 1))))
arg_order = arg_count[do.call(order, list(arg_count$Freq)), ]
counted = sort(arg_order$Freq, decreasing = T)
arg_count$Freq = counted
head(arg_count, 8)

# Q15. Char count and word count. (10 pt)
# (1) Count the number of characters and words for each argument. 
# The result should be one vector for the char count, one for word count. (4 pt)
# The word_count function is given:

arg_text = lapply(arguments, `[[`, 3)
arg_text

word_count = function(x) {
  return(lengths(gregexpr("\\W+", x)) + 1)  # words separated by space(s)
}

arg_word_count = word_count(arg_text)
length(arg_word_count)

char_count = function(x) {
  return(lengths(gregexpr("[[:alnum:]]", x)) + 1)  # character count using class regex
}

arg_char_count = char_count(arg_text)
length(arg_char_count)

# (2) Create separate barplots for both the number of characters and words in arguments.
# Recall the graphics techniques you learned before. (6 pt)

barplot(arg_word_count, main = "Hacker's Arguments Word Count", xlab = "Words in Arguments",
        ylab = "Count of Words")

barplot(arg_char_count, main = "Hacker's Arguments Character Count", xlab = "Characters in Arguments",
        ylab = "Count of Characters")


# Q16. Lets find some interesting insights from arguments.
# Extract the text of the arguments (from your arguments list) into a vector.
# Remove all non alphabetic characters (except spaces) and change all characters to lowercase. (5 pt)

arg_text = lapply(arguments, `[[`, 3)
texts = c(unlist(arg_text), use.names=FALSE)
texts = tolower(texts)

non_alnum = strsplit(gsub("[^[:alnum:] ]", "", texts), " +")
non_alnum


# Q17. We want to compare the arguments by presenter BARLOW with those by EMMANUEL. (12 pt)
# (1) First, use the list "arguments" we created before to find the index for each presenter. 
# Then get the argument text from the vector you created from Q16.
# Write a function to implement this process. (Get arguments according to the presenter's name.)
# Then use the function to get the argument text by BARLOW and EMMANUEL. The result should be two vectors. (6 pt)
# For example, if I input 'BARLOW', I can get all the arguments by BARLOW.

BandE = function(presenter_name){
  args = c()
  p = toupper(presenter_name)
  presenter = grep(p, arguments)
  low = as.integer(tolower(presenter))
  args = texts[low]
  return(args)
}

BandE("Emmanuel")
BandE("Barlow")

# (2) Then, to facilitate text comparison by presenters, store the text arguments of BARLOW and EMMANUEL in a dataframe.
# The column names should be the presenters' names.
# The rows contain text arguments for each presenter.
# Think about how to deal with different argument lengths to fit in a dataframe (anything reasonable, give explanation.)
# What do you think of this kind of data (text) storage? propose another one that can also do this and show code.
# What can you infer from their text arguments? (5 pt)

E = BandE("Emmanuel")
B = BandE("Barlow")

max(length(B))
length(E)
sq <- seq(max(length(B), length(E)))
sq
w = data.frame(B[sq], E[sq])
w[1]
w[2]

# I thought the best way to handle this was to put NA values in the shorter vector, because I don't want to cut the longer vector short, and I need to combine everything into a dataframe. 


# (3) Split the arguments by blanks and drop empty words. 
# Save all the words for presenter 'BARLOW' and 'EMMANUEL'.
# Store the frequency of words used by BARLOW and by EMMANUEL separately in two dataframes.
# Print how many rows each dataframe has.(6pt)
# Check: there should be 620 different words for BARLOW and 285 different words for EMMANUEL.

B
B_words = strsplit(gsub("[^[:alnum:] ]", "", B), " +")
B_words
B_unique = length(unique(unlist(B_words)))
B_unique

E_words = strsplit(gsub("[^[:alnum:] ]", "", E), " +")
E_unique = length(unique(unlist(E_words)))
E_unique

B_freq = as.data.frame(table(unlist(B_words)))
B_freq
class(B_freq)
dim(B_freq)

E_freq = as.data.frame(table(unlist(E_words)))
E_freq
class(E_freq)
dim(E_freq)

# Q18. Compare the most frequent words used by Barlow and Emmanuel. 
# Use wordcloud function in wordcloud package to plot your result, what are your observations?

# Hint: you'll want to include important words but not stopwords (we provided a list below) into your plot.
# Filter out low frequency words and stopwords.Display words with frequency more than twice (frequency >= 3). 
# Hint: Refer to the original text document and look up the brief introduction of presenters. 
# For example, think of the profession of the presenter and interpret this information with your word frequency result.(10pt)


mask_word = c("by", "as", "a", "an", "their", "which", "have", "with", "are", "been", "will", "we", "not",
              "has", "this", "or", "from", "on", "i", "the","is","it","in","my","of","to",
              "and","be","that","for","you","but","its","was", "me", "one","at", "just", "who","your",
              "into", "they", "all", "am", "before", "do", "other", "our", "than", "them", "us",
              "those","there", "were","no", "out", "up", "what")
library(wordcloud)

E_all = E_freq[!(E_freq$Var1%in%mask_word),]

B_all = B_freq[!(B_freq$Var1%in%mask_word),]
B_all

wordcloud(B_all$Var1, B_all$Freq, min.freq = 3)
wordcloud(E_all$Var1, E_all$Freq, min.freq = 3)

# Emmanuel has words they say more often. You can see this because a few words, like hackers, are much larger than the other words. They also seem to have a theme - they repeat words such as people, indivduals, etc, and seem less interested in the practice of hacking and more focused on the impact and the individuals. Barlow, on the other hand, repeats themselves less and has a crowded cloud. They also have a people theme to their arguments, but we can see the words 'system' and 'insitutions' in large letters. There are also some negative words in there such as 'theft' and 'risk'. Barlow seems more focused on the movement as a whole, and on the systems involved.
