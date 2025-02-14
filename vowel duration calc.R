library(stringr)

read_textgrid <- function(file_path) {
  lines <- readLines(file_path, encoding = "UTF-8")  
  return(lines)
}

# Use tier number to target tier
extract_vowel_intervals <- function(textgrid_lines, tier_number = 2) {
  tier_pattern <- sprintf("item \\[%d\\]", tier_number)  
  tier_index <- grep(tier_pattern, textgrid_lines)  
  
  if (length(tier_index) == 0) {
    stop("Error: Tier not found! Check if tier_number is correct.")
  }
  
  tier_start <- tier_index[1]
  all_tier_indices <- grep("item \\[", textgrid_lines) 
  next_tier <- all_tier_indices[which(all_tier_indices > tier_start)[1]] 
  tier_end <- ifelse(is.na(next_tier), length(textgrid_lines), next_tier - 1)
  
  interval_lines <- textgrid_lines[tier_start:tier_end]
  
  start_times <- c()
  end_times <- c()
  labels <- c()
  
  for (i in 1:(length(interval_lines) - 2)) {
    if (grepl("xmin =", interval_lines[i])) {
      xmin <- as.numeric(str_extract(interval_lines[i], "\\d+\\.\\d+"))
      xmax <- as.numeric(str_extract(interval_lines[i + 1], "\\d+\\.\\d+"))
      label <- str_extract(interval_lines[i + 2], '(?<=text = ").+?(?=")')
      
      if (!is.na(label) && label != "") {
        start_times <- c(start_times, xmin)
        end_times <- c(end_times, xmax)
        labels <- c(labels, label)
      }
    }
  }
  
  df <- data.frame(
    start_time = start_times,
    end_time = end_times,
    duration = end_times - start_times,
    label = labels
  )
  
  # Debug：print the result
  print("Extracted DataFrame:")
  print(df)
  
  return(df)
}

# Calculate vowel duration and syllables
calculate_vowel_durations <- function(df, xmax) {
  # Target vowel sounds
  vowel_set <- c("AY", "IY", "EY", "OW", "UW", "IH", "EH", "AE", "AA", "AW", "AH", "AO", "OY", "UH", "ER", "AX")
  syllable_set <- c(vowel_set, "AX N", "AX M", "AX L") #count syllables based on vowel and syllabic consonant sounds
  
  # Clean text data
  df$label <- trimws(df$label)
  df$label <- gsub("[\n\r]", "", df$label)
  
  # clean target vowel
  df_vowel <- df[df$label %in% vowel_set, ]
  
  if (nrow(df_vowel) == 0) {
    print("Warning: No vowels matched. Check labels using print(unique(df$label)).")
    return(NULL)
  }
  
  df_syllable <- df[df$label %in% syllable_set, ]
  
  # calculate duration
  total_vowel_duration <- sum(df_vowel$duration, na.rm = TRUE)
  mean_vowel_duration <- mean(df_vowel$duration, na.rm = TRUE)
  
  # calculate `midpoint`
  theoretical_midpoint <- xmax / 2  # extract the `xmax` of the tier
  print(paste("Theoretical Midpoint:", theoretical_midpoint))  
  
  if (nrow(df) > 0) {
    df$distance_to_mid <- abs(df$start_time - theoretical_midpoint)
    df_midpoint <- df[which.min(df$distance_to_mid), "start_time"]
  } else {
    df_midpoint <- NA
  }
  
  print(paste("Closest xmin to midpoint:", df_midpoint))  
  
  # calculate vowel duration before and after the `midpoint` 
  vowels_before_mid <- df_vowel$duration[df_vowel$start_time <= df_midpoint]
  vowels_after_mid <- df_vowel$duration[df_vowel$start_time > df_midpoint]
  
  vowel_before_mid <- ifelse(length(vowels_before_mid) > 0, mean(vowels_before_mid, na.rm = TRUE), NA)
  vowel_after_mid <- ifelse(length(vowels_after_mid) > 0, mean(vowels_after_mid, na.rm = TRUE), NA)
  
  # calculate syllables
  total_syllables <- nrow(df_syllable)
  syllables_before_mid <- nrow(df_syllable[df_syllable$start_time <= df_midpoint, ])
  syllables_after_mid <- nrow(df_syllable[df_syllable$start_time > df_midpoint, ])
  
  results <- list(
    total_vowel_duration = total_vowel_duration,
    mean_vowel_duration = mean_vowel_duration,
    mean_vowel_before_mid = vowel_before_mid,
    mean_vowel_after_mid = vowel_after_mid,
    final_midpoint = df_midpoint,  # target 'midpoint'
    total_syllables = total_syllables,
    syllables_before_mid = syllables_before_mid,
    syllables_after_mid = syllables_after_mid
  )
  
  return(results)
}

process_textgrid <- function(file_path, tier_number = 2) {
  textgrid_lines <- read_textgrid(file_path)
  
  # find the `xmax`of the tier
  xmax <- as.numeric(str_extract(grep("xmax =", textgrid_lines, value = TRUE)[1], "\\d+\\.\\d+"))
  print(paste("Extracted xmax:", xmax))
  
  df <- extract_vowel_intervals(textgrid_lines, tier_number)
  
  print("Unique labels extracted:")
  print(paste0("'", unique(df$label), "'"))
  
  results <- calculate_vowel_durations(df, xmax)
  if (!is.null(results)) {
    print(paste("Total Vowel Duration:", results$total_vowel_duration, "seconds"))
    print(paste("Mean Vowel Duration:", results$mean_vowel_duration, "seconds"))
    print(paste("Mean Vowel Duration Before Midpoint:", results$mean_vowel_before_mid, "seconds"))
    print(paste("Mean Vowel Duration After Midpoint:", results$mean_vowel_after_mid, "seconds"))
    print(paste("Final Midpoint used:", results$final_midpoint, "seconds"))
    print(paste("Total Syllables:", results$total_syllables))
    print(paste("Syllables Before Midpoint:", results$syllables_before_mid))
    print(paste("Syllables After Midpoint:", results$syllables_after_mid))
  } else {
    print("No vowels found! Double-check the tier number and labels.")
  }
}

# run
file_path <- file.choose()  
tier_number <- as.integer(readline(prompt = "Enter the Tier Number: ")) 


process_textgrid("/Users/haoyilin/Desktop/ma_thesis/n-nn/textgrid/DP_ENF_26_CHF_10_EN_CHF_10_DP_ENF_26_CHF_10_EN_ENF_26.TextGrid", tier_number = 2)

