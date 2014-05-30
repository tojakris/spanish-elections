## This scrip generates a new file with voter turnout data in Spain

source("code/configuration.R")

elections <- read.csv(paste0(created.data.path, "elections.csv"),
                      colClasses = "character")
 
library(xlsx)
library(stringr)

new.file.name <- paste0(created.data.path, "turnout_data.csv")

for (i in 1:nrow(elections)) {
    election <- elections[i,]
    file.name <- paste0(original.data.path, election$type, "_", 
                        election$year, election$month, "_1.xlsx")
    
    election.data <- read.xlsx2(file.name, sheetIndex=1, header=TRUE, startRow=6,
                               colIndex=1:13, stringsAsFactors=FALSE)
    
    colnames(election.data) = c("comunidad", "codigo.provincia","provincia",
                                "codigo.municipio","municipio", "poblacion", 
                                "mesas", "censo", "votantes", "votos.validos", 
                                "votos.a.candidaturas", "votos.en.blanco", 
                                "votos.nulos")
    
    election.data$comunidad <- str_trim(election.data$comunidad)
    election.data$provincia <- str_trim(election.data$provincia)
    election.data$municipio <- str_trim(election.data$municipio)
    
    election.data <- cbind(election, election.data)
    
    if (i == 1) {
        total.election.data <- election.data
    } else {
        total.election.data <- rbind(total.election.data, election.data)
    } 
    
}

write.table(total.election.data, file = new.file.name, append = FALSE, 
            quote = TRUE, sep=",", row.names = FALSE, col.names = TRUE)

