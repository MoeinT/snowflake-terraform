output "here_doc_strings" {
  value = <<EOT
Hello
It's
me
  EOT
}

output "json_string" {
  value = jsonencode({
    "name" = "Moein", "family name" = "Torabi", "age" = 28
  })
}

#Using directives within strings!
output "greetings" {
  value = "Hello, %{if var.name != ""}${var.name}%{else}unnammed%{endif}!"
}

output "for_map" {
  value = { for index, role in ["admin", "public", "engineering", "admin"] : index => upper(role) }
}

#Only get the even numbers from the list
output "for_if_else" {
  value = [for number in [1, 4, 10, 3] : number if number % 2 == 0]
}