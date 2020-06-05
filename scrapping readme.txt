For IRISHJOB.IE
================
Job title in main page --->div[@class = "job-result-title"]/h2/a
Company name in main page ---> div[@class = "job-result-title"]/h3/a
salary in main page ---> div[@class="job-result-overview"]/ul/li[@class="salary"]
location in main page ---> div[@class="job-result-overview"]/ul/li[@class="location"]/a


For seen by indeed
=================

Job title in main page --->div[@class ="role serif-title"]/a
company_name in main page ---> div[@class ="company"]
job_location in main page ---> div[@class="location"]/a
Job_Role in main page --->  span[@class="font-weight-bold"]/a
job_updation in internal ---> span[@itemprop="datePosted"] 
job_skills in internal--->  div[@class="required-skill"]/ul/li/a


 df <- data.frame(job_title, company_name, job_location, Job_Role, job_description,job_skills,job_updation)
 /html/body/section[1]/div/section[2]/section[2]/div/div/div[1]/div/div[2]/div/ul/li[32]/a
 html.no-js body#body section#job-page div.pb-5 section#job section#com-summary-section div.container.mt-5 div.row div.col-12.col-lg-8 div.rounded-box.p-4.job-details-desc div.required-skill-sec div.required-skill ul.pl-0 li a
 /html/body/section[1]/div/section[2]/section[2]/div/div/div[1]/div/div[2]/div/ul/li[1]/a