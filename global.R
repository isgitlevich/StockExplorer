library(data.table)
library(quantmod)
library(dplyr)
library(dygraphs)
library(bit64)
library(shiny)


fortune <- fread(file = "C:/Users/Igor Gitlevich/Documents/Academy/Shiny/stockPredictor/Fortune500.csv")

# remove row names
rownames(fortune) <- NULL

#rename columns
colnames(fortune) <- c("cik", "symbol", "company", "industry", "sector", "sic", "web", 
                       "assets", "revenue", "income", "eps", "shares")

#Sort by Sector, then by Company
fortune <- fortune %>% arrange(sector, company, symbol, industry)
fortune[fortune$symbol == "KO", ]$company = "COCA COLA"

#Fetch indices information once
indices <- c("^GSPC", "^DJI", "^NYA")
getSymbols(indices)

#Sectprs and Companies choices
sectorsChoice <- unique(fortune$sector)
companiesChoice <- unique(fortune$company)

#Extra columns not needed
fortune <- fortune %>% select(-web, -cik)




