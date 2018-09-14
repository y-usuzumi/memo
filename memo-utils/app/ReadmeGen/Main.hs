import System.Directory
import MemoUtils.CodeGen.Markdown
import MemoUtils.DataTypes

main :: IO ()
main = getCurrentDirectory >>= genToc >>= mapM_ (putStrLn . renderToc)
