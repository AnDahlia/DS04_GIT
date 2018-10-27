################################################################
# PLOT3.R
# produces a basic plot  with the R base plotting system
# and copies it as a png-file to another graphic device
################################################################
cat("\014") ## clear console
rm(list = ls())

library(dplyr)
library(data.table)

my_lc_time <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "English")

#load and read data
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp3 <- tempfile()
download.file(fileUrl, temp3)
big_df <- read.table(unz(temp3, "household_power_consumption.txt"),header = TRUE, 
                     nrows = 100000, na.strings = "?", sep = ";", dec = ".")
unlink(temp3)

#modify data
modified_df <- mutate(big_df, date_new = as.Date(Date,"%d/%m/%Y"),
                      time_new = as.POSIXct(strptime(Time, "%H:%M:%S")))

small_df <- dplyr::filter(modified_df, date_new >= as.Date("01/02/2007", "%d/%m/%Y") 
                         & date_new <= as.Date("02/02/2007", "%d/%m/%Y"))

small_df2 <- mutate(small_df,
                    datetime = as.POSIXct.Date(date_new) + (hour(time_new) - 1)*60*60 + minute(time_new)*60)

#plot data
windows()
with(small_df2, 
    {
  plot(datetime, Sub_metering_1,
       ylab = "Energy Sub metering", xlab = "", pch = 20, col = "black", cex = 0.5, type = "l")
        lines(datetime, Sub_metering_2, col = "red")
        lines(datetime, Sub_metering_3, col = "blue")
        legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                col = c("black", "red", "blue"), lty = 1, cex = 1, bty = "n")
    })


dev.copy(png, file = "plot3.png", width = 480)
dev.off()

Sys.setlocale("LC_TIME", my_lc_time)

