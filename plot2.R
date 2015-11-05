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
  png(file="plot2.PNG", width = 480, height = 480, units = "px")
  plot(strptime(parsetable$dateandtime, "%d/%m/%Y %H:%M:%S"), parsetable$globalactivepower, type = "l", ylab = "Global Active Power (kilowatts)", xlab="")
  dev.off()