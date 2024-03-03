let parse_line line =
  if String.starts_with line ~prefix:"#!" then
    let shebang_content = String.sub line 2 (String.length line - 2) in
    let parts = String.split_on_char ' ' shebang_content in
    match parts with
    | interpreter :: args -> Ok (interpreter :: args)
    | _ -> Error "Malformed shebang"
  else Error "No shebang found"

let parse_file path =
  let file = open_in path in
  try
    let first_line = input_line file in
    close_in file;

    match parse_line first_line with
    | Ok args -> Ok args
    | Error msg -> Error (msg ^ " in file: " ^ path)
  with
  | End_of_file -> Error ("File is empty: " ^ path)
  | Sys_error msg -> Error ("Error opening file: " ^ path ^ "\n" ^ msg)
