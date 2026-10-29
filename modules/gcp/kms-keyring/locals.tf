locals {
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  # Flatten keys and their IAM members into a list of objects for IAM bindings
  key_members = flatten([
    for key in var.keys : [
      for member in key.encrypter_decrypters : {
        key_name = key.name
        member   = member
      }
    ]
  ])
}
