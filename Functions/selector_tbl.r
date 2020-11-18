function(){
  data.table::fread(input = paste0(list.dirs(path = 'Data')[-1][list.dirs(path = 'Data')[-1] == 'Data/ShipName&ID&Type'],
                                   '/',
                                   list.files(path = list.dirs(path = 'Data')[-1][list.dirs(path = 'Data')[-1] == 'Data/ShipName&ID&Type'])[2])) %>%
    dplyr::mutate(SHIP_ID = SHIP_ID_str %>% 
                    stringr::str_replace_all(pattern = ' ',replacement = '') %>%
                    stringr::str_replace_all(pattern = '0',replacement = 'Q') %>%
                    stringr::str_replace_all(pattern = '1',replacement = 'W') %>%
                    stringr::str_replace_all(pattern = '2',replacement = 'E') %>%
                    stringr::str_replace_all(pattern = '3',replacement = 'R') %>%
                    stringr::str_replace_all(pattern = '4',replacement = 'T') %>%
                    stringr::str_replace_all(pattern = '5',replacement = 'Y') %>%
                    stringr::str_replace_all(pattern = '6',replacement = 'A') %>%
                    stringr::str_replace_all(pattern = '7',replacement = 'S') %>%
                    stringr::str_replace_all(pattern = '8',replacement = 'D') %>%
                    stringr::str_replace_all(pattern = '9',replacement = 'F')) %>%
    dplyr::select(-c("SHIP_ID_str"))
}