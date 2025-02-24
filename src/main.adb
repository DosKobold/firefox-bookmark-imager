with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;      use Ada.Text_IO;
with Error_Handling;   use Error_Handling;
with Imaging;
with Parse_Args;       use Parse_Args;

procedure Main is
   Folder_Id  : Natural;
   Arg_Parser : Argument_Parser;
begin
   Arg_Parser.Add_Option
     (Make_Boolean_Option (False),
      "help",
      'h',
      Usage => "Display this help text");
   Arg_Parser.Add_Option
     (Make_Boolean_Option (True),
      "doubles",
      'd',
      Usage => "Disable doubles in the folders");
   Arg_Parser.Add_Option
     (Make_Positive_Option (50),
      "tree-depth",
      't',
      Usage => "Change the tree depth for recursive algorithm. Default: 50");
   Arg_Parser.Append_Positional (Make_String_Option, "DATABASE");
   Arg_Parser.Append_Positional (Make_String_Option, "ROOTFOLDER");
   Arg_Parser.Parse_Command_Line;

   if not Arg_Parser.Parse_Success then
      Put_Line (Arg_Parser.Parse_Message);
      Panic ("Parsing of command line arguments failed");
   end if;

   if Arg_Parser.Boolean_Value ("help") then
      Arg_Parser.Usage;

      goto Successfull_End_Of_Program;
   end if;

   if Arg_Parser.String_Value ("DATABASE")'Length = 0
     or else Arg_Parser.String_Value ("ROOTFOLDER")'Length = 0
   then
      Panic ("Missing required argument(s). Use ""-h"" for help");
   end if;

   Imaging.Initialize
     (Arg_Parser.String_Value ("DATABASE"),
      Arg_Parser.Boolean_Value ("doubles"),
      Positive (Arg_Parser.Integer_Value ("tree-depth")));
   begin
      Folder_Id := Natural'Value (Arg_Parser.String_Value ("ROOTFOLDER"));
   exception
      when Constraint_Error =>
         Imaging.Image (Arg_Parser.String_Value ("ROOTFOLDER"));
         Imaging.Clean_Up;

         goto Successfull_End_Of_Program;
   end;
   Imaging.Image (Folder_Id);
   Imaging.Clean_Up;

   <<Successfull_End_Of_Program>>

   Set_Exit_Status (0);

end Main;
