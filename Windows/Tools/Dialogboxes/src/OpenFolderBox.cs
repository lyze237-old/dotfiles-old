using System;
using System.IO;
using System.Windows.Forms;


namespace RobvanderWoude
{
	class OpenFolderBox
	{
		static string progver = "1.01";

		[STAThread]
		static int Main( string[] args )
		{
			try
			{
				using ( FolderBrowserDialog dialog = new FolderBrowserDialog( ) )
				{
					string startfolder = Directory.GetCurrentDirectory( );
					string description = "OpenFolderBox,  Version " + progver;
					bool startfolderset = false;
					bool descriptionset = false;
					bool allowmakedir = false;

					if ( args.Length > 3 )
					{
						return WriteError( "Too many command line arguments" );
					}

					if ( args.Length > 0 )
					{
						foreach ( string arg in args )
						{
							switch ( arg.ToUpper( ) )
							{
								case "/?":
									return WriteError( );
								case "/MD":
									allowmakedir = true;
									break;
								default:
									if ( startfolderset )
									{
										if ( descriptionset )
										{
											return WriteError( String.Format( "Invalid or duplicate command line argument \"{0}\"", arg ) );
										}
										description = arg.Replace( "\\n", "\n" ).Replace( "\\t", "\t" );
										descriptionset = true;
									}
									else
									{
										startfolder = arg;
										startfolderset = true;
										if ( !Directory.Exists( startfolder ) )
										{
											return WriteError( String.Format( "Invalid folder \"{0}\"", startfolder ) );
										}
									}
									break;
							}
						}
					}
					dialog.SelectedPath = startfolder;
					dialog.Description = description;
					dialog.ShowNewFolderButton = allowmakedir;
					if ( dialog.ShowDialog( ) == DialogResult.OK )
					{
						Console.WriteLine( dialog.SelectedPath );
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
			OpenFolderBox.exe,  Version 1.01
			Batch tool to present a Browse Folders Dialog and return the selected path

			Usage:  OPENFOLDERBOX  [ "startfolder"  [ "description" ] ]  [ /MD ]

			Where:  "startfolder"  is the initial folder the dialog will show on opening
			                       (default: current directory)
			        "description"  is the text above the dialog's tree view
			                       (default: program name and version)
			        /MD            display the "Make New Folder" button
			                       (default: hide the button)

			Notes:  Though the "Make New Folder" button is hidden by default, this does
			        not inhibit manipulating folders using right-click or Shift+F10.
			        The full path of the selected folder is written to Standard Output
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
			Console.Error.WriteLine( "OpenFolderBox.exe,  Version {0}", progver );
			Console.Error.WriteLine( "Batch tool to present a Browse Folders Dialog and return the selected path" );
			Console.Error.WriteLine( );

			Console.Error.Write( "Usage:  " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "OPENFOLDERBOX  [ \"startfolder\"  [ \"description\" ] ]  [ /MD ]" );
			Console.ResetColor( );

			Console.Error.WriteLine( );

			Console.Error.Write( "Where:  " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "\"startfolder\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( "  is the initial folder the dialog will show on opening" );

			Console.Error.WriteLine( "                       (default: current directory)" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "        \"description\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( "  is the text above the dialog's tree view" );

			Console.Error.WriteLine( "                       (default: \"OpenFolderBox,  Version {0}\")", progver );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "        /MD" );
			Console.ResetColor( );
			Console.Error.Write( "            display the \"" );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "M" );
			Console.ResetColor( );
			Console.Error.WriteLine( "ake New Folder\" button" );

			Console.Error.WriteLine( "                       (default: hide the button)" );
			Console.Error.WriteLine( );
			Console.Error.WriteLine( "Notes:  Though the \"Make New Folder\" button is hidden by default, this does" );
			Console.Error.WriteLine( "        not inhibit manipulating folders using right-click or Shift+F10." );
			Console.Error.WriteLine( "        The full path of the selected folder is written to Standard Output" );
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
