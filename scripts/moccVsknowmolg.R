library("ggplot2")
library("reshape2")

##oases dn, oases raw,trinity dn, trinity raw
p_mapped=c(100,100,44.38,66.85,
           99.55,99.10,88.49,89.52,
           53.08,54.10,30.52,45.5)
stdv=c(0,0,0,0,
       2.35,3.29,6.51,5.31,
       36.83,37.58,30.90,26.69)
p_mapped_frame<-data.frame(Sample= c("Trinity", "DN Trinity","Oases","DN Oases",
                                     "Trinity", "DN Trinity","Oases","DN Oases",
                                     "Trinity", "DN Trinity","Oases","DN Oases"),
                           prog=c("recovery","recovery","recovery","recovery",
                                  "accuracy","accuracy","accuracy","accuracy",
                                  "completeness","completeness","completeness","completeness"),
                           Values1 = p_mapped)
dodge <- position_dodge(width=0.9)
p_mapped.melt<-melt(p_mapped_frame,id.vars=1:2)
p_mapped.melt$Sample<-factor(p_mapped.melt$Sample, as.character(p_mapped.melt$Sample)) #fix bar ordering
p_mapped_frame$Sample<-factor(p_mapped_frame$Sample, as.character(p_mapped_frame$Sample))
std <- transform(p_mapped_frame, lower=Values1-stdv, upper=Values1+stdv)
pdf('/Users/elijahklowe/2014-mrnaseq-cloud/manuscript/figure_4_moccVsknownmolg.pdf',height=8.5,width=11,paper='special')
ggplot(p_mapped_frame,aes(x=Sample,y=Values1,fill=Sample),beside=True)+
  coord_cartesian(ylim=c(0,105))+
  geom_bar(stat="identity",position=dodge)+facet_grid(. ~ prog)+ #show actual count and bin by treatment
  scale_fill_grey(start = .1, end = .8,name="Assembly method")+
  ylab("Percent")+
  xlab("")+
  theme(axis.text.x = element_blank(),axis.ticks.x = element_blank(),
        text = element_text(size=18))+
  ggtitle("Assembly metrics for M. occulta vs known Molgula nucleotides")+
  geom_errorbar(aes(ymax=upper, ymin=lower), width=0.25, data=std)
dev.off()