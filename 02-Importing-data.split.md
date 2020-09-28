
# Importing data into R

working with excel, csv, txt, and tsv files in R



```r
library(readr) 
library(data.table)
library(readxl)
library(gdata)
library(httr)
library(rvest)
library(xml2)
library(rlist)
library(jsonlite)
library(dplyr)
```

Importing csv file: 
pools <- read.csv("swimming_pools.csv", stringsAsFactors = FALSE)

With stringsAsFactors, you can tell R whether it should convert strings in the flat file to factors.

Import txt file with read.delim: 
hotdogs <- read.delim("hotdogs.txt", header = FALSE)


Import txt file with read.table: 
hotdogs <- read.table(path, 
                      sep = "\t", 
                      col.names = c("type", "calories", "sodium"))

Import with readr functions: 
- read_csv, read_tsv, and read_delim are part of this package

Can specify column names before import:
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

Import potatoes.txt: 
potatoes <- read_tsv("potatoes.txt", col_names = properties)

Import potatoes.txt using read_delim(): 
potatoes <- read_delim("potatoes.txt", delim = "\t", col_names = properties)


Import 5 observations from potatoes.txt: 
potatoes_fragment <- read_tsv("potatoes.txt", skip = 6, n_max = 5, col_names = properties)

Import all data, but force all columns to be character: potatoes_char
potatoes_char <- read_tsv("potatoes.txt", col_types = "cccccccc", col_names = properties)

Import without col_types
hotdogs <- read_tsv("hotdogs.txt", col_names = c("type", "calories", "sodium"))

The collectors you will need to import the data
fac <- col_factor(levels = c("Beef", "Meat", "Poultry"))
int <- col_integer()

Edit the col_types argument to import the data correctly: 
hotdogs_factor <- read_tsv("hotdogs.txt",
                           col_names = c("type", "calories", "sodium"),
                           col_types = list(fac, int, int))



Import potatoes.csv with fread() from data.table: 
potatoes <- fread("potatoes.csv")

Import columns 6 and 8 of potatoes.csv: 
potatoes <- fread("potatoes.csv", select = c(6, 8))

Plot texture (x) and moistness (y) of potatoes:
plot(potatoes$texture, potatoes$moistness)


Print the names of all worksheets using readxl library:
excel_sheets("urbanpop.xlsx")

Read the sheets, one by one
pop_1 <- read_excel("urbanpop.xlsx", sheet = 1)
pop_2 <- read_excel("urbanpop.xlsx", sheet = 2)
pop_3 <- read_excel("urbanpop.xlsx", sheet = 3)

Put pop_1, pop_2 and pop_3 in a list: 
pop_list <- list(pop_1, pop_2, pop_3)


Read all Excel sheets with lapply(): 
pop_list <- lapply(excel_sheets("urbanpop.xlsx"), read_excel, path = "urbanpop.xlsx")

Import the first Excel sheet of urbanpop_nonames.xlsx (R gives names): 
pop_a <- read_excel("urbanpop_nonames.xlsx", col_names = FALSE)

Import the first Excel sheet of urbanpop_nonames.xlsx (specify col_names): 
cols <- c("country", paste0("year_", 1960:1966))
pop_b <- read_excel("urbanpop_nonames.xlsx", col_names = cols)

Import the second sheet of urbanpop.xlsx, skipping the first 21 rows: 
urbanpop_sel <- read_excel("urbanpop.xlsx", sheet = 2, col_names = FALSE, skip = 21)

Print out the first observation from urbanpop_sel
urbanpop_sel[1,]


Import a local file
Similar to the readxl package, you can import single Excel sheets from Excel sheets to start your analysis in R.

Import the second sheet of urbanpop.xls: 
urban_pop <- read.xls("urbanpop.xls", sheet = "1967-1974")

Print the first 11 observations using head()
head(urban_pop, n = 11)

Column names for urban_pop
columns <- c("country", paste0("year_", 1967:1974))

Finish the read.xls call
urban_pop <- read.xls("urbanpop.xls", sheet = 2,
                      skip = 50, header = FALSE, stringsAsFactors = FALSE,
                      col.names = columns)

Import all sheets from urbanpop.xls
path <- "urbanpop.xls"
urban_sheet1 <- read.xls(path, sheet = 1, stringsAsFactors = FALSE)
urban_sheet2 <- read.xls(path, sheet = 2, stringsAsFactors = FALSE)
urban_sheet3 <- read.xls(path, sheet = 3, stringsAsFactors = FALSE)

Extend the cbind() call to include urban_sheet3: urban_all
urban <- cbind(urban_sheet1, urban_sheet2[-1], urban_sheet3[-1])

Remove all rows with NAs from urban: urban_clean
urban_clean <- na.omit(urban)

Print out a summary of urban_clean
summary(urban_clean)


When working with XLConnect, the first step will be to load a workbook in your R session with loadWorkbook(); this function will build a "bridge" between your Excel file and your R session:
Here using the XLConnect package

Build connection to urbanpop.xlsx: 
my_book <- loadWorkbook("urbanpop.xlsx")

List the sheets in my_book
getSheets(my_book)

