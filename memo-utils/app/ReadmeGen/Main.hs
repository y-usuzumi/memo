import System.Directory
import System.FilePath.Posix
import MemoUtils.CodeGen.Markdown
import MemoUtils.DataTypes
import Options.Applicative

data Args = Args { dir :: FilePath
                 }


argsParser :: Parser Args
argsParser = Args
  <$> argument str ( metavar "dir"
                   )

opts :: ParserInfo Args
opts = info (argsParser <**> helper)
  ( fullDesc
  <> progDesc "Generate markdown of TOC"
  <> header "memo-utils-toc-gen"
  )

run :: Args -> IO ()
run Args{..} = genToc pred dir >>= putStrLn . renderTocs
  where
    pred fp =
      (||) <$> doesDirectoryExist fp <*> (return . (== ".md") . takeExtension) fp



main :: IO ()
main = execParser opts >>= run
