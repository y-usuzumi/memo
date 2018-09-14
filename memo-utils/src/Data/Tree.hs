-- |

module Data.Tree where

import           Data.Functor.Classes
import           Data.Functor.Foldable

data TreeF n r = NodeF { node     :: n
                       , children :: [r]
                       } deriving (Show, Functor)

type Tree n = Fix (TreeF n)
