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

baltimoreCityData <- subset(summaryData, fips=="24510")


baltPlot <- ggplot(baltimoreCityData, aes(factor(year),Emissions/1000,fill=type))
baltPlot <- baltPlot + geom_bar(stat="identity") + facet_grid(.~type)+guides(fill=FALSE)+
            labs(title="PM 2.5 Emissions by type for Balitmore City, MD",x="Year",y="Total PM2.5 Kilotons(metric)")
print(baltPlot)
dev.copy(png, file="./plot3.png")
dev.off()
