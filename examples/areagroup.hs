{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}

import Plots

import Diagrams.Prelude
import Diagrams.Coordinates.Isomorphic
import Diagrams.Backend.Rasterific.CmdLine
import Control.Monad.State
import qualified Data.Foldable as F

myaxis :: Axis B V2 Double
myaxis = r2Axis &~ do
  areaPlot foo1 $ key "foo 1"
  areaPlot foo2 $ key "foo 2"
  areaPlot foo3 $ key "foo 3"

-- Prototype for area plot function.
areaPlot
  :: (PointLike V2 n p,
      MonadState (Axis b V2 n) m,
      Plotable (RibbonPlot V2 n) b,
      F.Foldable f)
  => f p -> State (Plot (RibbonPlot V2 n) b) () -> m ()
areaPlot a = ribbonPlot (ps ++ psBase)
  where ps     = a ^.. folded . unpointLike
        psBase = reverse $ set (each . _y) 0 ps

-- make :: Diagram B -> IO ()
-- make = renderRasterific "test.png" (mkWidth 600) . frame 20

main :: IO ()
main = r2AxisMain myaxis

foo1 :: [(Double, Double)]
foo1 = [(10,0.1),(20,1.8),(30,2.0)]
foo2 :: [(Double, Double)]
foo2 = [(10.0,3.5),(20,4.1),(30,6.4)]
foo3 :: [(Double, Double)]
foo3 = [(10,5.8),(20,8.2),(30,9.1)]
