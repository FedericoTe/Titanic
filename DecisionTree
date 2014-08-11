# Trevor Stephens - 9 Jan 2014
# Titanic: Getting Started With R - Part 2: The gender-class model
# Full guide available at http://trevorstephens.com/


# Set working directory 
setwd("~/Personal/GITHUB/Titanic/Titanic")

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

train.raw <- readData(Titanic.path, train.data.file, 
                      train.column.types, missing.types)
df.train <- train.raw

test.raw <- readData(Titanic.path, test.data.file, 
                     test.column.types, missing.types)
df.test <- test.raw   

# DATA MUNGING
#FITTING A MODEL

# Importamos un paquete previamente cargado, en este caso viene con r-base el paquete Recursive Partitioning and Regression Trees’ 

library(rpart)

# Ahora corremos el arbol que busca Survived relacionado con el resto de variables, tomando los data de df.train y como df.train$Survived es discreta (factor) usamos como method class, si fuera continua ponemos method="anova"

fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")

#Para entender y ver el arbol de decision creado vamos primero a cargar otros tres paquetes y luego los importamos:

install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')
library(rattle)
library(rpart.plot)
library(RColorBrewer)

#Ahora vemos el arbol con:

plot(fit)
text(fit)

#Y gráficamente más bonito con

fancyRpartPlot(fit)

# Para crear ahora el fichero a enviar usamos una funcion predict del paquete rpart

Prediction <- predict(fit, test, type = "class")
submit <- data.frame(PassengerId = df.test$PassengerId, Survived = Prediction)
write.csv(submit, file = "myfirstdtree.csv", row.names = FALSE)
