locals {
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  db_users = flatten([
    for db in var.databases : [
      for user in var.database_users : {
        db_name = db.name
        member  = user
      }
    ]
  ])
}
