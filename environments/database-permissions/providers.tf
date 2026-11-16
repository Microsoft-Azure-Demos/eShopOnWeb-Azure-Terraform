provider "mssql" {
  # Connects to the SQL Server created by the infrastructure configuration.
  hostname = data.terraform_remote_state.infrastructure.outputs.sql_server_fqdn
  port     = 1433

  azure_auth {}
}
