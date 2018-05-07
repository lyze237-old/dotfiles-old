using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Windows.Forms;


namespace RobvanderWoude
{
	class OpenFile
	{
		static string progver = "1.01";

		[STAThread]
		static int Main( string[] args )
		{
			try
			{
				using ( OpenFileDialog dialog = new OpenFileDialog( ) )
				{
					string filter = "All files (*.*)|*.*";
					string folder = Directory.GetCurrentDirectory( );
					string title = "OpenFileBox,  Version " + progver;
					if ( args.Length > 3 )
					{
						return WriteError( "Too many command line arguments" );
					}
					if ( args.Length > 0 )
					{
						filter = args[0];
						if ( filter == "/?" )
						{
							return WriteError( );
						}
						// If only "*.ext" is specified, use "ext files (*.ext)|*.ext" instead
						if ( Regex.IsMatch( filter, @"^\*\.(\*|\w+)$" ) )
						{
							string ext = filter.Substring( 2 ).ToLower( );
							if ( ext == "*" )
							{
								filter = "All files (*." + ext + ")|*." + ext;
							}
							else
							{
								filter = ext + " files (*." + ext + ")|*." + ext;
							}
						}
						// Append "All files" filter if not specified
						if ( !Regex.IsMatch( filter, @"All files\s+\(\*\.\*\)\|\*\.\*", RegexOptions.IgnoreCase ) )
						{
							if ( String.IsNullOrWhiteSpace( filter ) )
							{
								filter = "All files (*.*)|*.*";
							}
							else
							{
								filter = filter + "|All files (*.*)|*.*";
							}
						}
						// Optional second command line argument is start folder
						if ( args.Length > 1 )
						{
							folder = args[1];
							if ( !Directory.Exists( folder ) )
							{
								return WriteError( "Invalid folder \"" + folder + "\"" );
							}
							// Optional third command line argument is dialog title
							if ( args.Length > 2 )
							{
								title = args[2];
							}
						}
					}
					dialog.Filter = filter;
					dialog.FilterIndex = 1;
					dialog.InitialDirectory = folder;
					dialog.Title = title;
					dialog.RestoreDirectory = true;
					if ( dialog.ShowDialog( ) == DialogResult.OK )
					{
						Console.WriteLine( dialog.FileName );
						return 0;
					}
					else
					{
						// Cancel was clicked
						return 2;
					}
				}
			}
			catch ( Exception e )
			{
				return WriteError( e.Message );
			}
		}

		public static int WriteError( string errorMessage = null )
		{
			/*
			OpenFileBox.exe,  Version 1.01
			Batch tool to present an Open File Dialog and return the selected file path

			Usage:  OPENFILEBOX  [ "filetypes"  [ "startfolder"  [ "title" ] ] ]

			Where:  filetypes    file type(s) in format "description (*.ext)|*.ext"
			                     or just "*.ext" (default: "All files (*.*)|*.*")
			        startfolder  the initial folder the dialog will show on opening
			                     (default: current directory)
			        title        the caption in the dialog's title bar
			                     (default: program name and version)

			Notes:  Multiple file types can be used for the filetypes filter; use "|" as a
			        separator, e.g. "PDF files (*.pdf)|*.txt|Word documents (*.doc)|*.doc".
			        If the filetypes filter is in "*.ext" format, "ext files (*.ext)|*.ext"
			        will be used instead.
			        Unless the filetypes filter specified is "All files (*.*)|*.*" or
			        "*.*", the filetypes filter "|All files (*.*)|*.*" will be appended.
			        The full path of the selected file is written to Standard Output
			        if OK was clicked, or an empty string if Cancel was clicked.
			        The return code will be 0 on success, 1 in case of (command line)
			        errors, or 2 if Cancel was clicked.

			Written by Rob van der Woude
			http://www.robvanderwoude.com
			*/

			if ( !string.IsNullOrWhiteSpace( errorMessage ) )
			{
				Console.Error.WriteLine( );
				Console.ForegroundColor = ConsoleColor.Red;
				Console.Error.Write( "ERROR: " );
				Console.ForegroundColor = ConsoleColor.White;
				Console.Error.WriteLine( errorMessage );
				Console.ResetColor( );
			}
			Console.Error.WriteLine( );
			Console.Error.WriteLine( "OpenFileBox.exe,  Version {0}", progver );
			Console.Error.WriteLine( "Batch tool to present an Open File Dialog and return the selected file path" );
			Console.Error.WriteLine( );
			Console.Error.Write( "Usage:  " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "OPENFILEBOX  [ \"filetypes\"  [ \"startfolder\"  [ \"title\" ] ] ]" );
			Console.ResetColor( );
			Console.Error.WriteLine( );
			Console.Error.Write( "Where:  " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "filetypes" );
			Console.ResetColor( );
			Console.Error.Write( "    file type(s) in format " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "\"description (*.ext)|*.ext\"" );
			Console.ResetColor( );
			Console.Error.Write( "                     or just " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "\"*.ext\"" );
			Console.ResetColor( );
			Console.Error.Write( " (default: " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "\"All files (*.*)|*.*\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( ")" );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "        startfolder" );
			Console.ResetColor( );
			Console.Error.WriteLine( "  the initial folder the dialog will show on opening" );
			Console.Error.WriteLine( "                     (default: current directory)" );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "        title" );
			Console.ResetColor( );
			Console.Error.WriteLine( "        the caption in the dialog's title bar" );
			Console.Error.WriteLine( "                     (default: \"OpenFileBox,  Version {0})\"", progver );
			Console.Error.WriteLine( );
			Console.Error.WriteLine( "Notes:  Multiple file types can be used for the filetypes filter; use \"|\" as a" );
			Console.Error.Write( "        separator, e.g. " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "\"PDF files (*.pdf)|*.txt|Word documents (*.doc)|*.doc\"." );
			Console.ResetColor( );
			Console.Error.Write( "        If the filetypes filter is in " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "\"*.ext\"" );
			Console.ResetColor( );
			Console.Error.Write( " format, " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "\"ext files (*.ext)|*.ext\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( "        will be used instead." );
			Console.Error.Write( "        Unless the filetypes filter specified is " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "\"All files (*.*)|*.*\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( " or" );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "        \"*.*\"" );
			Console.ResetColor( );
			Console.Error.Write( ", the filetypes filter " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "\"|All files (*.*)|*.*\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( " will be appended." );
			Console.Error.WriteLine( "        The full path of the selected file is written to Standard Output" );
			Console.Error.WriteLine( "        if OK was clicked, or an empty string if Cancel was clicked." );
			Console.Error.WriteLine( "        The return code will be 0 on success, 1 in case of (command line)" );
			Console.Error.WriteLine( "        errors, or 2 if Cancel was clicked." );
			Console.Error.WriteLine( );
			Console.Error.WriteLine( "Written by Rob van der Woude" );
			Console.Error.WriteLine( "http://www.robvanderwoude.com" );
			return 1;
		}
	}
}
