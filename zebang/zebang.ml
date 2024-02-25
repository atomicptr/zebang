let rec find_zebang_directory path =
  let zebang_path = Filename.concat path ".zebang" in
  let parent_dir = Filename.concat path Filename.parent_dir_name in
  if Sys.file_exists zebang_path then Ok zebang_path
  else if Sys.file_exists parent_dir then find_zebang_directory parent_dir
  else Error "Could not find zebang directory"

let is_runnable script_path =
  if Filesystem.is_executable script_path then true
  else match Shebang.parse_file script_path with Ok _ -> true | Error _ -> false

type command = CmdDirectory of string | CmdExecutable of string | CmdMultiPartExecutable of string list

let rec find_command_files directory =
  Sys.readdir directory |> Array.to_list
  |> List.map (fun filename ->
         let path = Filename.concat directory filename in
         if Sys.is_directory path then find_command_files path else [ path ])
  |> List.flatten |> List.filter is_runnable

let find_commands directory =
  find_command_files directory
  |> List.map (Filesystem.relative_to directory)
  |> List.map Filename.remove_extension
  |> List.map (String.split_on_char Filename.dir_sep.[0])
  |> List.map (String.concat ":")

let parse_script script_path =
  if Filesystem.is_executable script_path then Ok (CmdExecutable script_path)
  else
    match Shebang.parse_file script_path with
    | Ok (interpreter :: args) -> Ok (CmdMultiPartExecutable ([ interpreter ] @ args @ [ script_path ]))
    | Ok [] -> Error "Invalid shebang found"
    | Error msg -> Error msg

let rec parse_command directory command =
  let parts = String.split_on_char ':' command in
  let command_head = List.hd parts in
  let command_path = Filename.concat directory command_head in
  if Sys.file_exists command_path && Sys.is_directory command_path then
    if List.is_empty (List.tl parts) then Ok (CmdDirectory command_path)
    else parse_command command_path (String.concat ":" (List.tl parts))
  else
    match Filesystem.find_files_with_name_ignoring_extension directory command_head with
    | [ script_path ] -> parse_script script_path
    | _ -> Error (Printf.sprintf "(Sub)Command '%s' could not be found in %s" command directory)

let rec run_command cmd args =
  match cmd with
  | CmdDirectory dir ->
      let files = Sys.readdir dir |> Array.to_list |> List.map (fun script_path -> Filename.concat dir script_path) in
      let results =
        List.map
          (fun script_path ->
            match parse_script script_path with Ok cmd -> Ok (run_command cmd []) | Error msg -> Error msg)
          files
      in
      List.fold_left
        (fun acc elem ->
          match (acc, elem) with
          | Ok _, Error msg -> Error msg
          | Error msg, Ok _ -> Error msg
          | Error prev, Error msg -> Error (prev ^ ": " ^ msg)
          | Ok _, Ok _ -> acc)
        (Ok ()) results
  | CmdExecutable executable_path ->
      let command = Filename.quote_command executable_path args in
      let exit_code = Sys.command command in
      if exit_code == 0 then Ok () else Error (Printf.sprintf "Command: %s, exit code: %i" command exit_code)
  | CmdMultiPartExecutable executable_list ->
      let command = Filename.quote_command (List.hd executable_list) (executable_list @ args) in
      let exit_code = Sys.command command in
      if exit_code == 0 then Ok () else Error (Printf.sprintf "Command: %s, exit code: %i" command exit_code)

let print_command_list zebang_directory =
  Printf.printf "Available commands:\n";
  List.iter (fun filename -> Printf.printf "\t%s\n" filename) (find_commands zebang_directory)

let run_cli working_directory args =
  let zebang_directory =
    match find_zebang_directory working_directory with Ok path -> path | Error msg -> failwith msg
  in
  if List.is_empty args then (
    print_command_list zebang_directory;
    exit 0);
  let cmd = match parse_command zebang_directory (List.hd args) with Ok cmd -> cmd | Error msg -> failwith msg in
  match run_command cmd args with Ok _ -> exit 0 | Error msg -> failwith msg