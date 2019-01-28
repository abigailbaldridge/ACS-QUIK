library(sas7bdat)
library(ggplot2)
library(plyr)
library(scales) 
library(gridExtra)
library(gridBase)
library(gtable)
library(stringr)
library(grid)
library(ggrepel)

setwd("Q:/Faculty/Huffman/NU/ACS QUIK/Data/Code/R Code/")
results <- read.sas7bdat("Q:/Faculty/Huffman/NU/ACS QUIK/Data/Code/SAS Code/Primary Outcomes Paper/Included.sas7bdat")

# Reset missing MACE and death to 0 for correct percentages
results$MACE[is.na(results$MACE)] <- 0
results$Death[is.na(results$Death)] <- 0

table(results$MACE,results$Intervention)
table(results$Death,results$Intervention)

# Create proportions and sum values for MACE
groupColumns = c("Step","Cohort","Intervention")
prop <-ddply(results,groupColumns,summarise,
                 prop=100*(sum(MACE)/length(MACE)),
                 num = length(MACE),
                 low=100*(prop.test(sum(MACE),length(MACE))$conf.int[1]),
                 upper=100*(prop.test(sum(MACE),length(MACE))$conf.int[2]))

groupColumns = c("Step","Intervention")
propgroup <-ddply(results,groupColumns,summarise,
                  prop=100*(sum(MACE)/length(MACE)),
                  num = length(MACE),
                  low=100*(prop.test(sum(MACE),length(MACE))$conf.int[1]),
                  upper=100*(prop.test(sum(MACE),length(MACE))$conf.int[2]))

dodge <- position_dodge(width=0.7)

# Plot MACE Rates by Cohort and Step
MACEPlot <- ggplot(prop,aes(x=Step,y=prop,colour=factor(Cohort),shape=factor(Intervention), size =10))+
  geom_errorbar(aes(ymin=low,ymax=upper,colour=factor(Cohort)),position=dodge,size=1,width=0.2) + 
  geom_point(stat="identity",position=dodge,fill="white",size=7)+
  geom_text(aes(label=factor(Cohort)),position=dodge,size=5) + 
  ylim(0,12.5) +
  scale_color_manual(values=c("#006400","#000080","#872657","#CD3333","#9C661F"),guide='none') +
  xlab("Step") +
  ylab("MACE, %") + 
  scale_x_continuous(breaks = seq(0, 5, 1)) + 
  theme_classic() + 
  theme(plot.caption=element_text(hjust = 0,size=14)) +
  theme(legend.text=element_text(size=14)) +
  theme(axis.text.x=element_text(size=14)) + 
  theme(axis.text.y=element_text(size=14)) + 
  theme(text = element_text(size=14)) + 
  scale_shape_manual(values = c(21,16), guide = 'none') + 
  scale_size(guide = 'none') +   
  annotate("text", x = 0.72, y = 3.77, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 1.72, y = 2.40, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 2.72, y = 2.60, label = sprintf('1'), size=5,colour="white") + 
  annotate("text", x = 3.72, y = 3.14, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 4.72, y = 5.71, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 1.86, y = 7.88, label = sprintf('2'), size=5,colour="white") +
  annotate("text", x = 2.86, y = 5.75, label = sprintf('2'), size=5,colour="white") + 
  annotate("text", x = 3.86, y = 4.41, label = sprintf('2'), size=5,colour="white") +
  annotate("text", x = 4.86, y = 3.67, label = sprintf('2'), size=5,colour="white") +
  annotate("text", x = 3.0, y = 7.56, label = sprintf('3'), size=5,colour="white") + 
  annotate("text", x = 4.0, y = 6.76, label = sprintf('3'), size=5,colour="white") +
  annotate("text", x = 5.0, y = 5.40, label = sprintf('3'), size=5,colour="white") +
  annotate("text", x = 4.14, y = 6.05, label = sprintf('4'), size=5,colour="white") +
  annotate("text", x = 5.14, y = 5.10, label = sprintf('4'), size=5,colour="white") +
  annotate("text", x = 5.28, y = 6.14, label = sprintf('5'), size=5,colour="white")
  
#Add in Counts and Averages
prop$prop <- NULL
prop$low <- NULL
prop$upper <- NULL
prop$Intervention <- NULL

wide<-reshape(prop, timevar="Step", idvar=c("Cohort"), direction="wide")
row.names(wide)<-c("Cohort 1","Cohort 2", "Cohort 3", "Cohort 4", "Cohort 5")
wide$Cohort <- NULL
colnames(wide) <- c("Step 0", "Step 1", "Step 2", "Step 3", "Step 4", "Step 5")

tt <- ttheme_minimal()
TableMACE <- tableGrob(wide,theme=tt)

