with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNATCOLL.SQL.Exec;     use GNATCOLL.SQL.Exec;

package Imager is

   type Image_Description is record
      Database    : Unbounded_String;
      Doubles     : Boolean;
      Tree_Depth  : Positive;
      Folder_Pre  : Unbounded_String;
      Folder_Post : Unbounded_String;
      Object_Pre  : Unbounded_String;
      Object_Post : Unbounded_String;
   end record;

   procedure Initialize (Given_Descr : Image_Description)
   with Pre => Length (Given_Descr.Database) > 0, Post => Is_Initialized;

   procedure Image (Root_Folder_Title : String)
   with Pre => Is_Initialized;

   procedure Image (Root_Folder_Id : Natural)
   with Pre => Is_Initialized;

   procedure Clean_Up
   with Pre => Is_Initialized, Post => not Is_Initialized;

   function Is_Initialized return Boolean
   with Ghost;

private

   Img_Descr : Image_Description;
   Db_Conn   : Database_Connection;
   Db_Descr  : Database_Description;

   function Is_Initialized return Boolean
   is (Db_Conn /= null);

   procedure Recursive_Image (Root_Id : Natural; Current_Depth : Positive)
   with Pre => Is_Initialized;

end Imager;
