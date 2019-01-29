library(sas7bdat)
library(ggplot2)
library(plyr)

setwd("Q:/Faculty/Huffman/NU/ACS QUIK/Data/Code/R Code/Seattle Angina Paper/")
results <- read.sas7bdat("Q:/Faculty/Huffman/NU/ACS QUIK/Data/Code/SAS Code/Seattle Angina Paper/Figure1.sas7bdat")

results$count <- 1

Male <- subset(results,Male==1)
Female <- subset(results,Male==0)

ggplot(Male,aes(x=Order,y=count, fill=YOrder)) + 
  geom_bar(stat="identity") + 
  theme_classic() + 
  scale_x_discrete(labels=c('A' = "Self\nDressing", 'B' = "Walking\nIndoors", 'C' = "Showering", 'D' ="Climb Without\nStopping", 'E'="Gardening",'F'="Brisk Walking\nPace",'G'="Running", 'H'="Lifting Heavy\nObjects",'I'="Sports")) + 
  scale_fill_discrete(name="Response",labels=c('G' = 'Severely Limited','F'= 'Moderately Limited','E' = 'Somewhat Limited', 'D' = 'A Little Limited','C' = 'Not Limited','B' = 'Limited, Or Did Not Do', 'A' = 'Did Not Respond')) + 
  xlab("\nPhysical Activity Question") +
  ylab("Number of Responses") + 
  ggtitle("Physical Activity Responses Among Men") + 
  theme(axis.text.x=element_text(size=14,colour="black")) + 
  theme(axis.text.y=element_text(size=14,colour="black")) + 
  theme(text = element_text(size=16)) + 
  scale_colour_manual(values = Colors)

ggsave('Figure 1a.tiff', plot = last_plot(), device = "tiff", path = NULL,
       scale = 1, width = NA, height = NA, units = c("mm"),
       dpi = 300, limitsize = TRUE)


ggplot(Female,aes(x=Order,y=count, fill=YOrder)) + 
  geom_bar(stat="identity") + 
  theme_classic() + 
  scale_x_discrete(labels=c('A' = "Self\nDressing", 'B' = "Walking\nIndoors", 'C' = "Showering", 'D' ="Climb Without\nStopping", 'E'="Gardening",'F'="Brisk Walking\nPace",'G'="Running", 'H'="Lifting Heavy\nObjects",'I'="Sports")) + 
  scale_fill_discrete(name="Response",labels=c('G' = 'Severely Limited','F'= 'Moderately Limited','E' = 'Somewhat Limited', 'D' = 'A Little Limited','C' = 'Not Limited','B' = 'Limited, Or Did Not Do', 'A' = 'Did Not Respond')) + 
  xlab("\nPhysical Activity Question") +
  ylab("Number of Responses") + 
  ggtitle("Physical Activity Responses Among Women") + 
  theme(axis.text.x=element_text(size=14,colour="black")) + 
  theme(axis.text.y=element_text(size=14,colour="black")) + 
  theme(text = element_text(size=16)) + 
  scale_colour_manual(values = Colors)

ggsave('Figure 1b.tiff', plot = last_plot(), device = "tiff", path = NULL,
       scale = 1, width = NA, height = NA, units = c("mm"),
       dpi = 300, limitsize = TRUE)