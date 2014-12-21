#downloading features
features = readLines("features.txt")

#extracting features that represent mean values and their positions
meanfn = grep("mean\\(\\)",features)
meanf = grep("mean\\(\\)",features,value = T)
meanf = gsub("^[0-9]+ ","",meanf)

#extracting features that represent standard deviation values and their positions
stdfn = grep("std\\(\\)",features)
stdf = grep("std\\(\\)",features,value = T)
stdf = gsub("^[0-9]+ ","",stdf)

#downloading and processing activities
activity_l = readLines("activity_labels.txt")
activity_l = gsub("^[0-9]+ ","",activity_l)

#downloading and merging subjects
subject_test = as.numeric(readLines("test/subject_test.txt"))
subject_train = as.numeric(readLines("train/subject_train.txt"))
subject_ = c(subject_test,subject_train)

#downloading and merging data sets
X_test = readLines("test/X_test.txt")
X_train = readLines("train/X_train.txt")
X_ = c(X_test,X_train)

#splitting values from string
X_1 = strsplit(X_,"[ ]+",)
X_1 = lapply(X_1,as.numeric)

#converting it to data frame (first column is empty because of splitting algorithm, so delete it)
X_2 = do.call(rbind.data.frame, X_1)
X_2 = X_2[,-1]
colnames(X_2) = 1:ncol(X_2)
#extracting only mean and sd values and naming columns
X_3 = X_2[,c(meanfn,stdfn)]
colnames(X_3) = c(meanf,stdf)

#downloading, merging and processing activities
y_test = readLines("test/y_test.txt")
y_train = readLines("train/y_train.txt")
y_ = c(y_test,y_train)
for ( i in 1:length(activity_l))
  y_ = gsub(as.character(i),activity_l[i],y_)

#adding activities and subjects to data
data = cbind(subject = subject_, activity = y_, X_3) 

#averaging data by activity and each subject
tdata = aggregate(data[,-(1:2)],data[,(1:2)],mean)

#writing data to text file
write.table(tdata,"tidy_data.txt",row.name=FALSE)
