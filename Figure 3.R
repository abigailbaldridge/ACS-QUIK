library(forestplot)
library(grid)

data <- read.csv(file="Q:/Faculty/Huffman/NU/ACS QUIK/Data/Code/R Code/StrataORs.csv",header=TRUE,sep=",",stringsAsFactors=FALSE)
attach(data)

forestplotdata <- c("mean", "lower","upper")
tabledata <- rbind(c(NA,NA,NA),data[forestplotdata])

tabletext <- cbind(c("",data$X),c("Intervention (%)",data$Intervention),c("Control (%)",data$Control),c("Adjusted Difference,\n% (95% CI)",data$RiskDifference),c("Adjusted Odds\nRatio (95% CI)",data$ORCI))
  
forestplot(labeltext = tabletext, graph.pos = 6,
           tabledata,
           clip = c(0.5,2.0),
           is.summary=c(TRUE,TRUE,rep(FALSE,3),TRUE,rep(FALSE,2),
                        TRUE,rep(FALSE,2),TRUE,rep(FALSE,4),
                        TRUE,rep(FALSE,3)),
           zero      = 1,
           xlog      = TRUE,
           xlab="Favors Intervention     Adjusted Odds Ratio     Favors Control    ",
           col = fpColors(lines="black", box="black", zero = "gray80"),
           txt_gp=fpTxtGp(label=gpar(cex=0.9),
                          ticks=gpar(cex=1.0),
                          xlab=gpar(cex = 1.0)),
           xticks=c(.33,1,3),
           cex=0.9,
           title="Major Adverse Cardiovascular Events,                                                                                \nNo. of Patients/Total No. (%)                                                                            ")
 
