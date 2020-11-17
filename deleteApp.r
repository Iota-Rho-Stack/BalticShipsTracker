# Delete Partitions 
base::unlink(x = "Data", recursive = T)

# Uninstall Spark
source('Installation/Spark/uninstall_spark.r')

# Delete derby.log.
base::unlink(x = "derby.log", recursive = T)

# Delete derby.log.
base::unlink(x = "logs", recursive = T)

# Delete rsconnect.
base::unlink(x = "rsconnect", recursive = T)

# Delete raw data.
base::unlink(x = "Raw/raw.csv", recursive = T)

# Uninstall Dependencies.
source('Installation/Dependencies/uninstall_dependencies.r')
