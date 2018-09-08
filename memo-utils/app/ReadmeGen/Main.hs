import MemoUtils.CodeGen.Markdown

main :: IO ()
main = genToc "/home/kj/Lab/personal/memo" >>= mapM_ putStrLn . fmap show
