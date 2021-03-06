from Orange.data import *
from lxml import etree # read from xml
import os
import pandas as pd

directory_in_str='/Users/ibrahim/Desktop/AIS/S2/Data Exploration and Preparation Core/XML/ml/metadata'
directory = os.fsencode(directory_in_str)
to_export=[]
for file in os.listdir(directory):
     filename = os.fsdecode(file)
     if filename.endswith(".xml"):
         recovering_parser = etree.XMLParser(recover=True)
         file_to_parse=directory_in_str+'/'+filename
         tree= etree.parse(file_to_parse,parser=recovering_parser)
         root = tree.getroot()
         elems = root.ﬁndall('./front/article-meta/pub-date')
         root = tree.getroot()
         titles = root.ﬁndall('./front/article-meta/title-group')

         for elem in elems:
             row=[]
             row.append(elem.ﬁnd("./month").text)
             row.append(elem.ﬁnd("./year").text)
             title_text=' '.join(str(titles[0].ﬁnd("./article-title").text).split())
             if len(title_text)==0 or title_text=="None":
                 title_text="Unknown"
             row.append(title_text)
             row.append("ML")

         to_export.append(row)
         to_export=sorted(to_export,key=lambda x: x[2])
         continue 

month = ContinuousVariable('Month')
year = ContinuousVariable('Year')
title = StringVariable('Title')
topic = StringVariable('Topic')

domain=Domain([month,year], metas=[title,topic])
table = Table.from_list(domain, to_export)
out_data=table
