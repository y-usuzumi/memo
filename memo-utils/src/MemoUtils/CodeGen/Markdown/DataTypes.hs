module MemoUtils.CodeGen.Markdown.DataTypes where

import           Language.Haskell.TH.Syntax
import           MemoUtils.DataTypes
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

