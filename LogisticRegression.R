# Federico - 11 Aug 2014
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

# Incluyamos la edad como una columna mas:

df.train$Child <- 0
df.train$Child[df.train$Age < 18] <- 1


#FITTING A MODEL

# Para usar logistic Regression que se usa para predecir algo binario como es Survived 

train.glm <- glm(Survived ~ Pclass + Sex + Age + Child + Embarked + Fare, data= df.train,  family = binomial ("logit"))

#Podemos ver el modelo con:

summary(train.glm)

#USANDO EL MODELO

#Para comprobar la validez del modelo en df.test tenemos:

#Primero trabajamos con el fichero df.test al igual que se hizo con train, es decir:

df.test$Child <- 0
df.test$Child[df.test$Age < 18] <- 1

#Ahora el modelo rpedice una probabilidad de 1 o 0 para cada fila, nosotros elegimos el valor 50% o 0.50%

p.hats <- predict.glm(train.glm, newdata = df.test, type = "response")
 
survival <- vector()
for(i in 1:length(p.hats)) {
  if(p.hats[i] > .5) {
    survival[i] <- 1
  } else {
    survival[i] <- 0
  }
}

# Ahora grabamos el fichero

kaggle.sub <- cbind(PassengerId,survival)
colnames(kaggle.sub) <- c("PassengerId", "Survived")
write.csv(kaggle.sub, file = "kaggle.csv", row.names = FALSE)

# Antes he hecho otra cosa, ¿será valido también??:
#
# submit <- data.frame(PassengerId = df.test$PassengerId, Survived = survival)
# write.csv(submit, file = "logisticmodel.csv", row.names = FALSE)
#
####################################

