#find which lines to read
  firstDateTime <- strptime("2006-12-16 17:24:00", "%Y-%m-%d %H:%M:%S")
  beginDateTime <- strptime("2007-02-01 00:01:00", "%Y-%m-%d %H:%M:%S")
  begin <- beginDateTime - firstDateTime
  beginLine <- as.numeric(begin) * 24 * 60 # first line to read in
  numLines <- 48 * 60 # total number of minutes in 48 hours, total number of rows to read in


#define URL and destination filename
  URL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  filename<-"household_power_consumption3.txt"

#download and unzip files  
  temp <- tempfile()
  download.file(URL,temp)
  parsetable <- read.table(unz(temp, "household_power_consumption.txt"), sep=";", skip = beginLine, nrows=numLines,na.strings="?", stringsAsFactors=TRUE )
  unlink(temp)


#create name labels for dataset  
  names(parsetable)<-c("date","time","globalactivepower","globalreactivepower","voltage","globalintensity","submetering1","submetering2","submetering3")

#add variable that is combo of date and time  
  parsetable$dateandtime<-paste(parsetable$date, parsetable$time)

#clean up unnecessary variables  
  rm(firstDateTime, beginDateTime, begin, beginLine, numLines) 

#create plot
  png(file="plot4.PNG", width = 480, height = 480, units = "px")
  par(mfcol=c(2,2))
  plot(strptime(parsetable$dateandtime, "%d/%m/%Y %H:%M:%S"), parsetable$globalactivepower, type = "l", ylab = "Global Active Power (kilowatts)", xlab="")
  
  plot(strptime(parsetable$dateandtime, "%d/%m/%Y %H:%M:%S"), parsetable$submetering1, type = "l", ylab = "Global Active Power (kilowatts)", xlab="")
  with(parsetable,lines(strptime(dateandtime, "%d/%m/%Y %H:%M:%S"), submetering2, col="red"))
  with(parsetable,lines(strptime(dateandtime, "%d/%m/%Y %H:%M:%S"), submetering3, col="blue"))
  legend("topright",col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty=c(1,1))
  
  plot(strptime(parsetable$dateandtime, "%d/%m/%Y %H:%M:%S"), parsetable$voltage, type = "l", ylab = "Voltage", xlab="datetime")
  
  plot(strptime(parsetable$dateandtime, "%d/%m/%Y %H:%M:%S"), parsetable$globalreactivepower, type = "l", ylab = "Global_reactive_power", xlab="datetime")
  dev.off()