module MemoUtils.CodeGen.Markdown where

import MemoUtils.DataTypes

data TocItem = TocItem { title :: String
                       , link :: String
                       }

type Toc = Tree TocItem

singletonToc :: TocItem -> Toc
singletonToc item = Fix ( NodeF { node = item
                                , children = []
                                }
                        )

