library(rvest)
library(xml2)
page_result_start <- 2 # second page num in url 
page_result_end <- 15 # last page num in url
page_results <- seq(from = page_result_start, to = page_result_end, by = 1)

full_df <- data.frame()
for(i in seq_along(page_results)) {
first_page_url <- "https://www.jobs.ie/Jobs.aspx"
?Page=3
page <- xml2::read_html(first_page_url)

#get the job title
job_title <- page %>% 
  rvest::html_nodes("div") %>%
  rvest::html_nodes(xpath = '//*[@class = "serp-title"]/a') %>%
  rvest::html_attr("title")

#get the company name
company_name <- page %>% 
  rvest::html_nodes("span")  %>% 
  rvest::html_nodes(xpath = '//*[@class="company"]')  %>% 
  rvest::html_text() %>%
  stringi::stri_trim_both() -> company.name 


#get job location
job_location <- page %>% 
  rvest::html_nodes("div") %>% 
  rvest::html_nodes(xpath = '//*[@class="location accessible-contrast-color-location"]')%>% 
  rvest::html_text() %>%
  stringi::stri_trim_both()


