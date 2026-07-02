-- Databricks notebook source
-- Cell 1: Creating the Gold Web Funnel Analytics Table
CREATE OR REPLACE TABLE workspace.default.gold_funnel_analysis AS
WITH user_stages AS (
  SELECT 
    user_id,
    MAX(CASE WHEN event_name = 'Quote_Requested' THEN 1 ELSE 0 END) as hit_quote,
    MAX(CASE WHEN event_name = 'Document_Uploaded' THEN 1 ELSE 0 END) as hit_document,
    MAX(CASE WHEN event_name = 'Application_Submitted' THEN 1 ELSE 0 END) as hit_submit,
    MAX(CASE WHEN event_name = 'Dropped' THEN 1 ELSE 0 END) as hit_drop
  FROM workspace.default.silver_web_events
  GROUP BY user_id
)
SELECT 
  p.region,
  p.policy_type,
  COUNT(DISTINCT s.user_id) as total_users_started,
  SUM(s.hit_quote) as total_quotes_generated,
  SUM(s.hit_document) as total_documents_uploaded,
  SUM(s.hit_submit) as total_applications_completed,
  SUM(s.hit_drop) as total_users_dropped,
  -- Calculate structural conversion percentage safely
  ROUND((SUM(s.hit_submit) / COUNT(DISTINCT s.user_id)) * 100, 2) as overall_conversion_rate
FROM user_stages s
JOIN workspace.default.silver_insurance_policies p 
  ON s.user_id = p.user_id
GROUP BY p.region, p.policy_type;

-- Preview the results
SELECT * FROM workspace.default.gold_funnel_analysis 
ORDER BY region, policy_type;

-- COMMAND ----------

-- Cell 2: Creating the Gold Financial Performance Table
CREATE OR REPLACE TABLE workspace.default.gold_financial_summary AS
SELECT 
  p.region,
  p.policy_type,
  COUNT(DISTINCT p.policy_id) as active_policies_count,
  ROUND(SUM(p.premium_amount), 2) as total_premiums_collected,
  COUNT(DISTINCT c.claim_id) as total_claims_filed,
  ROUND(COALESCE(SUM(c.claim_amount), 0), 2) as total_claims_paid,
  -- Loss Ratio = (Total Claims Paid / Total Premiums Collected) * 100
  ROUND((COALESCE(SUM(c.claim_amount), 0) / SUM(p.premium_amount)) * 100, 2) as loss_ratio_percentage
FROM workspace.default.silver_insurance_policies p
LEFT JOIN workspace.default.silver_insurance_claims c 
  ON p.policy_id = c.policy_id
GROUP BY p.region, p.policy_type;

-- Preview the results
SELECT * FROM workspace.default.gold_financial_summary 
ORDER BY loss_ratio_percentage DESC;