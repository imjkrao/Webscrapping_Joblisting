library(rvest)
library(xml2)
library(Stack)
page_result_start <-10 # second page num in url 
page_result_end <- 50 # last page num in url
page_results <- seq(from = page_result_start, to = page_result_end, by = 1)

full_df <- data.frame()
for(i in seq_along(page_results)) {
  df<- data.frame()
  df1<- data.frame()
  df2<- data.frame()
  first_page_url <- "https://www.beseen.com/tech-jobs/"
  url <- paste0(first_page_url, "index-", page_results[i],".html")
  page <- xml2::read_html(url)
  Sys.sleep(2)
  print(page_results[i])
  #get the job title
  job_title <- page %>% 
    rvest::html_nodes("div") %>%
    rvest::html_nodes(xpath = '//*[@class = "role serif-title"]/a') %>%
    rvest::html_text(trim = TRUE)
  #rvest::html_attr("title")
  
  
  
  #get the company name
  company_name <- page %>% 
    rvest::html_nodes("div")  %>% 
    rvest::html_nodes(xpath = '//*[@class="company"]')  %>% 
    rvest::html_text() %>%
    stringi::stri_trim_both() -> company.name 
  
  #get the salary
  # Salary <- page %>% 
  #   rvest::html_nodes("div")  %>% 
  #   rvest::html_nodes(xpath = '//*[@class="job-result-overview"]/ul/li[@class="salary"]')  %>% 
  #   rvest::html_text() %>%
  #   stringi::stri_trim_both() -> salary.job 
  
  #get job location
  # job_location <- page %>% 
  #   rvest::html_nodes("div") %>% 
  #   rvest::html_nodes(xpath = '//*[@class="location"]/a')%>% 
  #   rvest::html_text() %>%
  #   stringi::stri_trim_both()
  
  #get job role
  job_role <- page %>% 
    rvest::html_nodes("div") %>% 
    rvest::html_nodes(xpath = '//*[@class="col-12 text-left"]/p/a')%>% 
    rvest::html_text() %>%
    stringi::stri_trim_both()
  
  # get links
  links <- page %>% 
    rvest::html_nodes("div") %>%
    rvest::html_nodes(xpath = '//*[@class = "role serif-title"]/a') %>%
    rvest::html_attr("href") %>%
    stringi::stri_trim_left(pattern = "\\p{L}")
  
  
  
  job_description <- c()
  job_updation <- c()
  job_skills <- c()
  for(j in seq_along(links)) {
    
    url1 <- paste0("https://www.beseen.com/tech-jobs/", links[j])
    page1 <- xml2::read_html(url1)
    
    #get job description
    job_description[[j]] <- page1 %>%
      rvest::html_nodes("div")  %>% 
      rvest::html_nodes(xpath = '//*[@class="text-wrap"]') %>% 
      rvest::html_text() %>%
      stringi::stri_trim_both()
    
   #get job update date
    job_updation[[j]] <- page1 %>%
      rvest::html_nodes("span") %>%
      rvest::html_nodes(xpath = '//*[@itemprop="datePosted"]')%>%
      rvest::html_text() %>%
      stringi::stri_trim_both()
    
    #get job skills
    job_skills[[j]] <- page1 %>%
      rvest::html_nodes("div") %>%
      rvest::html_nodes(xpath = '//*[@class="required-skill"]/ul/li/a')%>%
      rvest::html_text() %>%
      stringi::stri_trim_both()
      
    
  }
  df <-data.frame(job_title, company_name, job_role, job_description,job_updation,as.character.default(job_skills))
   # #df1<- as.data.frame(do.call(rbind,job_skills))
   # jobskills<-  as.character.default(job_skills)
   # print("done1")
   # #df2 <- cbind(df,df1) 
  full_df <- rbind(full_df,df)
   # print("done2")
}
write.csv(full_df, "seenJobs_new10_.csv")
  
  