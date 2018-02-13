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
results <- read.csv("Q:/Faculty/Huffman/NU/ACS QUIK/Data/Output/Primary Outcomes Paper/eFigure1.csv")


ggplot(results,aes(x=Order,y=MACEChange,size=(Frequency*Frequency)))+
  geom_point(aes(colour=factor(Cohort)),stat="identity") +
  scale_colour_manual(values=c("#006400","#000080","#872657","#CD3333","#9C661F"), name = "Cohort") + 
  theme_classic() +
  xlab("Hospital By Rank Order") +
  ylab("Decrease in 30-day MACE Rate (Control - Intervention), %") + 
  theme(plot.caption=element_text(hjust = 0,size=14)) +
  theme(legend.text=element_text(size=14)) +
  theme(axis.text.x=element_text(size=14)) + 
  theme(axis.text.y=element_text(size=14)) +
  theme(text = element_text(size=14)) + 
  theme(legend.position = c(0.9, 0.8)) + 
  scale_size(guide = 'none')



   














