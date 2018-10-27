################################################################
# PLOT1.R
# produces a basic plot  with the R base plotting system
# and copies it as a png-file to another graphic device
################################################################
cat("\014") ## clear console
rm(list = ls())

library(dplyr)
library(data.table)


my_lc_time <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "English")

big_df <- fread("household_power_consumption.txt",nrows = 100000, na.strings = "?", sep = ";", dec = ".")

modified_df <- mutate(big_df, date_new = as.Date(Date,"%d/%m/%Y"), time_new = as.POSIXct(strptime(Time, "%H:%M:%S")))
date_beg <- as.Date("01/02/2007", "%d/%m/%Y")
date_end <- as.Date("02/02/2007", "%d/%m/%Y")
small_df <- dplyr::filter(modified_df, date_new >= date_beg & date_new <= date_end)

windows()
hist(small_df$Global_active_power,col = "red",main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", font = 6)

dev.copy(png, file = "plot1.png", width = 480)
dev.off()

Sys.setlocale("LC_TIME", my_lc_time)




