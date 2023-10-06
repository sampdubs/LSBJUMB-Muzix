# importing required modules
import PyPDF2
import re
from tqdm import tqdm


# creating a pdf file object
pdfFileObj = open('TUBA muzix.pdf', 'rb')
 
# creating a pdf reader object
pdfReader = PyPDF2.PdfReader(pdfFileObj)
 
# get text from page 1
tableOfContents = pdfReader.pages[0].extract_text()

# extract song names and page numbers from table of contents
pattern = re.compile(r"(\d+):\s+(.+?)\s*(?=\d+:|\n|\Z)")

matches = re.findall(pattern, tableOfContents)
matches = [(int(page), title) for page, title in matches]
matches.sort()

for page, title in tqdm(matches[:-1]):
    # Extract appropriate page and make a new pdf with just that song
    pdfWriter = PyPDF2.PdfWriter()
    pageObj = pdfReader.pages[page + 1]

    pdfWriter.add_page(pageObj)
    newFile = open(f"../Songz/{title}.pdf", 'wb')

    pdfWriter.write(newFile)
    newFile.close()

# Handle special case of teazers
startPage, title = matches[-1]
pdfWriter = PyPDF2.PdfWriter()

for page in range(startPage + 1, startPage + 6):
    pageObj = pdfReader.pages[page]
    pdfWriter.add_page(pageObj)

newFile = open(f"../Songz/Teazers.pdf", 'wb')

pdfWriter.write(newFile)
newFile.close()

# closing the pdf file object
pdfFileObj.close()