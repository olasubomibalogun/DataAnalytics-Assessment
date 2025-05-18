# DataAnalytics-Assessment
**Assessment_Q1.sql**

--I began with the users_customuser table to get all the customer records.

--Then I joined the plans_plan table so I could check what kind of plans each customer has—whether it’s a savings or investment plan.

--I used CASE WHEN logic to count only the savings and investment plans that had some money (i.e., amount > 0). That way, I ignored any empty plans.

--I added a subquery to sum up each customer’s confirmed transactions from the savings account table (savings_savingsaccount) and joined it back to the main query.

--Using HAVING, I made sure to only keep customers who had at least one funded savings plan and one funded investment plan.

--Finally, I sorted the result by total_deposits in descending order so that the highest depositors show up first.


**Assessment_Q2.sql**

--I pulled data from the savings_savingsaccount table and grouped it by each customer using their owner_id.

--For each customer, I counted how many transactions they made in total, and also how many unique months they were active in. I used DATE_FORMAT to get the YYYY-MM format and counted those.

--Then I just divided the total transactions by the number of active months to get how often they transact on average. I used ROUND to keep it clean, and NULLIF just in case someone had 0 active months (to avoid crashing the query).

--Based on their average, I used a CASE statement to assign them a label: High, Medium, or Low Frequency.

--In the outer query, I grouped all customers by their frequency category and counted how many people fell into each. I also got the average transaction rate per group just to see the overall trend.

**Assessment_Q3.sql**

--I took data from the plans_plan table, which contains all savings and investment plans. I filtered out the ones marked as deleted with p.is_deleted = 0.

--Then I joined this with the savings_savingsaccount table using the plan ID to find transactions linked to each plan.

--I used MAX(transaction_date) to find the most recent transaction for each plan.

--Using a simple CASE statement, I labeled each plan as either "Savings" or "Investment" based on its flags (is_regular_savings or is_a_fund).

--After the inner query gave me each plan’s last transaction date, I wrapped it and used DATEDIFF to figure out how many days have passed since the last transaction.

--Finally, I just filtered for plans that haven’t seen any action in more than 365 days (i.e., inactive for over a year) and made sure the type wasn't null (meaning it's either a savings or investment plan).


**Assessment_Q4.sql**
--I joined the users with their savings transactions.

--For each user, I calculated how long they've been signed up in months.

--Then, I calculated how many total transactions they've made.

--To estimate CLV, I used the formula (transactions/month) * 12 * 0.001 — which assumes a tiny profit per transaction.

--Finally, I sorted by the estimated CLV from highest to lowest to see the most "valuable" customers.
