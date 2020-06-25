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
f1$Date <- as.Date(f1$Date, format= "%d/%m/%Y")

#alternate solution using lubridate package
#f1$Date <- lubridate::dmy(f1$Date)

#Subsetting based on Date column; values of dates between 1/2/2007 and 2/2/2007
f2 <- subset(f1, f1$Date >= '2007-02-01' & f1$Date <= '2007-02-02')

#Combining the date and time columns to create a continous plot (as in time-series)
f2$DateTime <- paste(f2$Date,f2$Time, sep="_")

#converting the DateTime column to POSIXct format to plot the graph
f2$DateTime <- as.POSIXct(f2$DateTime, format = "%Y-%m-%d_%H:%M:%S")

#alternate solution using lubridate package
#f2$DateTime <- lubridate::ymd_hms(f2$DateTime, tz="Asia/Kolkata")

#creating the plot

#opening graphics device( a file device:png)
png("plot3.png", width=480, height=480)

#setting type, color to reproduce plot3 in question
#creating DateTime vs Sub_metering_1 as the initial plot and then adding points corresponding to DateTime vs Sub_metering_2 (in red) and points corresponding to DateTime vs Sub_metering_3 (in blue) 
with(f2, {
    plot(DateTime, Sub_metering_1, type = 'l', ylab = "Energy sub metering", xlab = "")
    points(DateTime, Sub_metering_2, type='l', col="red")
    points(DateTime, Sub_metering_3, type='l', col="blue")
})

#including the legend to identify the type of sub-metering in the top-right corner of the plot
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"), lty = "solid",x.intersp=0.5)

#closing the opened file device
dev.off()

print("Plot created successfully...")