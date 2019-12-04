terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}

  # The latest version of Terragrunt (v0.19.0 and above) requires Terraform 0.12.0 or above.
  required_version = ">= 0.12.0"
}


# Random ID Generator

resource "random_id" "this" {
  count = "${lower(var.target_scope) == "regional" || lower(var.target_scope) == "global" ? "1" : "0"}"

  byte_length = "8"

  keepers = {
    target_scope = "${lower(var.target_scope)}"
  }
}

resource "aws_wafregional_size_constraint_set" "owasp_07_size_restriction_set" {
  count = "${lower(var.target_scope) == "regional" ? "1" : "0"}"

  name = "${lower(var.service_name)}-owasp-07-size-restrictions-${random_id.this.hex}"

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "${var.max_expected_uri_size}"

    field_to_match {
      type = "URI"
    }
  }

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "${var.max_expected_query_string_size}"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "${var.max_expected_body_size}"

    field_to_match {
      type = "BODY"
    }
  }

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "${var.max_expected_cookie_size}"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }
}

resource "aws_wafregional_rule" "owasp_07_size_restriction_rule" {
  depends_on = ["aws_wafregional_size_constraint_set.owasp_07_size_restriction_set"]

  count = "${lower(var.target_scope) == "regional" ? "1" : "0"}"

  name        = "${lower(var.service_name)}-owasp-07-restrict-sizes-${random_id.this.hex}"
  metric_name = "${lower(var.service_name)}OWASP07RestrictSizes${random_id.this.hex}"

  predicate {
    data_id = "${aws_wafregional_size_constraint_set.owasp_07_size_restriction_set.id}"
    negated = "false"
    type    = "SizeConstraint"
  }
}
