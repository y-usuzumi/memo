module MemoUtils.DataTypes ( module MemoUtils.DataTypes
                           , module Data.Functor.Foldable
                           ) where

import           Data.Functor.Foldable

data TreeF n r = NodeF { node :: n
                       , children :: [r]
                       } deriving (Show, Functor)

type Tree a = Fix (TreeF a)
