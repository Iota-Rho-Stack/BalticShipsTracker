function(Type = 'Tanker', ID = 'GDDD'){
  dirpath <- base::paste('Data/Partition',Type,ID, sep='/')
  csv <- base::list.files(path = dirpath)[2]
  return(data.table::fread(input = base::paste(dirpath,csv,sep = '/')))
}
