library(stringr)

# ------------------ Read Transcript File and Count Syllables ------------------
transcript_path <- "~/Desktop/ma_thesis/n-nn/transcript/chf_09.txt"
if (!file.exists(transcript_path)) {
  stop("Error: Transcript file not found. Please check the path.")
}

lines <- readLines(transcript_path, encoding = "UTF-8")

# Locate the "# SPLIT #" marker
split_index <- which(lines == "# SPLIT #")
if (length(split_index) == 0) {
  stop("Error: '# SPLIT #' marker not found in the transcript. Please check the file.")
}

# Extract S1's speech lines
s1_lines_first <- grep("^S1:", lines[1:(split_index - 1)], value = TRUE, ignore.case = TRUE)
s1_lines_second <- grep("^S1:", lines[(split_index + 1):length(lines)], value = TRUE, ignore.case = TRUE)

# Function to count syllables (approximate based on vowel groups)
count_syllables <- function(text) {
  vowels <- str_count(text, "[aeiouyAEIOUY]+")
  return(sum(vowels))
}

num_syllables_first <- sum(sapply(s1_lines_first, count_syllables))
num_syllables_second <- sum(sapply(s1_lines_second, count_syllables))

# ------------------ Print Results ------------------
cat("Total syllable count:", num_syllables_first + num_syllables_second, "\n")
cat("First half syllable count:", num_syllables_first, "\n")
cat("Second half syllable count:", num_syllables_second, "\n")