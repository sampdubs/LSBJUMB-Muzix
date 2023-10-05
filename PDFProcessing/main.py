# importing required modules
import PyPDF2
import re
 
# creating a pdf file object
pdfFileObj = open('TUBA muzix.pdf', 'rb')
 
# creating a pdf reader object
pdfReader = PyPDF2.PdfReader(pdfFileObj)
 
# get text from page 1
tableOfContents = pdfReader.pages[0].extract_text()

# print(tableOfContents)

pattern = re.compile(r"\d+:\s+(.+?)(?=\s+\d+:|\n)")

match = re.findall(pattern, tableOfContents)
print(match)
print(len(match))

# closing the pdf file object
pdfFileObj.close()