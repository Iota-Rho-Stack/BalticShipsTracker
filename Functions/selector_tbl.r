function(){
  data.table::fread(input = paste0(list.dirs(path = 'Data')[-1][list.dirs(path = 'Data')[-1] == 'Data/ShipName&ID&Type'],
                                   '/',
                                   list.files(path = list.dirs(path = 'Data')[-1][list.dirs(path = 'Data')[-1] == 'Data/ShipName&ID&Type'])[2])) %>%
    dplyr::mutate(SHIP_ID = SHIP_ID_str %>% stringr::str_replace_all(pattern = ' ',replacement = '')) %>%
    dplyr::select(-c("SHIP_ID_str"))
}