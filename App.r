# Load %>% Pipes
base::library(magrittr)

### Shiny App

ui <- shiny.semantic::semanticPage(
  shiny::h1("Baltic Ships Tracker"),
  shiny.semantic::sidebar_layout(
    shiny.semantic::sidebar_panel(
      shiny::p("Select Vessel Class & Name:"),
      
      shiny.semantic::dropdown_input(input_id = "dditype",
                     choices = source('Functions/shiptype_tbl.r')$value(),
                     value = 'Tanker'),
      shiny::uiOutput("ddoname") 
    ),
    shiny.semantic::main_panel(
      shiny.semantic::segment(
        class = "basic",
        leaflet::leafletOutput("map")
        
      )
    )
  )
)

server <- function(input, output, session) {
  
  shiny::observeEvent(input$dditype,{
    output$ddoname <- shiny::renderUI({
      shiny::tagList(
        shiny.semantic::dropdown_input(
          input_id = "ddiname",
          choices = source('Functions/selector_tbl.r')$value() %>% dplyr::filter(ship_type == input$dditype) %>% dplyr::select(SHIPNAME),
          value = source('Functions/selector_tbl.r')$value() %>% dplyr::filter(ship_type == input$dditype) %>% dplyr::select(SHIPNAME) %>% dplyr::slice_head(n=1)
        )
      )
    })
  })
  
  shiny::observeEvent(input$ddiname,{
    output$map <- leaflet::renderLeaflet({
      
      m <- leaflet::leaflet(data = source('Functions/data_query.r')$value(Type = input$dditype,ID = source('Functions/getIDxNAME.r')$value(name = input$ddiname)) 
                            %>%
        dplyr::mutate(Dx = SPEED*ELAPSED) %>%
        dplyr::mutate(Dxlag = lag(Dx)) %>%
        dplyr::mutate(DDx = (Dx - Dxlag)) %>%
        dplyr::mutate(ismaxDDx = dplyr::if_else(DDx == max(DDx,na.rm = T),T,F)) %>%
        dplyr::filter(base::as.numeric(base::unlist(DATETIME)) <= source('Functions/data_query.r')$value(Type = input$dditype,ID = source('Functions/getIDxNAME.r')$value(name = input$ddiname)) %>%
                        dplyr::mutate(Dx = SPEED*ELAPSED) %>%
                        dplyr::mutate(Dxlag = lag(Dx)) %>%
                        dplyr::mutate(DDx = (Dx - Dxlag)) %>%
                        dplyr::mutate(ismaxDDx = dplyr::if_else(DDx == max(DDx,na.rm = T),T,F)) %>%
                        dplyr::filter(ismaxDDx == T) %>%
                        dplyr::select(DATETIME) %>%
                        dplyr::slice_tail(n=1) %>%
                        base::unlist() %>%
                        base::as.numeric()) %>%
        dplyr::slice_tail(n=2) %>%
        dplyr::mutate(Distance_Meters = SPEED*ELAPSED) %>%
        dplyr::select(c(Distance_Meters,DATETIME,LON,LAT))) %>%
        leaflet::addTiles() %>%
        leaflet::addMarkers(lng = ~LON, lat =  ~LAT) %>%
        leaflet::addPolygons(lng = ~LON, lat =  ~LAT)
      m <- leaflet::addMarkers(map = m,
                               data = leaflet::getMapData(m),
                               label = paste("Distance Navigated (meters):", leaflet::getMapData(m)$Distance_Meters),
                               labelOptions = leaflet::labelOptions(noHide = F, direction = "bottom",
                                                           style = list(
                                                             "font-family" = "serif",
                                                             "font-style" = "bold",
                                                             "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                                             "font-size" = "15px",
                                                             "border-color" = "rgba(0,0,0,0.5)"
                                                           )),
                               popup = paste(leaflet::getMapData(m)$DATETIME),
                               popupOptions = leaflet::popupOptions(noHide = T, direction = "top",
                                                           style = list(
                                                             "color" = "red",
                                                             "font-family" = "serif",
                                                             "font-style" = "bold",
                                                             "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                                             "font-size" = "12px",
                                                             "border-color" = "rgba(0,0,0,0.5)"
                                                           ))
                               )
      m
    })
  })
  
  
}
shiny::shinyApp(ui, server)
