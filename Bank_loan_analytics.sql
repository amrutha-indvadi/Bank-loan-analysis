#------------------------------------BANK LOAN ANALYTICS--------------------------#

/* --------------------- KPI'S ------------------------------------------------
1. Year wise loan amount Stats
2. Grade and sub grade wise revol_bal
3. Total Payment for Verified Status Vs Total Payment for Non Verified Status
4. State wise and last_credit_pull_d wise loan status/state and month wise loan status
5. Home ownership Vs last payment date stats
*/
create database PJE_BANK;
USE PJE_BANK;
SELECT *FROM fin1;
SELECT COUNT(*) FROM FIN1;
SELECT *FROM FIN2;
SELECT COUNT(*) FROM FIN2;
describe fin1;
DESCRIBE fin2;

# KPI 1 -->Year wise loan amount Stats
select year(issue_d) as issue_year ,concat(round(sum(loan_amnt)/1000000,2), "M") as Total_Loan_Amount from fin1
group by issue_year
order by issue_year;

#-----------------------------------------------------------------------------------------------------
# KPI 2 -->Grade and sub grade wise revol_bal
select grade,sub_grade ,concat(round(sum(revol_bal)/1000000,2),"M") as "Total Revol balance" from fin1
inner join fin2
on fin1.id=fin2.id
group by grade,sub_grade
order by grade,sub_grade;
#-----------------------------------------------------------------------------------------------------

#KPI 3-->Total Payment for Verified Status Vs Total Payment for Non Verified Status
select verification_status,concat(round(sum(total_pymnt)/1000000,2),"M") as "Total Payment" from fin1
inner join fin2 on
fin1.id=fin2.id
where verification_status in("verified","Not verified") 
group by verification_status
order by verification_status;
#-----------------------------------------------------------------------------------------------------

#KPI 4-->State wise and last_credit_pull_d wise loan status
SELECT addr_state AS STATE,last_credit_pull_d,
COUNT(CASE WHEN loan_status = 'charged off' THEN 1 END) AS charged_off,
       COUNT(CASE WHEN loan_status = 'fully paid' THEN 1 END) AS fully_paid,
       COUNT(CASE WHEN loan_status = 'current' THEN 1 END) AS 'CURRENTLY'
FROM fin1
INNER JOIN fin2 ON fin1.id = fin2.id
GROUP BY state, last_credit_pull_d,loan_status
ORDER BY state, last_credit_pull_d,loan_status;

#KPI 4-->state and month wise loan status
SELECT addr_state AS state,
       MONTHNAME(issue_d) AS month,
       COUNT(CASE WHEN loan_status = 'charged off' THEN 1 END) AS charged_off,
       COUNT(CASE WHEN loan_status = 'fully paid' THEN 1 END) AS fully_paid,
       COUNT(CASE WHEN loan_status = 'current' THEN 1 END) AS 'CURRENT'
FROM fin1
INNER JOIN fin2 ON fin1.id = fin2.id
GROUP BY state, month
ORDER BY state, month;
#-----------------------------------------------------------------------------------------------------

#kPI 5-->Home ownership Vs last payment date stats

select  year(last_pymnt_d) as Last_Payment_year,home_ownership,concat(round((sum(last_pymnt_amnt)/1000000),2),"M") as Last_Payment_Amt
from fin1 inner join fin2 on 
fin1.id=fin2.id
where year(last_pymnt_d) IS NOT NULL
group by Last_Payment_year,home_ownership
having Last_Payment_year IS NOT NULL
Order by Last_Payment_year;


#--------------------------------------------------end-------------------------------------------------------------------#