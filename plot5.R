
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

mvBaltSUmmaryPMS <- aggregate(Emissions ~ year,baltOnRoadData,sum)

barplot((mvBaltSUmmaryPMS$Emissions),
        names.arg = mvBaltSUmmaryPMS$year,
        main="Total Motor Vehicle emissions in Baltimore City, MD", 
        xlab="Year",
        ylab="PM2.5 in Tons")
dev.copy(png, file="./plot5.png")
dev.off()
