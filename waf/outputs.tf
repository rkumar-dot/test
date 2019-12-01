output "rule_group_id" {
  description = "AWS WAF Rule Group which contains all rules for OWASP Top 10 protection."
  value       = "${lower(var.target_scope) == "regional" ? element(concat(aws_wafregional_rule_group.owasp_top_10.*.id, list("NOT_CREATED")), "0") : element(concat(aws_waf_rule_group.owasp_top_10.*.id, list("NOT_CREATED")), "0")}"
}

output "rule01_sql_injection_rule_id" {
  description = "AWS WAF Rule which mitigates SQL Injection Attacks."
  value       = "${lower(var.target_scope) == "regional" ? element(concat(aws_wafregional_rule.owasp_01_sql_injection_rule.*.id, list("NOT_CREATED")), "0") : element(concat(aws_waf_rule.owasp_01_sql_injection_rule.*.id, list("NOT_CREATED")), "0")}"
}
