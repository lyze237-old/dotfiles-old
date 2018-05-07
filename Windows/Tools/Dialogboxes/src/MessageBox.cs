using System;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using System.Windows.Forms;


namespace RobvanderWoude
{
	class MessageBox
	{
		public static string progver = "1.28";
		public static bool timeoutelapsed = false;


		static int Main( string[] args )
		{
			#region Initialize Variables

			string defaultmessage = DefaultMessage( );
			string message = defaultmessage;
			string defaulttitle = String.Format( "MessageBox {0}", progver );
			string title = defaulttitle;
			MessageBoxButtons buttons = MessageBoxButtons.OK;
			MessageBoxIcon icon = MessageBoxIcon.Information;
			MessageBoxDefaultButton defaultbutton = MessageBoxDefaultButton.Button1;
			MessageBoxOptions option = MessageBoxOptions.DefaultDesktopOnly;
			bool escapemessage = true;
			DialogResult result;
			int timeout = 0;
			int rc = 1;

			#endregion Initialize Variables


			#region Command Line Parsing

			if ( args.Length == 1 && args[0] == "/?" )
			{
				Console.Error.Write( message.Replace( "\n\n\t", "\n\t" ).Replace( "Usage:\n", "Usage:\t" ) );
				return 1;
			}

			if ( args.Length > 0 && args.Length < 8 )
			{
				if ( args.Length > 0 )
				{
					if ( escapemessage )
					{
						message = UnEscapeString( args[0] );
					}
					else
					{
						message = args[0];
					}
					rc = 0;
					if ( args.Length > 1 )
					{
						if ( escapemessage )
						{
							title = UnEscapeString( args[1] );
						}
						else
						{
							title = args[1];
						}
						if ( args.Length > 2 )
						{
							switch ( args[2].ToLower( ) )
							{
								case "abortretryignore":
									buttons = MessageBoxButtons.AbortRetryIgnore;
									break;
								case "ok":
									buttons = MessageBoxButtons.OK;
									break;
								case "okcancel":
									buttons = MessageBoxButtons.OKCancel;
									break;
								case "retrycancel":
									buttons = MessageBoxButtons.RetryCancel;
									break;
								case "yesno":
									buttons = MessageBoxButtons.YesNo;
									break;
								case "yesnocancel":
									buttons = MessageBoxButtons.YesNoCancel;
									break;
								default:
									buttons = MessageBoxButtons.OK;
									rc = 1;
									break;
							}
							if ( args.Length > 3 )
							{
								switch ( args[3].ToLower( ) )
								{
									case "asterisk":
										icon = MessageBoxIcon.Asterisk;
										break;
									case "error":
										icon = MessageBoxIcon.Error;
										break;
									case "exclamation":
										icon = MessageBoxIcon.Exclamation;
										break;
									case "hand":
										icon = MessageBoxIcon.Hand;
										break;
									case "information":
										icon = MessageBoxIcon.Information;
										break;
									case "none":
										icon = MessageBoxIcon.None;
										break;
									case "question":
										icon = MessageBoxIcon.Question;
										break;
									case "stop":
										icon = MessageBoxIcon.Stop;
										break;
									case "warning":
										icon = MessageBoxIcon.Warning;
										break;
									default:
										icon = MessageBoxIcon.Warning;
										rc = 1;
										break;
								}
								if ( args.Length > 4 )
								{
									switch ( args[4].ToLower( ) )
									{
										case "":
										case "abort":
										case "button1":
										case "ok":
										case "yes":
											defaultbutton = MessageBoxDefaultButton.Button1;
											break;
										case "button2":
										case "no":
											defaultbutton = MessageBoxDefaultButton.Button2;
											break;
										case "button3":
										case "ignore":
											defaultbutton = MessageBoxDefaultButton.Button3;
											break;
										case "cancel":
											if ( args[2].ToLower( ) == "okcancel" || args[2].ToLower( ) == "retrycancel" )
											{
												defaultbutton = MessageBoxDefaultButton.Button2;
											}
											else // yesnocancel
											{
												defaultbutton = MessageBoxDefaultButton.Button3;
											}
											break;
										case "retry":
											if ( args[2].ToLower( ) == "abortretryignore" )
											{
												defaultbutton = MessageBoxDefaultButton.Button2;
											}
											else // retrycancel
											{
												defaultbutton = MessageBoxDefaultButton.Button1;
											}
											break;
										default:
											defaultbutton = MessageBoxDefaultButton.Button1;
											rc = 1;
											break;
									}
									if ( args.Length > 5 )
									{
										switch ( args[5].ToLower( ) )
										{
											case "":
											case "none":
												break;
											case "hideconsole":
												HideConsoleWindow( );
												break;
											case "noescape":
												escapemessage = false;
												break;
											case "rightalign":
												option = MessageBoxOptions.RightAlign;
												break;
											case "rtlreading":
												option = MessageBoxOptions.RtlReading;
												break;
											default: // try if 6th argument is timeout
												try
												{
													timeout = Convert.ToInt32( args[5] ) * 1000;
													if ( timeout < 1000 )
													{
														rc = 1;
													}
												}
												catch ( FormatException )
												{
													rc = 1;
												}
												break;
										}
										if ( args.Length == 7 )
										{
											try
											{
												timeout = Convert.ToInt32( args[6] ) * 1000;
												if ( timeout < 1000 )
												{
													rc = 1;
												}
											}
											catch ( FormatException )
											{
												rc = 1;
											}
										}
									}
								}
							}
						}
					}
				}
			}

			#endregion Command Line Parsing


			if ( rc == 1 ) // command line error
			{
				ShowConsoleWindow( );
				message = defaultmessage;
				title = defaulttitle;
				buttons = MessageBoxButtons.OK;
				icon = MessageBoxIcon.Warning;
				defaultbutton = MessageBoxDefaultButton.Button1;
				// Display the help text in a message box AND in the console
				Console.Error.Write( message.Replace( "\n\n\t", "\n\t" ).Replace( "Usage:\n", "Usage:\t" ) );
			}

			if ( rc == 0 && timeout > 0 )
			{
				// MessageBoxOptions.ServiceNotification allows interactive use by SYSTEM account (or any other account not currently logged in)
				result = AutoClosingMessageBox.Show( message, title, timeout, buttons, icon, defaultbutton, option | MessageBoxOptions.ServiceNotification );
				if ( timeoutelapsed )
				{
					Console.WriteLine( "timeout" );
					return 3;
				}
			}
			else
			{
				result = System.Windows.Forms.MessageBox.Show( message, title, buttons, icon, defaultbutton, option | MessageBoxOptions.ServiceNotification );
			}
			Console.WriteLine( result.ToString( ).ToLower( ) );
			return rc;
		}


