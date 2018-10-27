################################################################
# PLOT4.R
# produces a basic plot  with the R base plotting system
# and copies it as a png-file to another graphic device
################################################################
cat("\014") ## clear console
rm(list = ls())

library(dplyr)
library(data.table)

my_lc_time <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "English")

big_df <- fread("household_power_consumption.txt",nrows = 100000,
                na.strings = "?", sep = ";", dec = ".")

modified_df <- mutate(big_df, date_new = as.Date(Date,"%d/%m/%Y"),
                      time_new = as.POSIXct(strptime(Time, "%H:%M:%S")))

small_df <- dplyr::filter(modified_df, date_new >= as.Date("01/02/2007", "%d/%m/%Y") 
                         & date_new <= as.Date("02/02/2007", "%d/%m/%Y"))

small_df2 <- mutate(small_df,
                    datetime = as.POSIXct.Date(date_new) + (hour(time_new) - 1)*60*60 + minute(time_new)*60)

windows()
par(mfrow = c(2,2))
with(small_df2, 
    {
  
  plot(datetime, Global_active_power, ylab = "Global Active Power", xlab = "", pch = 20, cex = 0.5, type = "l")
  plot(datetime, Voltage, ylab = "Voltage", pch = 20, cex = 0.5, type = "l")
  plot(datetime, Sub_metering_1,
       ylab = "Energy Sub metering", xlab = "", pch = 20, col = "black", cex = 0.5, type = "l")
        lines(datetime, Sub_metering_2, col = "red")
        lines(datetime, Sub_metering_3, col = "blue")
        legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                col = c("black", "red", "blue"), lty = 1, cex = 1, bty = "n")
          
  plot(datetime, Global_reactive_power, pch = 20, cex = 0.5, type = "l")        
    })

    
dev.copy(png, file = "plot4.png", width = 480)
dev.off()

Sys.setlocale("LC_TIME", my_lc_time)

