module MemoUtils.DataTypes where

import           Control.Arrow
import           Control.Monad
import           Data.Functor.Foldable
import           Data.List
import           Data.Tree
import           System.Directory
import           System.FilePath.Posix
import           Text.Printf
import           Text.Show.Deriving

data TocItemType = Directory | File
                 deriving (Enum, Eq, Ord, Show)

data TocItem = TocItem { title :: String
                       , link  :: String
                       , type_ :: TocItemType
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

-- genToc :: FilePath -> IO Toc
-- genToc fp = do
--   isDir <- doesDirectoryExist fp
--   let name = takeFileName fp
--   let st = singletonToc $ TocItem { title = name
--                                   , link = fp
--                                   , type_ = if isDir then Directory else File
--                                   }
--   if isDir
--     then do
--     childTocs <- listDirectory fp >>= return . map (fp </>) >>= mapM genToc
--     return $ st `andChildren` childTocs
--     else
--     return st

genToc :: FilePath -> IO [Toc]
genToc fp = do
  childFPs <- map (id &&& (fp </>)) <$> listDirectory fp
  childTocs <- forM childFPs $ \(name, fullName) -> do
    let childFP = fp </> name
    isDir <- doesDirectoryExist childFP
    let st = singletonToc $ TocItem { title = name
                                    , link = childFP
                                    , type_ = if isDir then Directory else File
                                    }
    if isDir
      then do
      childTocs <- genToc childFP
      return $ st `andChildren` (sortBy sortFunc childTocs)
      else
      return st
  return $ sortBy sortFunc childTocs
  where
    sortFunc (Fix (NodeF{ node = TocItem{ title = title1, type_ = t1 }})) (Fix (NodeF{ node = TocItem{ title = title2, type_ = t2 }}))
      | t1 < t2 = GT
      | t1 > t2 = LT
      | t1 == t2 = compare title1 title2
