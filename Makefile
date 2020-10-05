TAG=$(shell bash scripts/generate_tag_name_from_ffmpeg.sh)
.PHONY: help
help:
	@echo make tag
	@echo make release
	@echo make help

.PHONY: tag
tag:
	git tag -d $(TAG) 2> /dev/null || true
	git tag $(TAG)

.PHONY: release
release:
	$(MAKE) tag
	git push origin :$(TAG) 2> /dev/null || true
	git push origin $(TAG)
