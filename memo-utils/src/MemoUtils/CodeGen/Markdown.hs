module MemoUtils.CodeGen.Markdown where

import           Control.Monad
import           Data.Functor.Foldable
import           Data.List
import           Data.Tree
import           MemoUtils.DataTypes
import           Text.Printf

renderToc :: Toc -> String
renderToc toc =
  intercalate "\n" $ flip cata toc $ \(NodeF node children) ->
                    printf "* [%s](%s)" (title node) (link node) :
                    map ("  " ++) (join children)

renderTocs :: [Toc] -> String
renderTocs = intercalate "\n" . map renderToc
