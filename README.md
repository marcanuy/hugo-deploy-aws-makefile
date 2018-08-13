# hugo-deploy-aws-makefile
Make script as a build automation tool for deploying Hugo websites to AWS

If not done yet, here is a guide to serve a Hugo website with Amazon Web Services: https://simpleit.rocks/golang/hugo/deploying-a-hugo-website-to-aws-the-right-way/

# Requisites

This
[Makefile](https://www.gnu.org/software/make/manual/make.html#Introduction)
uses the following programs in addition to `hugo`:

- [htmlproofer](https://github.com/gjtorikian/html-proofer#installation): "Test
  your rendered HTML files to make sure they're accurate."

- [AWS Command Line
  Interface](https://docs.aws.amazon.com/cli/latest/userguide/installing.html):
  "The AWS CLI is an open source tool built on top of the AWS SDK for
  Python (Boto) that provides commands for interacting with AWS
  services"

# Run

Run each recipe with `make`.

# License

This theme is released under the MIT License. For more information
read the
[License](//github.com/marcanuy/hugo-deploy-aws-makefile/blob/master/LICENSE).
