import GHC.Natural (isValidNatural)
import Distribution.Simple.Utils (xargs)
--ej1
--I
{-
    max2 :: (Float, Float) -> Float
    normalVectorial :: (Float, Float) -> Float
    substract :: Float -> Float -> Float 
    predecesor :: Float -> Float
    evaluarEnCero :: (Float -> Float) -> Float
    flipAll :: [a -> b -> c] -> [b -> a -> c]
    flipRaro :: (a -> b -> c) -> (b -> a -> c)
-}

--II
{-
    max2 :: Float -> Float -> Float
    max2 x y | x=>y = x
             | otherwise = y
    
    normalVectorial :: Float -> Float -> Float
    normalVectorial x y = sqrt(x^2 + y^2)
    
-}

--ej2
{-curry :: ((a,b) -> c) -> a -> b -> c
curry f x y = f (x, y)

uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (x,y) = f x y
-}
--No que yo sepa, porque hay que saber cuantos parametros hay que ver

--ej3
--[1,2,3]

--ej4
--no nos funciona ya que siempre va a estár buscando un 'c' para el primer 'a' y 'b'
pitagoricas = [(a,b,c) | a <- [1..], b <-[1..a], c <- [1..(a^2+b^2)], c^2 == a^2 + b^2]

--ej5
isPrime :: Integer -> Bool
isPrime n = all notDividedBy [2 .. n `div` 2]
  where
    notDividedBy m = n `mod` m /= 0
primerosMilPrimos = take 1000 [x | x <- [1..], isPrime x]

--ej7

listasQueSuman :: Int -> [[Int]]
listasQueSuman 1 = [[1]]
listasQueSuman n = let listas = listasQueSuman (n-1) in
                    [n] : map (1:) listas ++ map (\xs -> head xs +1 : tail xs) listas

--ej8
listasFinitasDeEnteros = [ xs | n <- [1..], xs <- listasQueSuman n]

--ej10
--I
foldSum :: [Integer] -> Integer
foldSum = foldr (+) 0

foldElem :: Int -> [Int] -> Int
foldElem n = foldr const 0 . take n 

foldConcat :: [a] -> [a] -> [a]
foldConcat = flip $ foldl (flip (:))

--foldFilter y Map hechas en clase

--II
mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun cmp = foldr1 (\x recu -> if cmp x recu then x else recu)

--III
sumasParciales :: Num a => [a] -> [a]
sumasParciales = foldr (\x recu -> x : map (+x) recu) []

--IV
sumaAlt :: Num a => [a] -> a
sumaAlt = foldr (-) 0

--V
sumaAltReverse :: Num a => [a] -> a
sumaAltReverse = foldl (-) 0

--VI 
permutaciones :: [a] -> [[a]]
permutaciones = foldr (\x recu -> if null recu then [[x]] else concatMap (\xs -> [x:xs, xs ++ [x]] ) recu) []


--ej12
--entrelazar es recursión estructural
entrelazar :: [a] -> [a] -> [a]
entrelazar = foldr (\x recu ys -> if null ys then [] else x : head ys : recu (tail ys) ) (const [])
--elemtos en posiciones pares, si lo es, pero se debe usar recr

--ej13
recr _ z [] = z
recr f z (x:xs) = f x xs (recr f z xs)

--a hecho en clase
--b porque necesitamos devolver la cola de la lista al encontrar la primera aparición y no tenemos forma de distinguir la primera de una segunda
--c 
insertarOrdenado :: Ord a => a -> [a] -> [a]
insertarOrdenado a = recr (\x xs recu -> if x < a then x : recu else a : x : xs) [a]

--d no, porque no necesita evaluar la cola xs 

--ej15
--I
mapPares f = map (uncurry f)

--II
armarPares :: [a1] -> [a2] -> [(a1, a2)]
--armarPares [] _ = []
--armarPares _ [] = []
--armarPares (x:xs) (y:ys) = (x,y) : armarPares xs ys

--armarPares [] = const []
--armarPares (x:xs) =  (\ys -> (x, head ys) : armarPares xs (tail ys))

armarPares = foldr (\x recu ys -> if null ys then [] else (x,head ys) : recu (tail ys) ) (const [])

--III
mapDoble :: (a -> b -> c) -> [a] -> [b] -> [c]
mapDoble f xs ys = mapPares f (armarPares xs ys)


--ej17

generate :: ([a] -> Bool) -> ([a] -> a) -> [a]
generate stop next = generateFrom stop next []

generateFrom:: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom stop next xs | stop xs = init xs
                          | otherwise = generateFrom stop next (xs ++ [next xs])
--I
generateBase :: ([a] -> Bool) -> a -> (a -> a) -> [a]
generateBase stop x next = generate stop (\ys -> if null ys then next x else next (head ys)) 

--II
factoriales :: Int -> [Int]
factoriales n = generate (\xs -> length xs == n) (\xs -> if null xs then 1 else (length xs + 1) * head xs )