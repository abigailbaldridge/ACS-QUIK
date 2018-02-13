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

# Create proportions and sum values for MACE by site and step
groupColumns = c("CentreId","Step","Cohort","Intervention")
prop <-ddply(results,groupColumns,summarise,
                 prop=100*(sum(MACE)/length(MACE)),
                 num = length(MACE),
                 low=100*(prop.test(sum(MACE),length(MACE))$conf.int[1]),
                 upper=100*(prop.test(sum(MACE),length(MACE))$conf.int[2]))

prop<-prop[order(prop$Cohort, prop$CentreId),]

dodge <- position_dodge(width=0.7)

cohort_names <- c(
  '1' = "Cohort 1",
  '2' = "Cohort 2",
  '3' = "Cohort 3",
  '4' = "Cohort 4",
  '5' = "Cohort 5"
)

#yellow <- colorRampPalette(c("white", "orangered2"))
#yellow(14)
#plot(rep(1,14),col=yellow(14),pch=19,cex=3)         
         
# Plot MACE Rates by Cohort and Step
MACEPlot <- ggplot(prop,aes(x=Step,y=prop,colour=factor(CentreId),shape=factor(Intervention), size =6))+
  geom_errorbar(aes(ymin=low,ymax=upper,colour=factor(CentreId)),position=dodge,size=1,width=0.2) + 
  geom_point(stat="identity",position=dodge,fill="white",size=3)+
  ylim(0,30) +
  xlab("Step") +
  ylab("MACE, %") + 
  scale_x_continuous(breaks = seq(0, 5, 1)) + 
  scale_color_manual(values=c("#FDF0EB","#E4DBED","#EBEBFB","#FCE1D7","#D7D7F7",
                              "#D7E7D7","#FBD2C4","#C4DBC4","#D7CAE4","#FCF3DD",
                              "#FBEDCC","#CAB8DB","#BDA6D2","#B0CFB0","#C4C4F3",
                              "#B095C9","#F9E7BB","#9CC39C","#B0B0EF","#F9C4B0",
                              "#9C9CEB","#F8E2AA","#8989E7","#89B789","#A383C0",
                              "#F8B59C","#F7DC99","#9672B7","#75AB75","#F7A689",
                              "#F59875","#7575E4","#8960AE","#F5D687","#629F62",
                              "#F48962","#F4D077","#F3CB66","#F37A4E","#6262E0",
                              "#4E4EDC","#4E934E","#F1C554","#F16C3A","#7C4EA5",
                              "#3A3AD8","#3A873A","#277B27","#136F13","#6F3D9C",
                              "#F05D27","#2727D4","#F0BF43","#622B93","#551A8B",
                              "#006400","#EF4E13","#EE4000","#1313D0","#0000CD",
                              "#EFB932","#EEB422" ),guide='none') +
  theme_classic() + 
  theme(plot.caption=element_text(hjust = 0,size=14)) +
  theme(legend.text=element_text(size=14)) +
  theme(axis.text.x=element_text(size=14)) + 
  theme(axis.text.y=element_text(size=14)) + 
  theme(text = element_text(size=14)) + 
  scale_shape_manual(values = c(21,16), guide = 'none') + 
  scale_size(guide = 'none') + 
  theme(legend.position="none") + 
  facet_grid(Cohort~.,labeller = as_labeller(cohort_names)) + 
  theme(strip.text.y = element_text(angle = 0),
        strip.background = element_rect(colour = "white", fill = "white"),
        panel.grid.major.y = element_line(colour = "grey80"))

MACEPlot

# Repeat for Death Rates
prop <-ddply(results,groupColumns,summarise,
             prop=100*(sum(Death)/length(Death)),
             num = length(Death),
             low=100*(prop.test(sum(Death),length(Death))$conf.int[1]),
             upper=100*(prop.test(sum(Death),length(Death))$conf.int[2]))

prop<-prop[order(prop$Cohort, prop$CentreId),]

DeathPlot <- ggplot(prop,aes(x=Step,y=prop,colour=factor(CentreId),shape=factor(Intervention), size =6))+
  geom_errorbar(aes(ymin=low,ymax=upper,colour=factor(CentreId)),position=dodge,size=1,width=0.2) + 
  geom_point(stat="identity",position=dodge,fill="white",size=3)+
  ylim(0,30) +
  xlab("Step") +
  ylab("30 Day Mortality, %") + 
  scale_x_continuous(breaks = seq(0, 5, 1)) + 
  scale_color_manual(values=c("#FDF0EB","#E4DBED","#EBEBFB","#FCE1D7","#D7D7F7",
                              "#D7E7D7","#FBD2C4","#C4DBC4","#D7CAE4","#FCF3DD",
                              "#FBEDCC","#CAB8DB","#BDA6D2","#B0CFB0","#C4C4F3",
                              "#B095C9","#F9E7BB","#9CC39C","#B0B0EF","#F9C4B0",
                              "#9C9CEB","#F8E2AA","#8989E7","#89B789","#A383C0",
                              "#F8B59C","#F7DC99","#9672B7","#75AB75","#F7A689",
                              "#F59875","#7575E4","#8960AE","#F5D687","#629F62",
                              "#F48962","#F4D077","#F3CB66","#F37A4E","#6262E0",
                              "#4E4EDC","#4E934E","#F1C554","#F16C3A","#7C4EA5",
                              "#3A3AD8","#3A873A","#277B27","#136F13","#6F3D9C",
                              "#F05D27","#2727D4","#F0BF43","#622B93","#551A8B",
                              "#006400","#EF4E13","#EE4000","#1313D0","#0000CD",
                              "#EFB932","#EEB422" ),guide='none') +
  theme_classic() + 
  theme(plot.caption=element_text(hjust = 0,size=14)) +
  theme(legend.text=element_text(size=14)) +
  theme(axis.text.x=element_text(size=14)) + 
  theme(axis.text.y=element_text(size=14)) + 
  theme(text = element_text(size=14)) + 
  scale_shape_manual(values = c(21,16), guide = 'none') + 
  scale_size(guide = 'none') + 
  theme(legend.position="none") + 
  facet_grid(Cohort~.,labeller = as_labeller(cohort_names)) + 
  theme(strip.text.y = element_text(angle = 0),
        strip.background = element_rect(colour = "white", fill = "white"),
        panel.grid.major.y = element_line(colour = "grey80"))

DeathPlot