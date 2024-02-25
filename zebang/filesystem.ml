let find_files_with_name_ignoring_extension directory filename =
  let files_in_dir = Array.to_list (Sys.readdir directory) in
  List.map
    (fun fname -> Filename.concat directory fname)
    (List.filter (fun fname -> filename = Filename.remove_extension fname) files_in_dir)

let is_executable file_path =
  if Sys.os_type = "Win32" || Sys.os_type = "Cygwin" then
    match Filename.extension file_path with ".exe" | ".bat" -> true | _ -> false
  else
    try
      Unix.access file_path [ X_OK ];
      true
    with Unix.Unix_error _ -> false

let relative_to base_path target_path =
  let rec common_prefix base_lst target_lst =
    match (base_lst, target_lst) with x :: xs, y :: ys when x = y -> common_prefix xs ys | _ -> (base_lst, target_lst)
  in
  let base_segments = String.split_on_char Filename.dir_sep.[0] base_path in
  let target_segments = String.split_on_char Filename.dir_sep.[0] target_path in
  let common, remaining_target = common_prefix base_segments target_segments in
  let ups = List.init (List.length common) (fun _ -> Filename.parent_dir_name) in
  let downs = remaining_target in
  String.concat Filename.dir_sep (ups @ downs)
