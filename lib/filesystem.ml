let find_files_with_name_ignoring_extension directory filename =
  let files_in_dir = Array.to_list (Sys.readdir directory) in
  List.map
    (fun fname -> Filename.concat directory fname)
    (List.filter (fun fname -> filename = Filename.remove_extension fname) files_in_dir)

let is_executable file_path =
  if Sys.os_type = "Win32" || Sys.os_type = "Cygwin" then false
  else
    try
      Unix.access file_path [ X_OK ];
      true
    with Unix.Unix_error _ -> false
