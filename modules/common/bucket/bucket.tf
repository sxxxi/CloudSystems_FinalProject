resource "aws_s3_bucket" "media_bucket" {
  bucket = "media-bucket-991617069"
  force_destroy = true
}

## WHY DOES IT NOT WORK!
## Make bucket public
#resource "aws_s3_bucket_public_access_block" "public_access_block" {
#  bucket = aws_s3_bucket.media_bucket.id
#
#  block_public_acls       = true
#  block_public_policy     = true
#  ignore_public_acls      = true
#  restrict_public_buckets = true
#}
#
## Attach policies
#resource "aws_s3_bucket_policy" "read_only_policy" {
#  bucket = aws_s3_bucket.media_bucket.id
#  policy = data.aws_iam_policy_document.read_only_policy.json
#}
#
## Policy
#data "aws_iam_policy_document" "read_only_policy" {
#  statement {
#    principals {
#      type        = "AWS"
#      identifiers = ["*"]
#    }
#    actions = [
#      "s3:GetObject",
#      "s3:ListBucket"
#    ]
#    resources = [
#      aws_s3_bucket.media_bucket.arn,
#      "${aws_s3_bucket.media_bucket.arn}/*"
#    ]
#    effect = "Allow"
#  }
#}