		static string DefaultMessage( )
		{
			string message = "MessageBox.exe,  Version " + progver + "\n";
			message += "Batch tool to show a message in a MessageBox and return the caption\nof the button that is clicked\n\n";
			message += "Usage:\nMessageBox \"message\" \"title\" buttons icon default [option] timeout\n\n";
			message += "Where:\tbuttons\t\"AbortRetryIgnore\", \"OK\", \"OKCancel\",\n";
			message += "\t\t\"RetryCancel\", \"YesNo\" or \"YesNoCancel\"\n";
			message += "\ticon\t\"Asterisk\", \"Error\", \"Exclamation\", \"Hand\",\n";
			message += "\t\t\"Information\", \"None\", \"Question\", \"Stop\"\n";
			message += "\t\tor \"Warning\"\n";
			message += "\tdefault\t\"Button1\", \"Button2\" or \"Button3\" or the\n\t\tdefault button's (English) caption\n";
			message += "\toption\t\"HideConsole\", \"NoEscape\", \"RightAlign\",\n\t\t\"RtlReading\", \"None\" or \"\"\n";
			message += "\ttimeout\ttimeout interval in seconds\n\n";
			message += "Notes:\tWhereas all arguments are optional, each argument requires\n\tall preceding arguments, i.e. icon requires \"message\", \"title\"\n\tand buttons, but not necessarily default, option and timeout.\n\n";
			message += "\tUsing the \"HideConsole\" option will hide the console\n\twindow permanently, thereby disabling all console based\n\tuser interaction (e.g. \"ECHO\" and \"PAUSE\").\n\tIt is meant to be used in scripts that run \"hidden\"\n\tthemselves, e.g. VBScript with the WScript.exe interpreter.\n\tDo not use this option in a batch file unless hiding\n\tthe console window permanently is intended.\n\n";
			message += "\tLinefeeds (\\n or \\012 and/or \\r or \\015), tabs (\\t or \\007),\n\tsinglequotes (' or \\047) and doublequotes (\\\" or \\042)\n\tare allowed in the message string.\n";
			message += "\tEscaped Unicode characters (e.g. \"\\u5173\" for \"\u5173\")\n\tare allowed in the message string and in the title.\n";
			message += "\tUse option \"NoEscape\" to disable all character escaping\n\texcept doublequotes (useful when displaying a path).\n\n";
			message += "\tThe (English) caption of the button that was clicked\n\tis returned as text to Standard Output (in lower case),\n\tor \"timeout\" if the timeout interval expired.\n\n";
			message += "\tCode to hide console by Anthony on:\n\thttp://stackoverflow.com/a/15079092\n\n";
			message += "\tMessageBox timeout based on code by DmitryG on:\n\thttp://stackoverflow.com/a/14522952\n\n";
			message += "\tNote that when using the timeout feature, A window\n\twith the current MessageBox's TITLE will be closed,\n\tnot necessarily the current MessageBox. To prevent\n\tclosing the wrong MessageBox, use unique titles.\n\n";
			message += "\tThe return code of the program is 0 if a button was clicked,\n\t1 in case of (command line) errors, 3 if the timeout expired.\n\n";
			message += "Written by Rob van der Woude\nhttp://www.robvanderwoude.com\n";
			return message;
		}


