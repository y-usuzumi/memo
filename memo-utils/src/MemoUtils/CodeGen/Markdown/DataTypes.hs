module MemoUtils.CodeGen.Markdown.DataTypes where

import           MemoUtils.DataTypes (TreeF, Tree)
import           Text.Show.Deriving

data TocItem = TocItem { title :: String
                       , link  :: String
                       } deriving Show

type Toc = Tree TocItem

$(deriveShow1 (TreeF TocItem))


singletonToc :: TocItem -> Toc
singletonToc item = Fix ( NodeF { node = item
                                , children = []
                                }
                        )

andChildren :: Toc -> [Toc] -> Toc
andChildren toc children = Fix $
  (unfix toc){children=children
             }

