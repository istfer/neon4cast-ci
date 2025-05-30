## setup
library(gdalcubes)
library(gefs4cast)

gdalcubes::gdalcubes_options(parallel=20)
#gdalcubes::gdalcubes_options(parallel=TRUE)

sites <-
  dplyr::bind_rows(
    readr::read_csv(paste0("https://github.com/eco4cast/",
                           "neon4cast-noaa-download/",
                           "raw/master/noaa_download_site_list.csv"),
                    col_select = c("site_id", "latitude", "longitude"))#,
    #readr::read_csv(paste0("https://github.com/eco4cast/neon4cast-targets/",
    #                       "raw/main/tern_field_site_metadata.csv"),
    #                col_select = c("site_id", "latitude", "longitude"))
  )



Sys.setenv("GEFS_VERSION"="v12")
dates <- seq(as.Date("2020-09-24"), Sys.Date()-1, by=1)
dates_pseudo <- seq(as.Date("2020-09-24"), Sys.Date(), by=1)

message("GEFS v12 pseudo")
##bench::bench_time({ #32xlarge
  s3 <- gefs_s3_dir("pseudo")
  have_dates <- gsub("reference_datetime=", "", s3$ls())
  missing_dates <- dates_pseudo[!(as.character(dates_pseudo) %in% have_dates)]
  gefs4cast:::gefs_pseudo_measures(missing_dates,  path = s3, sites = sites)
##})
