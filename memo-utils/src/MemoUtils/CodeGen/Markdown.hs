module MemoUtils.CodeGen.Markdown where

import           Control.Monad
import           MemoUtils.CodeGen.Markdown.DataTypes
import           System.Directory

genToc :: FilePath -> IO [Toc]
genToc fp = do
  childFPs <- listDirectory fp
  forM childFPs $ \childFP -> do
    let st = singletonToc $ TocItem { title = childFP
                                    , link = childFP
                                    }
    de <- doesDirectoryExist childFP
    if de
      then do
      childTocs <- genToc childFP
      return $ st `andChildren` childTocs
      else return st