Import the second sheet in my_book
readWorksheet(my_book, sheet = 2)


Import columns 3, 4, and 5 from second sheet in my_book: urbanpop_sel
urbanpop_sel <- readWorksheet(my_book, sheet = 2, startCol = 3, endCol = 5)

Import first column from second sheet in my_book: countries
countries <- readWorksheet(my_book, sheet = 2, startCol = 1, endCol = 1)

cbind() urbanpop_sel and countries together: selection
selection <- cbind(countries, urbanpop_sel)

Add a worksheet to my_book, named "data_summary"
createSheet(my_book, "data_summary")

Use getSheets() on my_book
getSheets(my_book)

Create data frame: 
sheets <- getSheets(my_book)[1:3]
dims <- sapply(sheets, function(x) dim(readWorksheet(my_book, sheet = x)), USE.NAMES = FALSE)
summ <- data.frame(sheets = sheets,
                   nrows = dims[1, ],
                   ncols = dims[2, ])

Add data in summ to "data_summary" sheet
writeWorksheet(my_book, summ, "data_summary")

Rename "data_summary" sheet to "summary"
renameSheet(my_book, "data_summary", "summary")

Remove the fourth sheet
removeSheet(my_book, 4)

Save workbook to "renamed.xlsx"
saveWorkbook(my_book, file = "renamed.xlsx")


Download various files with download.file() 
Here are the URLs! As you can see they're just normal strings:


```r
csv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1561/datasets/chickwts.csv"
tsv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_3026/datasets/tsv_data.tsv"

# Read a file in from the CSV URL and assign it to csv_data
csv_data <- read.csv(file = csv_url)

# Read a file in from the TSV URL and assign it to tsv_data
tsv_data <- read.delim(file = tsv_url)

# Examine the objects with head()
head(csv_data, n = 2)
```

```
##   weight      feed
## 1    179 horsebean
## 2    160 horsebean
```

```r
head(tsv_data, n = 2)
```

```
##   weight      feed
## 1    179 horsebean
## 2    160 horsebean
```

Download the file with download.file()

```r
download.file(url = csv_url, destfile = "feed_data.csv")

# Read it in with read.csv()
csv_data <- read.csv(file = "feed_data.csv")


# Add a new column: square_weight
csv_data$square_weight <- (csv_data$weight ^ 2)
```
Save it to disk with saveRDS()
saveRDS(object = csv_data, file = "modified_feed_data.RDS")

Read it back in with readRDS()
modified_feed_data <- readRDS(file = "modified_feed_data.RDS")


Using data from API clients 

example 1
Load pageviews library for wikipedia

```r
library(pageviews)

# Get the pageviews for "Hadley Wickham"
hadley_pageviews <- article_pageviews(project = "en.wikipedia", article = "Hadley Wickham")

# Examine the resulting object
str(hadley_pageviews)
```

```
## 'data.frame':	1 obs. of  8 variables:
##  $ project    : chr "wikipedia"
##  $ language   : chr "en"
##  $ article    : chr "Hadley_Wickham"
##  $ access     : chr "all-access"
##  $ agent      : chr "all-agents"
##  $ granularity: chr "daily"
##  $ date       : POSIXct, format: "2015-10-01"
##  $ views      : num 53
```


Load the httr package:

```r
library(httr)

# Make a GET request to http://httpbin.org/get
get_result <- GET(url = "http://httpbin.org/get")

# Print it to inspect it
get_result
```

```
## Response [http://httpbin.org/get]
##   Date: 2020-09-28 03:14
##   Status: 200
##   Content-Type: application/json
##   Size: 365 B
## {
##   "args": {}, 
##   "headers": {
##     "Accept": "application/json, text/xml, application/xml, */*", 
##     "Accept-Encoding": "deflate, gzip", 
##     "Host": "httpbin.org", 
##     "User-Agent": "libcurl/7.54.0 r-curl/4.3 httr/1.4.2", 
##     "X-Amzn-Trace-Id": "Root=1-5f715508-67454af2eaac626ad9a751a8"
##   }, 
##   "origin": "99.229.26.120", 
## ...
```


Make a POST request to http://httpbin.org/post with the body "this is a test"


```r
post_result <- POST(url = "http://httpbin.org/post", body = "this is a test")

# Print it to inspect it
post_result
```

```
## Response [http://httpbin.org/post]
##   Date: 2020-09-28 03:14
##   Status: 200
##   Content-Type: application/json
##   Size: 472 B
## {
##   "args": {}, 
##   "data": "this is a test", 
##   "files": {}, 
##   "form": {}, 
##   "headers": {
##     "Accept": "application/json, text/xml, application/xml, */*", 
##     "Accept-Encoding": "deflate, gzip", 
##     "Content-Length": "14", 
##     "Host": "httpbin.org", 
## ...
```

Make a GET request to url and save the results:
Handling http failures


```r
fake_url <- "http://google.com/fakepagethatdoesnotexist"

# Make the GET request
request_result <- GET(fake_url)
```


Example start to finish using httr package: The API url

```r
base_url <- "https://en.wikipedia.org/w/api.php"

# Set query parameters
query_params <- list(action = "parse", 
                     page = "Hadley Wickham", 
                     format = "xml")
```

