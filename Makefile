all: cat
	@cat /dev/null > README.md
	@echo "# 橙月笔记" >> README.md
	@echo "" >> README.md
	@tock -x memos -e "md,txt" >> README.md

cat:
	$(MAKE) -C memos/Haskell/范畴论
