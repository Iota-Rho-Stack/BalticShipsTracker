function(){
  return(data.table::fread(input = paste0(list.dirs(path = 'Data')[-1][list.dirs(path = 'Data')[-1] == 'Data/ShipType'],
                                   '/',
                                   list.files(path = list.dirs(path = 'Data')[-1][list.dirs(path = 'Data')[-1] == 'Data/ShipType'])[2])))
}