# Federico Tejeiro - 31 Agosto 2014
# Titanic: Crear un modelo y evaluarlo
# 

# Set working directory 
setwd("~/Personal/GITHUB/Titanic/Titanic")

#import datafiles

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

train.raw <- read.csv("train.csv",header=TRUE,sep=",",colClasses = train.column.types, na.strings=missing.types)
df.train <- train.raw

test.raw <- read.csv("test.csv",header=TRUE,sep=",",colClasses = test.column.types, na.strings=missing.types)
df.test <- test.raw   

# DATA MUNGING


#FITTING A MODEL

#########################
# Vamos a dar un model que prediga si un viajero sobrevivio al Titanic o no
#########################

# Iniciamos la semilla aleatoria para repetir el experimento

semilla <- 123

set.seed(seed=semilla)

#Ahora partimos el training data en dos subconjuntos: 70% de entreno y 30 % de eval

entreno <- sample(1:dim(df.train)[1], size = length(df.train$PassengerId) * 0.7, replace=FALSE)
eval <- setdiff(df.train$PassengerId,entreno)

file_train <- df.train[entreno,]
file_eval <-  df.train[eval,]
  



# Importamos un paquete previamente cargado, en este caso viene con r-base el paquete Recursive Partitioning and Regression Trees’ 

library(rpart)

# Ahora corremos el arbol que busca Survived relacionado con el resto de variables, tomando los data de df.train y como df.train$Survived es discreta (factor) usamos como method class, si fuera continua ponemos method="anova"

fit <- rpart(Survived ~ . , data=file_train, method="class")

#Para entender y ver el arbol de decision creado vamos primero a cargar otros tres paquetes y luego los importamos:

install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')
library(rattle)
library(rpart.plot)
library(RColorBrewer)

#Ahora vemos el arbol con:

plot(fit)
text(fit, cex=0.8)

#Y gráficamente más bonito con

fancyRpartPlot(fit)

##################################
#
# ahora vamos a podar el arbol: prune()
#

#Primero calculamos el valor con menor CP, en nuestro caso: 0.010000
min_cp <-  fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"]

#Ahora la poda 

pfit <- prune(fit, cp=min_cp)

# en este ejemplo el arbol es el mismo!!! Se ve con: > fancyRpartPlot(pfit)

# Para crear ahora el fichero a enviar usamos una funcion predict del paquete rpart

Prediction <- predict(pfit, df.test, type = "class")

# Si la variable fuera continua es mas util poner:
#     Prediction <- predict(fit, df.test, interval=prediction)
# donde nos dan el intevalo en el que se encuentra el 95% de datos, con:
#     Prediction <- predict(fit, df.test, interval=confidence)
# tenemos el intervalo con 95% alrededor del valor medio.


submit <- data.frame(PassengerId = df.test$PassengerId, Survived = Prediction)

write.csv(submit, file = "myfirstdtree.csv", row.names = FALSE)
