resource "aws_s3_bucket" "vmimport" {
  bucket = "mikesac-vmimport"
  acl    = "private"

  tags = {
    Name        = "Vm import Bucket"
    project = "vm_import"
  }
}

resource "aws_iam_role" "vmimport_role" {
  name = "vmimport"
  assume_role_policy = file("trust-policy.json")

  inline_policy {
    name = "vmimport"
    policy = file("role-policy.json")
  }

  tags = {
    project = "vm_import"
  }
}
