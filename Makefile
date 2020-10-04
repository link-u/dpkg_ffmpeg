.PHONY: help
help:
	@echo make tag
	@echo make release
	@echo make help

.PHONY: tag
tag:
	git tag -d $(shell bash scripts/generate_tag_name_from_ffmpeg.sh) || true
	git tag $(shell bash scripts/generate_tag_name_from_ffmpeg.sh)

.PHONY: release
release:
	$(MAKE) tag
	git push origin :$(shell bash scripts/generate_tag_name_from_ffmpeg.sh) || true
	git push origin $(shell bash scripts/generate_tag_name_from_ffmpeg.sh)
