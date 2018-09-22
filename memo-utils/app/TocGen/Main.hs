import           MemoUtils.CodeGen.Markdown
import           MemoUtils.DataTypes
import           Options.Applicative
import           System.Directory
import           System.FilePath.Posix

data Args = Args { dir              :: FilePath
                 , excludeEmptyDirs :: Bool
                 }


argsParser :: Parser Args
argsParser = Args
  <$> argument str ( metavar "dir"
                   <> help "The root directory to look for contents"
                   )
  <*> flag False True (short 'x'
                      <> help "Exclude directories that do not have files (recursively)"
                      )

opts :: ParserInfo Args
opts = info (argsParser <**> helper)
  ( fullDesc
  <> progDesc "Generate markdown of TOC"
  <> header "memo-utils-toc-gen"
  )

run :: Args -> IO ()
run Args{..} = genToc dir >>= putStrLn . renderTocs RenderOptions{ excludeEmptyDirs = excludeEmptyDirs
                                                                 }
  where
    pred fp =
      (||) <$> doesDirectoryExist fp <*> (return . (== ".md") . takeExtension) fp



main :: IO ()
main = execParser opts >>= run
