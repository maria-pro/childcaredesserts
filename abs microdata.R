
There are two files I need create using census data.

1. educational attendance by young people aged 3-24
The first file I will use to look at changes in educational attendance by young people aged 3-24.


2. changes in employment by qualification level
The second I will use to examine changes in employment by qualification level.


3. what the codes mean in the variables
I think I will also need to get hold of what the codes mean in the variables at some point.

Data: years from

not 2021.

library(tidyverse)
library(haven)

#1986
#AGE30S	TYP	OCC03	CIT
#AGE30S	INC13S	QAL02S	OCC03	CIT	LFS	HRS
#note - no LFS but LFS03
census_1986<-read_sav("/Users/e5028514/Desktop/census/Census1986_SPSS/SPSS files/PC86PSN.sav")

str(census_1986)
census_1986_set1<-census_1986%>%select(AGE30S,	TYP,	OCC03,	CIT)%>%
  rename(
    "AGEP"="AGE30S",
    "TYPP"= "TYP",
    "OCCP"="OCC03",
    "NATP"="CIT"
  )

census_1986_set2<-census_1986%>%select(AGE30S,	INC13S,	QAL02S,	OCC03,	CIT,
                                       LFS03,	HRS)%>%
  rename(
    "AGEP"="AGE30S",
    "INCP"= "INC13S",
    "OCCP"="OCC03",
    "QLLP"="QAL02S",
    "NATP"="CIT",
    "LFSP"= "LFS03",
    "HRSP"="HRS"
  )

census_1986_set1$year<-"1986"
census_1986_set2$year<-"1986"

#1991.
#note: NO id - assign one?
#AGEP	TYPP	OCCP	NATP
# AGEP	INCP	QLLP	OCCP	NATP	LFSP	HRSP
census_1991<-read_sav("/Users/e5028514/Desktop/census/Census1991_SPSS/SPSS files/hsf91.sav")

str(census_1991)
census_1991_set1<-census_1991%>%select(AGEP,	TYPP,	OCCP,	NATP)
census_1991_set2<-census_1991%>%select(AGEP,	INCP,	QLLP,	OCCP,	NATP,	LFSP,	HRSP)


census_1991_set1$year<-"1991"
census_1991_set2$year<-"1991"

#1996
# 			AGEP,	TYPP,	OCCP,	NATP
# AGEP	INCP	QALLP	OCCP	NATP	LFSP	HRSP
census_1996<-read_sav("/Users/e5028514/Desktop/census/Census1996_SPSS/SPSS files/pc96psn.sav")

str(census_1996)

census_1996_set1<-census_1996%>%select(AGEP,	TYPP,	OCCP,	NATP)
census_1996_set2<-census_1996%>%select(AGEP,	INCP,	QALLP,	OCCP,	NATP,	LFSP,	HRSP)%>%rename(
  "QLLP" ="QALLP"
)

census_1996_set1$year<-"1996"
census_1996_set2$year<-"1996"

#2001
#AGEP	TYPP	OCCP	CITP
#AGEP	INCP	QALLP	OCCP	CITP	LFSP	HRSP
#note: no CITP but CTPP

census_2001<-read_sav("/Users/e5028514/Desktop/census/Census1996_SPSS/SPSS files/pc96psn.sav")

str(census_2001)

census_2001_set1<-census_2001%>%select(AGEP,	TYPP,	OCCP,	CTPP)%>%rename(
  "NATP" ="CTPP"
)
census_2001_set2<-census_2001%>%select(AGEP,	INCP,	QALLP,	OCCP,	CTPP,	LFSP,	HRSP)%>%rename(
  "NATP" ="CTPP",
  "QLLP" ="QALLP"
)


census_2001_set1$year<-"2001"
census_2001_set2$year<-"2001"

#2006
#AGEP	TYPP	OCC06P 	CITP
#AGEP	INCP	QALLP	OCC06P 	CITP	LFSP	HRSP

census_2006<-read_sav("/Users/e5028514/Desktop/census/Census2006_SPSS/SPSS files/CSF06BP.sav")

str(census_2006)

census_2006_set1<-census_2006%>%select(AGEP,	TYPP,	OCC06P,	CTPP)%>%
  rename(
    "OCCP"="OCC06P",
    "NATP" ="CTPP"
  )
census_2006_set2<-census_2006%>%select(AGEP,	INCP,	QALLP,	OCC06P,	CTPP,	LFSP,	HRSP)%>%
  rename(
    "OCCP"="OCC06P",
    "NATP" ="CTPP",
    "QLLP" ="QALLP"
  )

census_2006_set1$year<-"2006"
census_2006_set2$year<-"2006"

#2011
#AGEP	TYPP	OCCP	CITP
#AGEP	INCP	QALLP	OCCP	CITP	LFSP	HRSP
census_2011<-read_sav("/Users/e5028514/Desktop/census/Census2011_SPSS/CSF11BP.sav")

str(census_2011)

census_2011_set1<-census_2011%>%select(AGEP,	TYPP,	OCCP,	CTPP)%>%
  rename(

    "NATP" ="CTPP"
  )
census_2011_set2<-census_2011%>%select(AGEP,	INCP,	QALLP,	OCCP,	CTPP,	LFSP,	HRSP)%>%
  rename(
    "NATP" ="CTPP",
    "QLLP" ="QALLP"
  )

census_2011_set1$year<-"2011"
census_2011_set2$year<-"2011"


#2016
#AGEP	TYPP	OCCP	CITP
#AGEP	INCP	QALLP	OCCP	CITP	LFSP	HRSP

census_2016<-read_sav("/Users/e5028514/Desktop/census/Census2016_SPSS/bcsf16_person_new.sav")

str(census_2016)

census_2016_set1<-census_2016%>%select(AGEP,	TYPP,	OCCP,	CTPP)%>%
  rename(

    "NATP" ="CTPP"
  )
census_2016_set2<-census_2016%>%select(AGEP,	INCP,	QALLP,	OCCP,	CTPP,	LFSP,	HRSP)%>%
  rename(
    "NATP" ="CTPP",
    "QLLP" ="QALLP"
  )

census_2016_set1$year<-"2016"
census_2016_set2$year<-"2016"


census_set1<-rbind(census_1986_set1, census_1991_set1, census_1996_set1, census_2001_set1, census_2006_set1,census_2011_set1, census_2016_set1)
census_set1%>%write_csv("census_set1.csv")

census_set2<-rbind(census_1986_set2, census_1991_set2, census_1996_set2, census_2001_set2, census_2006_set2,census_2011_set2, census_2016_set2)
census_set2%>%write_csv("census_set2.csv")
