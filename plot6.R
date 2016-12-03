library(ggplot2)

#setting up project folder to download file
exdataProj2Fold <- "edaproj2"
dataFolderRootPath <- paste0("./",exdataProj2Fold)

if (!dir.exists(exdataProj2Fold)) 
{  
  dir.create(exdataProj2Fold)
  projDataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

  zipFileName <- "exdata_data_NEI_data.zip"
  zipFilePath <- paste0("./",exdataProj2Fold,"/",zipFileName)

  #dowload file from the URL provided
  if (!file.exists(zipFilePath)) 
    download.file(projDataUrl,destfile = zipFilePath)
  
  #unzip dataset downloaded from the url.
  unzip (zipfile = zipFilePath,exdir = dataFolderRootPath)
}  

summaryFile = paste0(dataFolderRootPath,"/","summarySCC_PM25.rds")
summaryData <- readRDS(summaryFile)

sourceClassFile = paste0(dataFolderRootPath,"/","Source_Classification_Code.rds")
sourceClassData <- readRDS(sourceClassFile)

baltOnRoadData <- subset(summaryData, fips=="24510" & type=="ON-ROAD")
laOnRoadData <- subset(summaryData, fips=="06037" & type=="ON-ROAD")

baltSUmmaryPMS <- aggregate(Emissions ~ year,baltOnRoadData,sum)
baltSUmmaryPMS$Location <- "Baltimore City"
laSummaryPMS <- aggregate(Emissions ~ year,laOnRoadData,sum)
laSummaryPMS$Location <- "Los Angeles County"

balaSummaryPMS <- rbind(baltSUmmaryPMS,laSummaryPMS)

balaltPlot <- ggplot(balaSummaryPMS, aes(factor(year),Emissions,fill=Location))
balaltPlot <- balaltPlot + geom_bar(stat="identity") + facet_grid(.~Location) + guides(fill=FALSE) +
  labs(title="PM 2.5 Compare Motor Vehicle Emissions (Baltimore Vs LA)",x="Year",y="Total PM2.5 tons")
print(balaltPlot)
dev.copy(png, file="./plot6.png")
dev.off()
