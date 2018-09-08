import MemoUtils.CodeGen.Markdown

main :: IO ()
main = genToc "/home/kj/Lab/personal/memo" >>= return . fmap show >>= print
