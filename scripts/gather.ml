open Core.Std

module Shell = Core_extended.Std.Shell
module Ascii_table = Core_extended.Std.Ascii_table
module Column = Ascii_table.Column

let file = Column.create "File" (fun (x,_) -> x)
let package = Column.create "Packages" (fun (_,x) -> String.(concat ~sep:" " x))

let scan_directory filename =
  Sys.chdir filename;
  let files = Shell.run_lines "ls" [] in
  (* For each file, read the list of camlp4 files it contains *)
  let tbl = String.Table.create () in
  List.iter files ~f:(fun file ->
    In_channel.read_lines file |!
    List.map ~f:Filename.chop_extension |!
    List.iter ~f:(fun m ->
      Hashtbl.add_multi tbl m file
    )
  );
  Ascii_table.output [file;package] (Hashtbl.to_alist tbl)
    ~limit_width_to:200
    ~display:Ascii_table.Display.short_box
    ~oc:stdout
  
let gather =
  Command.basic
    ~summary:"Summarise camlp4 extension logs"
    Command.Spec.(empty +> anon ("directory" %: string))
    (fun filename () ->
      scan_directory filename)

let () =
  Exn.handle_uncaught ~exit:true (fun () -> Command.run gather)
