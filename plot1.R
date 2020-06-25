# ---
# Author: Akhila G P
# Date: 2020-06-24
# ---

#to reproduce the plot, the file "household_power_consumption.txt" should be in the same directory as the script (should also be the current working directory)
library(data.table)

#getting current directory's location
currentWD <- getwd()
zipfileName <- "exdata_data_household_power_consumption.zip"

#download and unzipping dataset if it's not present in the same directory as this R script.
if(!"household_power_consumption.txt"  %in% dir(path = currentWD, full.names = F, recursive = F)){
    if(zipfileName %in% dir(path = currentWD, full.names = F, recursive = F)){
        print("Unzipping to get the .txt file..")
        unzip(zipfile = file.path(currentWD,zipfileName))
    }else{
    print("Downloading dataset...")
    datasetURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    
    datasetFile <- download.file(datasetURL,destfile = file.path(currentWD,zipfileName), method = "curl")
    unzip(zipfile = file.path(currentWD, zipfileName))
    print("Dataset downloaded and unzipped...")
}
}

#reading the file with separator ';' and the NA values are coded as '?'
print("Reading the dataset...")
f1 <- fread("household_power_consumption.txt", header = T, sep = ";", na.strings = "?")

#converting the Date column (the format dd/mm/yyyy) of the dataset into Date type
f1$Date <- as.Date(f1$Date, "%d/%m/%Y")

#alternate solution using lubridate package 
#f1$Date <- lubridate::dmy(f1$Date)

#Subsetting based on Date column; values of dates between 1/2/2007 and 2/2/2007
f2 <- subset(f1, f1$Date >= '2007-02-01' & f1$Date <= '2007-02-02')

#creating the plot

#opening graphics device( a file device:png)
png("plot1.png", width=480, height=480)

#drawing the histogram of the variable Global active power
#setting the values of xlab, title and the color to reproduce plot1 in question
with(f2, hist(Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power"))

#closing the opened file device
dev.off()

print("Plot created successfully...")