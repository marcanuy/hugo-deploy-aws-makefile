SHELL := /bin/bash
AWS := aws
HUGO := hugo
PUBLIC_FOLDER := public
HTMLPROOF :=  htmlproofer
S3_BUCKET = s3://example.com/
CLOUDFRONT_ID := ABCD12345678
DOMAIN = example.com
SITEMAP_URL = https://example.com/sitemap.xml

DEPLOY_LOG := deploy.log

.ONESHELL:

.PHONY: all clean install update

all : serve

check:
	$(HUGO) check
	$(HUGO) --i18n-warnings
	$(HTMLPROOF) --check-html \
		--http-status-ignore 999 \
		--internal-domains $(DOMAIN),localhost:1313 \
		--disable-external \
		--assume-extension \
		$(PUBLIC_FOLDER)

benchmarking:
	$(HUGO) --stepAnalysis --templateMetrics --templateMetricsHints

build: clean 
	$(HUGO)

build-production: clean
	HUGO_ENV=production $(HUGO)

serve: clean
	$(HUGO) serve

serve-production: clean
	HUGO_ENV=production $(HUGO) serve

update-themes:
	git submodule update --remote --merge
# 	git submodule foreach git pull origin master

deploy: build-production check
	echo "Copying files to server..."

	$(AWS) s3 sync public/ $(S3_BUCKET) --size-only --delete | tee -a $(DEPLOY_LOG)
	# filter files to process

	# in bash: sed -e "s|^.*to ${S3_BUCKET}||p" salida | sed -e 's/index.html//'
	grep "upload\|delete" $(TEMPFILE) | sed -e "s|.*upload.*to $(S3_BUCKET)|/|" | sed -e "s|.*delete: $(S3_BUCKET)|/|" | sed -e 's/index.html//' | sed -e 's/\(.*\).html/\1/' | tr '\n' ' ' | xargs aws cloudfront create-invalidation --distribution-id $(CLOUDFRONT_ID) --paths
	curl --silent "http://www.google.com/ping?sitemap=$(SITEMAP_URL)"
	curl --silent "http://www.bing.com/webmaster/ping.aspx?siteMap=$(SITEMAP_URL)"

aws-cloudfront-invalidate-all:
	$(AWS) cloudfront create-invalidation --distribution-id $(CLOUDFRONT_ID) --paths "/*"

clean :
	find . -name "*~" -exec rm {} -v \;
	find . -name "*#" -exec rm {} -v \;
	hugo --gc
	rm -vfr public

