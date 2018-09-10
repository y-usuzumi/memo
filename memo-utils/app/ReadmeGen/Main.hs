import System.Directory
import MemoUtils.CodeGen.Markdown

main :: IO ()
main = getCurrentDirectory >>= genToc >>= mapM_ putStrLn . fmap show