Read page contents as HTML: library(rvest)
# Extract page name element from infobox: library(xml2)
Create a dataframe for full name
Reproducibility


```r
get_infobox <- function(title){
  base_url <- "https://en.wikipedia.org/w/api.php"
  
# Change "Hadley Wickham" to title

query_params <- list(action = "parse", 
                       page = title, 
                       format = "xml")}
  
resp <- GET(url = base_url, query = query_params)
resp_xml <- content(resp)
  
page_html <- read_html(xml_text(resp_xml))
infobox_element <- html_node(x = page_html, css =".infobox")
page_name <- html_node(x = infobox_element, css = ".fn")
```


Construct a directory-based API URL to `http://swapi.co/api`,
looking for person `1` in `people`:

```r
directory_url <- paste("http://swapi.co/api", "people", "1", sep = "/")

# Make a GET call with it
result <- GET(directory_url)

# Create list with nationality and country elements
query_params <- list(nationality = "americans", 
                     country = "antigua")

# Make parameter-based call to httpbin, with query_params
parameter_response <- GET("https://httpbin.org/get", query = query_params)

# Print parameter_response
parameter_response
```

```
## Response [https://httpbin.org/get?nationality=americans&country=antigua]
##   Date: 2020-09-28 03:14
##   Status: 200
##   Content-Type: application/json
##   Size: 465 B
## {
##   "args": {
##     "country": "antigua", 
##     "nationality": "americans"
##   }, 
##   "headers": {
##     "Accept": "application/json, text/xml, application/xml, */*", 
##     "Accept-Encoding": "deflate, gzip", 
##     "Host": "httpbin.org", 
##     "User-Agent": "libcurl/7.54.0 r-curl/4.3 httr/1.4.2", 
## ...
```

Using user agents
Informative user-agents are a good way of being respectful of the developers running the API you're interacting with. They make it easy for them to contact you in the event something goes wrong. I always try to include:
My email address; A URL for the project the code is a part of, if it's got a URL.

Do not change the url:

```r
url <- "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Aaron_Halfaker/daily/2015100100/2015103100"
```

Add the email address and the test sentence inside user_agent()
server_response <- GET(url, user_agent("my@email.address this is a test"))

Rate-limiting
The next stage of respectful API usage is rate-limiting: making sure you only make a certain number of requests to the server in a given time period. 
Your limit will vary from server to server, but the implementation is always pretty much the same and involves a call to Sys.sleep(). 
This function takes one argument, a number, which represents the number of seconds to "sleep" (pause) the R session for. 
So if you call Sys.sleep(15), it'll pause for 15 seconds before allowing further code to run.

Construct a vector of 2 URLs:
for(url in urls){
  Send a GET request to url
  result <- GET(url)
  Delay for 5 seconds between requests
  Sys.sleep(5)
}

```r
urls <- c("http://httpbin.org/status/404",
          "http://httpbin.org/status/301")
```

Tying it all together:

```r
get_pageviews <- function(article_title){
  url <- paste(
    "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents", 
    article_title, 
    "daily/2015100100/2015103100", 
    sep = "/"
  )   

response <- GET(url, user_agent("my@email.com this is a test")) 
  # Is there an HTTP error?
  if(http_error(response)){ 
    # Throw an R error
    stop("the request failed") 
  }
  # Return the response's content
  content(response)
}
```
working with JSON files (for more information see: www.json.org)
While JSON is a useful format for sharing data, your first step will often be to parse it into an R object, so you can manipulate it with R.

web scraping 101
The first step with web scraping is actually reading the HTML in. 
This can be done with a function from xml2, which is imported by rvest - read_html(). 
This accepts a single URL, and returns a big blob of XML that we can use further on.

  
Hadley Wickham's Wikipedia page:


```r
test_url <- "https://en.wikipedia.org/wiki/Hadley_Wickham"
  
# Read the URL stored as "test_url" with read_html()
test_xml <- read_html(test_url)
  
# Print test_xml
test_xml
```

```
## {html_document}
## <html class="client-nojs" lang="en" dir="ltr">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="mediawiki ltr sitedir-ltr mw-hide-empty-elt ns-0 ns-subject  ...
```

html_node(), which extracts individual chunks of HTML from a HTML document. 
There are a couple of ways of identifying and filtering nodes, and for now we're going to use XPATHs: 
unique identifiers for individual pieces of a HTML document.

Extract the element of table_element referred to by second_xpath_val and store it as page_name
page_name <- html_node(x = table_element, xpath = second_xpath_val)

Extract the text from page_name:


```r
page_title <- html_text(page_name)

# Print page_title
page_title
```

```
## [1] "Hadley Wickham"
```

```r
# Turn table_element into a data frame and assign it to wiki_table
# wiki_table <- rvest::html_table(table_element)

# Print wiki_table
# wiki_table
```

Cleaning a data frame
Rename the columns of wiki_table:

CSS web scraping 
CSS is a way to add design information to HTML, that instructs the browser on how to display the content. You can leverage these design instructions to identify content on the page.


<!--chapter:end:02-Importing-data.Rmd-->
