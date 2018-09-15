all:
	@cat /dev/null > README.md
	@echo "# 橙月笔记" >> README.md
	@echo "" >> README.md
	@echo "---" >> README.md
	@echo "" >> README.md
	@memo-utils-gen-toc memos >> README.md
