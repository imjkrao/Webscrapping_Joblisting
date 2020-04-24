library(rvest)
library(xml2)
page_result_start <-2 # second page num in url 
page_result_end <- 12 # last page num in url
page_results <- seq(from = page_result_start, to = page_result_end, by = 1)


full_df <- data.frame()
for(i in seq_along(page_results)) {
  #search filtered to ireland, Data analyst and full time as Job type  
  first_page_url <- "https://www.irishjobs.ie/ShowResults.aspx?Keywords=&autosuggestEndpoint=%2fautosuggest&Location=0&Category=3&Recruiter=Company%2cAgency&btnSubmit=+&PerPage=100"
  url <- paste0(first_page_url, "&Page=", page_results[i])
  page <- xml2::read_html(first_page_url)
  Sys.sleep(2)
  
  #get the job title
  job_title <- page %>% 
    rvest::html_nodes("div") %>%
    rvest::html_nodes(xpath = '//*[@class = "job-result-title"]/h2/a') %>%
    rvest::html_text(trim = TRUE)
    #rvest::html_attr("title")
    
    
  
  #get the company name
  company_name <- page %>% 
    rvest::html_nodes("div")  %>% 
    rvest::html_nodes(xpath = '//*[@class="job-result-title"]/h3/a')  %>% 
    rvest::html_text() %>%
    stringi::stri_trim_both() -> company.name 
  
  #get the salary
  Salary <- page %>% 
    rvest::html_nodes("div")  %>% 
    rvest::html_nodes(xpath = '//*[@class="job-result-overview"]/ul/li[@class="salary"]')  %>% 
    rvest::html_text() %>%
    stringi::stri_trim_both() -> salary.job 
  
  #get job location
  job_location <- page %>% 
    rvest::html_nodes("div") %>% 
    rvest::html_nodes(xpath = '//*[@class="job-result-overview"]/ul/li[@class="location"]/a')%>% 
    rvest::html_text() %>%
    stringi::stri_trim_both()
  
  #get job update date
  job_updation <- page %>% 
    rvest::html_nodes("div") %>% 
    rvest::html_nodes(xpath = '//*[@class="job-result-overview"]/ul/li[@class="updated-time"]')%>% 
    rvest::html_text() %>%
    stringi::stri_trim_both()
  
  # get links
  links <- page %>% 
    rvest::html_nodes("div") %>%
    rvest::html_nodes(xpath = '//*[@class = "job-result-title"]/h2/a') %>%
    rvest::html_attr("href")
  
  job_description <- c()
  for(i in seq_along(links)) {
    
    url <- paste0("https://www.irishjobs.ie", links[i])
    page <- xml2::read_html(url)
    
    job_description[[i]] <- page %>%
      rvest::html_nodes("div")  %>% 
      rvest::html_nodes(xpath = '//*[@class="jobsearch-jobDescriptionText"]') %>% 
      rvest::html_text() %>%
      stringi::stri_trim_both()
  }
  df <- data.frame(job_title, company_name, job_location, job_description)
  full_df <- rbind(full_df, df)
}

write.csv(full_df, "irishjobs_ireland.csv")

