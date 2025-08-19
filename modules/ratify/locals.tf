# locals.tf - Ratify module local values

locals {
  # Combine default excluded namespaces with user-provided ones
  combined_excluded_namespaces = concat(
    ["kube-system", "gatekeeper-system"], # Default namespaces to exclude
    var.excluded_namespaces               # User-provided additional exclusions
  )
}
