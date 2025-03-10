# L2 Clear Speech Study

## Overview
This project investigates whether **L2 speakers use clear speech** in natural conversations. The study specifically explores:

- Do L2 speakers modify their speech when speaking to **another L2 speaker with a different L1**?
- Do these speech modifications **persist throughout the conversation**?

We analyze **F0, F0 range, speech rate, and vowel duration** using **linear mixed-effects models**.

---

## Repository Structure
L2_clear_speech/

├── L2-clear-speech.qmd           # Quarto manuscript file for the study

├── L2-clear-speech.pdf           # PDF version of the manuscript

├── L2-clear-speech-data

│   ├── N-NN.csv                  # Raw data: Native - Non-Native speaker conversation data

│   ├── N1-NN1.csv                # Raw data: L2 speakers with the same L1 conversation data

│   ├── N1-NN2.csv                # Raw data: L2 speakers with different L1 conversation data

│   ├── cleaned_data.csv          # Cleaned dataset used for analysis

├── bibliography.bib              # BibTeX bibliography file for citations

├── research-assessment.md

├── .gitignore

├── _extensions                   #APA Quarto extensions

└── README.md


---

## Data Description
The dataset consists of speech features extracted from **L2 and native English speakers** engaging in conversational tasks. The key variables include:

- **F0 (Hz):** Fundamental frequency of speech
- **F0 Range (Hz):** Difference between maximum and minimum F0
- **Speech Rate (syllables/sec):** Number of syllables per second
- **Vowel Duration (s):** Average duration of vowels

---

## Analysis & Models
We use **linear mixed-effects models (LME)** to examine speech adaptations