TableMACE$widths <- unit(rep(1/ncol(TableMACE), ncol(TableMACE)), "npc")

# Add in a text title for the table
title <- textGrob("Number of Participants per Step and Cohort", vjust=0, gp=gpar(fontsize=14))

# Arrange the MACE figure
grid.arrange(arrangeGrob(MACEPlot, nrow=1), 
             arrangeGrob(title),
            arrangeGrob(TableMACE, nrow=1,as.table=TRUE),
            heights=c(3,0.2,1))


# Repeat for Death Rates
groupColumns = c("Step","Cohort","Intervention")
prop <-ddply(results,groupColumns,summarise,
             prop=100*(sum(Death)/length(Death)),
             num = length(Death),
             low=100*(prop.test(sum(Death),length(Death))$conf.int[1]),
             upper=100*(prop.test(sum(Death),length(Death))$conf.int[2]))

groupColumns = c("Step","Intervention")
propgroup <-ddply(results,groupColumns,summarise,
                  prop=100*(sum(Death)/length(Death)),
                  num = length(Death),
                  low=100*(prop.test(sum(Death),length(Death))$conf.int[1]),
                  upper=100*(prop.test(sum(Death),length(Death))$conf.int[2]))

# Plot Death Rates by Cohort and Step
DeathPlot <- ggplot(prop,aes(x=Step,y=prop,colour=factor(Cohort),shape=factor(Intervention), size =10))+
  geom_errorbar(aes(ymin=low,ymax=upper,colour=factor(Cohort)),position=dodge,size=1,width=0.2) + 
  geom_point(stat="identity",position=dodge,fill="white",size=7)+
  geom_text(aes(label=factor(Cohort)),position=dodge,size=5) + 
  ylim(0,12.5) +
  scale_color_manual(values=c("#006400","#000080","#872657","#CD3333","#9C661F"),guide='none') +
  xlab("Step") +
  ylab("30 Day Mortality, %") + 
  scale_x_continuous(breaks = seq(0, 5, 1)) + 
  theme_classic() + 
  theme(plot.caption=element_text(hjust = 0,size=14)) +
  theme(legend.text=element_text(size=14)) +
  theme(axis.text.x=element_text(size=14)) + 
  theme(axis.text.y=element_text(size=14)) + 
  theme(text = element_text(size=14)) + 
  scale_shape_manual(values = c(21,16), guide = 'none') + 
  scale_size(guide = 'none') +
  annotate("text", x = 0.72, y = 2.72, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 1.72, y = 2.03, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 2.72, y = 2.29, label = sprintf('1'), size=5,colour="white") + 
  annotate("text", x = 3.72, y = 2.64, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 4.72, y = 1.70, label = sprintf('1'), size=5,colour="white") +
  annotate("text", x = 1.86, y = 5.95, label = sprintf('2'), size=5,colour="white") +
  annotate("text", x = 2.86, y = 5.10, label = sprintf('2'), size=5,colour="white") + 
  annotate("text", x = 3.86, y = 3.16, label = sprintf('2'), size=5,colour="white") +
  annotate("text", x = 4.86, y = 3.00, label = sprintf('2'), size=5,colour="white") +
  annotate("text", x = 3.0, y = 5.54, label = sprintf('3'), size=5,colour="white") + 
  annotate("text", x = 4.0, y = 5.48, label = sprintf('3'), size=5,colour="white") +
  annotate("text", x = 5.0, y = 3.94, label = sprintf('3'), size=5,colour="white") +
  annotate("text", x = 4.14, y = 3.95, label = sprintf('4'), size=5,colour="white") +
  annotate("text", x = 5.14, y = 4.47, label = sprintf('4'), size=5,colour="white") +
  annotate("text", x = 5.28, y = 4.35, label = sprintf('5'), size=5,colour="white")

#Add in Counts and Averages
prop$prop <- NULL
prop$low <- NULL
prop$upper <- NULL
prop$Intervention <- NULL

wide<-reshape(prop, timevar="Step", idvar=c("Cohort"), direction="wide")
row.names(wide)<-c("Cohort 1","Cohort 2", "Cohort 3", "Cohort 4", "Cohort 5")
wide$Cohort <- NULL
colnames(wide) <- c("Step 0", "Step 1", "Step 2", "Step 3", "Step 4", "Step 5")

tt <- ttheme_minimal()
TableDeath <- tableGrob(wide,theme=tt)

TableDeath$widths <- unit(rep(1/ncol(TableDeath), ncol(TableDeath)), "npc")

grid.arrange(arrangeGrob(DeathPlot, nrow=1), 
             arrangeGrob(title),
             arrangeGrob(TableDeath,nrow=1,as.table=TRUE),
             heights=c(3,0.2,1))










