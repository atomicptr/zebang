let parse path =
  let file = open_in path in
  try
    let first_line = input_line file in
    close_in file;

    if String.starts_with first_line ~prefix:"#!" then
      let shebang_content = String.sub first_line 2 (String.length first_line - 2) in
      let parts = String.split_on_char ' ' shebang_content in
      match parts with
      | interpreter :: args -> Ok (interpreter :: args)
      | _ -> Error ("Malformed shebang in file: " ^ path)
    else Error ("No shebang found in file: " ^ path)
  with
  | End_of_file -> Error ("File is empty: " ^ path)
  | Sys_error msg -> Error ("Error opening file: " ^ path ^ "\n" ^ msg)
