module MemoUtils.CodeGen.Markdown where

import           Control.Monad
import           MemoUtils.CodeGen.Markdown.DataTypes
import           System.Directory
import           System.FilePath.Posix
import           Text.Printf

genToc :: FilePath -> IO [Toc]
genToc fp = do
  childFPs <- listDirectory fp
  forM childFPs $ \name -> do
    let childFP = fp </> name
    let st = singletonToc $ TocItem { title = childFP
                                    , link = childFP
                                    }
    de <- doesDirectoryExist childFP
    if de
      then do
      childTocs <- genToc childFP
      return $ st `andChildren` childTocs
      else
      return st
