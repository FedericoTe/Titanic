# Trevor Stephens - 9 Jan 2014
# Titanic: Getting Started With R - Part 2: The gender-class model
# Full guide available at http://trevorstephens.com/


# Set working directory 
setwd("~/Personal/GITHUB/Titanic/Titanic/")

#import datafiles

Titanic.path <- "https://github.com/FedericoTe/Titanic/"
train.data.file <- "train.csv"
test.data.file <- "test.csv"
missing.types <- c("NA", "")
train.column.types <- c('integer',   # PassengerId
                        'factor',    # Survived 
                        'factor',    # Pclass
                        'character', # Name
                        'factor',    # Sex
                        'numeric',   # Age
                        'integer',   # SibSp
                        'integer',   # Parch
                        'character', # Ticket
                        'numeric',   # Fare
                        'character', # Cabin
                        'factor'     # Embarked
)
test.column.types <- train.column.types[-2]     # # Como no existe la columna Survived in test.csv

# This leaves me with much cleaner code for reading the csv files.

train.raw <- read.csv(train.data.file)
df.train <- train.raw

test.raw <- read.csv(test.data.file)
df.test <- test.raw   

# DATA MUNGING

#Veamos la proporcion de supervivientes por género

prop.table(table(df.train$Sex, df.train$Survived),1)

# podemos ahora crear un fichero a enviar a kaggle considerando no que todo el mundo muere sino que mueren solo los hombres a la luz de la proporción que nos aparece: 74% de mujeres sobrevive comparado con 19% de hombres

df.test$Survived <- 0
df.test$Survived[df.test$Sex == 'female'] <- 1

# si tenemos en cuenta también la edad, vemos que no hay realmente ninguna influencia:

#para hacer proporciones con variables continuas como la edad, creamos una nueva columna en la tabla y asignamos valores 1 Sí clid y 0 no child. a los valroes que faltan les damos el valor medio que es adulto.

df.train$Child <- 0
df.train$Child[df.train$Age < 18] <- 1

#Ahora podemos calcular las proporciones con:

aggregate(Survived ~ Child + Sex, data=df.train, FUN=function(x) {sum(x)/length(x)})


# No hay influencia, pero cuando consideramos la tarifa y la clase además del sexo sí que hay relación:

#Como anteriormente, creamos una nueva columna para tabular en 4 la variable continua Fare

df.train$Fare2 <- '30+'
df.train$Fare2[df.train$Fare < 30 & df.train$Fare >= 20] <- '20-30'
df.train$Fare2[df.train$Fare < 20 & df.train$Fare >= 10] <- '10-20'
df.train$Fare2[df.train$Fare < 10] <- '<10'

#Ahora comprobamos las proporciones:

aggregate(Survived ~ Fare2 + Pclass + Sex, data=df.train, FUN=function(x) {sum(x)/length(x)})

# Podemos así mejorar algo más nuestra prediccion con:

df.test$Survived <- 0
df.test$Survived[df.test$Sex == 'female'] <- 1
df.test$Survived[df.test$Sex == 'female' & df.test$Pclass == 3 & df.test$Fare >= 20] <- 0

# Creamos el fichero final y lo grabamos


submit <- data.frame(PassengerId = df.test$PassengerId, Survived = df.test$Survived)
write.csv(submit, file = "genderclassmodel.csv", row.names = FALSE)
