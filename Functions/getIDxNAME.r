function(name = "BALTICO"){
  source('Functions/selector_tbl.r')$value() %>% dplyr::filter(SHIPNAME == name) %>% dplyr::select(SHIP_ID) %>% dplyr::slice_head(n=1)
}