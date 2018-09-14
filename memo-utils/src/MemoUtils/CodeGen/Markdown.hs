module MemoUtils.CodeGen.Markdown where

import           Data.Functor.Foldable
import           Data.Tree
import           MemoUtils.DataTypes
import           Text.Printf

renderToc :: Toc -> String
renderToc toc =
  flip cata toc $ \(NodeF node children) ->
                    printf "* [%s](%s)" (title node) (link node)
