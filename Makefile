all:
	@cat /dev/null > README.md
	@echo "# 橙月笔记" >> README.md
	@echo "" >> README.md
	@tock -x memos >> README.md
