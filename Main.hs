import qualified Data.Text.IO as T
import qualified Data.Text as T

import OtherModule

main :: IO ()
main = T.putStrLn (T.pack secretString)
