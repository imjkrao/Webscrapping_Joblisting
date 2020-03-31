library(rvest)
library(xml2)
page_result_start <- 10 # second page num in url 
page_result_end <- 210 # last page num in url
page_results <- seq(from = page_result_start, to = page_result_end, by = 10)

full_df <- data.frame()
for(i in seq_along(page_results)) {
  #search filtered to ireland, Data analyst and full time as Job type  
  first_page_url <- "https://ie.indeed.com/jobs?q=data+analyst&l=Ireland&rbl=Dublin&jlid=2bb3b9418219c336&jt=fulltime"
  url <- paste0(first_page_url, "&start=", page_results[i])
  page <- xml2::read_html(url)
  Sys.sleep(2)
  
  #get the job title
  job_title <- page %>% 
    rvest::html_nodes("div") %>%
    rvest::html_nodes(xpath = '//*[@data-tn-element = "jobTitle"]') %>%
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
  
  # get links
  links <- page %>% 
    rvest::html_nodes("div") %>%
    rvest::html_nodes(xpath = '//*[@data-tn-element="jobTitle"]') %>%
    rvest::html_attr("href")
  
  job_description <- c()
  for(i in seq_along(links)) {
    
    url <- paste0("https://ie.indeed.com/", links[i])
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

write.csv(full_df, "Indeed_DA_ireland.csv")

