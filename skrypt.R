library(stringr)
library(writexl)
library(dplyr)
library(tesseract)
library(magick)

# wczytanie polskiego słownika do OCR
tesseract_download("pol")

# wczytanie skanu maszynopisu
input <- image_read("skany/1a.jpg")

# zOCRowanie tekstu ze skanu
text <- input %>%
  image_resize("300x") %>%
 #image_trim(fuzz = 40) %>%
  tesseract::ocr(engine = tesseract("pol")) 

cat(text)

# podział tekstu na osobne wiersze 
tx <- unlist(str_split(text, "[\\r\\n]+"))

# wyczyszczenie liczb
tx1<- gsub("\\D", "", tx)

# wyczyszczenie tekstu
tx2 <- gsub("[[:digit:]]+","",tx)
tx2 <- gsub("[[:punct:]]+","",tx2)
tx2 <- gsub("^[[:space:]]+","",tx2)
tx2 <- word(tx2, 1,2)

# stworzenie ramki danych 
txt<- data.frame("numer"= as.numeric(tx1),"nazwisko_imie"=tx2)
#usunięcie pustych rekordów
txt <- na.omit(txt)
#wyeksporotwanie do pliku .xlsx
write_xlsx(txt,"test.xlsx")