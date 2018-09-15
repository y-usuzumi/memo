module MemoUtils.DataTypes where

import           Control.Arrow
import           Control.Monad
import           Data.Functor.Foldable
import           Data.Tree
import           System.Directory
import           System.FilePath.Posix
import           Text.Printf
import           Text.Show.Deriving

data TocItem = TocItem { title :: String
                       , link  :: String
                       } deriving Show

type TocF = TreeF TocItem
type Toc = Tree TocItem

$(deriveShow1 ''TreeF)


singletonToc :: TocItem -> Toc
singletonToc item = Fix ( NodeF { node = item
                                , children = []
                                }
                        )

andChildren :: Toc -> [Toc] -> Toc
andChildren toc children = Fix $
  (unfix toc){children=children
             }

genToc :: (FilePath -> IO Bool) -> FilePath -> IO [Toc]
genToc pred fp = do
  childFPs <- map (id &&& (fp </>)) <$> listDirectory fp >>= filterM (pred . snd)
  forM childFPs $ \(name, fullName) -> do
    let childFP = fp </> name
    let st = singletonToc $ TocItem { title = name
                                    , link = childFP
                                    }
    de <- doesDirectoryExist childFP
    if de
      then do
      childTocs <- genToc pred childFP
      return $ st `andChildren` childTocs
      else
      return st