		static string UnEscapeString( string message )
		{
			// Unescaping tabs, linefeeds and quotes
			message = message.Replace( "\\n", "\n" );
			message = message.Replace( "\\r", "\r" );
			message = message.Replace( "\\t", "\t" );
			message = message.Replace( "\\007", "\t" );
			message = message.Replace( "\\012", "\n" );
			message = message.Replace( "\\015", "\r" );
			message = message.Replace( "\\042", "\"" );
			message = message.Replace( "\\047", "'" );
			// Unescaping Unicode, technique by "dtb" on StackOverflow.com: http://stackoverflow.com/a/8558748
			message = Regex.Replace( message, @"\\[Uu]([0-9A-Fa-f]{4})", m => char.ToString( (char) ushort.Parse( m.Groups[1].Value, NumberStyles.AllowHexSpecifier ) ) );
			return message;
		}


		#region Hide or Show Console
		// Source: http://stackoverflow.com/a/15079092

		public static void ShowConsoleWindow( )
		{
			var handle = GetConsoleWindow( );

			if ( handle == IntPtr.Zero )
			{
				AllocConsole( );
			}
			else
			{
				ShowWindow( handle, SW_SHOW );
			}
		}


		public static void HideConsoleWindow( )
		{
			var handle = GetConsoleWindow( );

			ShowWindow( handle, SW_HIDE );
		}


		[DllImport( "kernel32.dll", SetLastError = true )]
		static extern bool AllocConsole( );


		[DllImport( "kernel32.dll" )]
		static extern IntPtr GetConsoleWindow( );


		[DllImport( "user32.dll" )]
		static extern bool ShowWindow( IntPtr hWnd, int nCmdShow );


		const int SW_HIDE = 0;
		const int SW_SHOW = 5;

		#endregion Hide or Show Console


		#region Timed MessageBox

		// Timed MessageBox based on code by DmitryG on StackOverflow.com
		// http://stackoverflow.com/a/14522952
		public class AutoClosingMessageBox
		{
			System.Threading.Timer _timeouttimer;
			string _caption;
			DialogResult _result;


			AutoClosingMessageBox( string message, string title, int timeout, MessageBoxButtons buttons = MessageBoxButtons.OK, MessageBoxIcon icon = MessageBoxIcon.None, MessageBoxDefaultButton defaultbutton = MessageBoxDefaultButton.Button1, MessageBoxOptions option = MessageBoxOptions.DefaultDesktopOnly )
			{
				_caption = title;
				_timeouttimer = new System.Threading.Timer( OnTimerElapsed, null, timeout, System.Threading.Timeout.Infinite );

				using ( _timeouttimer )
				{
					_result = System.Windows.Forms.MessageBox.Show( message, title, buttons, icon, defaultbutton, option | MessageBoxOptions.ServiceNotification );
				}
			}


			public static DialogResult Show( string message, string title, int timeout, MessageBoxButtons buttons = MessageBoxButtons.OK, MessageBoxIcon icon = MessageBoxIcon.None, MessageBoxDefaultButton defaultbutton = MessageBoxDefaultButton.Button1, MessageBoxOptions option = MessageBoxOptions.DefaultDesktopOnly )
			{
				return new AutoClosingMessageBox( message, title, timeout, buttons, icon, defaultbutton, option | MessageBoxOptions.ServiceNotification )._result;
			}


			void OnTimerElapsed( object state )
			{
				IntPtr mbWnd = FindWindow( "#32770", _caption ); // lpClassName is #32770 for MessageBox
				if ( mbWnd != IntPtr.Zero )
				{
					SendMessage( mbWnd, WM_CLOSE, IntPtr.Zero, IntPtr.Zero );
				}
				_timeouttimer.Dispose( );
				timeoutelapsed = true;
			}


			const int WM_CLOSE = 0x0010;


			[System.Runtime.InteropServices.DllImport( "user32.dll", SetLastError = true )]
			static extern IntPtr FindWindow( string lpClassName, string lpWindowName );


			[System.Runtime.InteropServices.DllImport( "user32.dll", CharSet = System.Runtime.InteropServices.CharSet.Auto )]
			static extern IntPtr SendMessage( IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam );
		}

		#endregion Timed MessageBox
	}
}
