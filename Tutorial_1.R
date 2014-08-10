

# Indicar el directorio de trabajo

setwd("~/Personal/GITHUB/Titanic/Titanic")

# Importar los datos
 
train <- read.csv("~/Personal/GITHUB/Titanic/Titanic/train.csv")
View(train)
test <- read.csv("~/Personal/GITHUB/Titanic/Titanic/test.csv")
View(test)

# Vemos la proporcion de supervivientes con:

prop.table(table(train$Survived))

# Creamos una columna a la derecha de la tabla test llamada survived y la llenamos de 0 repitiendo el valor 0 418 veces.

test$Survived <- rep(0, 418)

# Vemos de nuevo la tabla con:

View(test)

# ahora creamos un nuevo contenedor o tabla con dos columnas, PassengerId y Survived de la tabla de test.csv

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)

# Y la grabamos como un fichero en el directorio de trabajo:

write.csv(submit, file = "theyallperish.csv", row.names = FALSE)

#Por ultimo grabamos este fichero

source('~/Personal/GITHUB/Titanic/Titanic/Tutorial_1.R')


