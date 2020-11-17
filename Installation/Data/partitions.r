## Initialize Data Partitions

# Load magrittr.
base::library(magrittr)

# Clean House
if(base::dir.exists('Data')){
  base::unlink(x = 'Data', recursive = T)
}

# Build Data Folder
if(!base::dir.exists('Data')){
  base::dir.create('Data')
  ships_sdf <- sparklyr::spark_read_csv(
    sc = base::source(file = 'Spark/connect.r')$value,
    name = "ships_sdf",
    path = 'Raw/raw.csv'
  )
  base::print('Create List of Ship Types.')
  ships_sdf %>%
    dplyr::select("ship_type") %>%
    dplyr::distinct() %>%
    sparklyr::sdf_coalesce(partitions = 1) %>%
    sparklyr::spark_write_csv(path = 'Data/ShipType')
  base::print('Create Ship Directory.')
  ships_sdf %>%
    dplyr::select(c("SHIPNAME","SHIP_ID","ship_type")) %>%
    dplyr::distinct() %>%
    dplyr::mutate(SHIP_ID_str = as.character(SHIP_ID)) %>%
    dplyr::select(-c("SHIP_ID")) %>%
    sparklyr::sdf_coalesce(partitions = 1) %>%
    sparklyr::spark_write_csv(path = 'Data/ShipName&ID&Type')
  base::print('Partitioning Data... ')
  for(TYPE in c(base::unlist(source('Functions/shiptype_tbl.r')$value()))){
    for(NAME in (source('Functions/selector_tbl.r')$value() %>% dplyr::filter(ship_type == TYPE))$SHIPNAME){
      for(ID in (source('Functions/selector_tbl.r')$value() %>% dplyr::filter(SHIPNAME == NAME))$SHIP_ID){
        ships_sdf %>%
          dplyr::filter(SHIPNAME == NAME) %>%
          sparklyr::sdf_coalesce(partitions = 1) %>%
          sparklyr::spark_write_csv(path = base::paste('Data/Partition',TYPE,ID,sep = '/'), mode = 'append')
      }
    }
    base::print('.')
  }
  base::print('Partition Complete.')
}

# Spark disconnect.
sparklyr::spark_disconnect_all()

# Remove Global Variables.
base::remove(ships_sdf)
base::remove(ID)
base::remove(NAME)
base::remove(TYPE)
