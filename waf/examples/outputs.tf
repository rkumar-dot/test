output "rule_group_id" {
  description = "AWS WAF Rule Group which contains all rules for OWASP Top 10 protection."
  value       = "${module.owasp_top_10.rule_group_id}"
}

output "rule01_sql_injection_rule_id" {
  description = "AWS WAF Rule which mitigates SQL Injection Attacks."
  value       = "${module.owasp_top_10.rule01_sql_injection_rule_id}"
}
