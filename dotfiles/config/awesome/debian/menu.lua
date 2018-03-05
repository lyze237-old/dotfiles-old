-- automatically generated file. Do not edit (see /usr/share/doc/menu/html)

module("debian.menu")

Debian_menu = {}

Debian_menu["Debian_Applications_Accessibility"] = {
	{"Xmag","xmag"},
}
Debian_menu["Debian_Applications_Editors"] = {
	{"Xedit","xedit"},
}
Debian_menu["Debian_Applications_Graphics"] = {
	{"The GIMP","/usr/bin/gimp","/usr/share/pixmaps/gimp.xpm"},
	{"X Window Snapshot","xwd | xwud"},
}
Debian_menu["Debian_Applications_Network_Communication"] = {
	{"Telnet", "x-terminal-emulator -e ".."/usr/bin/telnet.netkit"},
	{"weechat", "x-terminal-emulator -e ".."/usr/bin/weechat","/usr/share/pixmaps/weechat.xpm"},
	{"Xbiff","xbiff"},
}
Debian_menu["Debian_Applications_Network_Web_Browsing"] = {
	{"w3m", "x-terminal-emulator -e ".."/usr/bin/w3m /usr/share/doc/w3m/MANUAL.html"},
}
Debian_menu["Debian_Applications_Network"] = {
	{ "Communication", Debian_menu["Debian_Applications_Network_Communication"] },
	{ "Web Browsing", Debian_menu["Debian_Applications_Network_Web_Browsing"] },
}
Debian_menu["Debian_Applications_Science_Mathematics"] = {
	{"Bc", "x-terminal-emulator -e ".."/usr/bin/bc"},
	{"Xcalc","xcalc"},
}
Debian_menu["Debian_Applications_Science"] = {
	{ "Mathematics", Debian_menu["Debian_Applications_Science_Mathematics"] },
}
Debian_menu["Debian_Applications_Shells"] = {
	{"Bash", "x-terminal-emulator -e ".."/bin/bash --login"},
	{"Dash", "x-terminal-emulator -e ".."/bin/dash -i"},
	{"fish", "x-terminal-emulator -e ".."/usr/bin/fish"},
	{"Sh", "x-terminal-emulator -e ".."/bin/sh --login"},
}
Debian_menu["Debian_Applications_Sound"] = {
	{"ncmpcpp", "x-terminal-emulator -e ".."/usr/bin/ncmpcpp"},
	{"pavucontrol","/usr/bin/pavucontrol"},
}
Debian_menu["Debian_Applications_System_Administration"] = {
	{"Debian Task selector", "x-terminal-emulator -e ".."su-to-root -c tasksel"},
	{"Editres","editres"},
	{"Xclipboard","xclipboard"},
	{"Xfontsel","xfontsel"},
	{"Xkill","xkill"},
	{"Xrefresh","xrefresh"},
}
Debian_menu["Debian_Applications_System_Hardware"] = {
	{"Xvidtune","xvidtune"},
}
Debian_menu["Debian_Applications_System_Monitoring"] = {
	{"Pstree", "x-terminal-emulator -e ".."/usr/bin/pstree.x11","/usr/share/pixmaps/pstree16.xpm"},
	{"Top", "x-terminal-emulator -e ".."/usr/bin/top"},
	{"Xconsole","xconsole -file /dev/xconsole"},
	{"Xev","x-terminal-emulator -e xev"},
	{"Xload","xload"},
}
Debian_menu["Debian_Applications_System"] = {
	{ "Administration", Debian_menu["Debian_Applications_System_Administration"] },
	{ "Hardware", Debian_menu["Debian_Applications_System_Hardware"] },
	{ "Monitoring", Debian_menu["Debian_Applications_System_Monitoring"] },
}
Debian_menu["Debian_Applications_Viewers"] = {
	{"Xditview","xditview"},
}
Debian_menu["Debian_Applications"] = {
	{ "Accessibility", Debian_menu["Debian_Applications_Accessibility"] },
	{ "Editors", Debian_menu["Debian_Applications_Editors"] },
	{ "Graphics", Debian_menu["Debian_Applications_Graphics"] },
	{ "Network", Debian_menu["Debian_Applications_Network"] },
	{ "Science", Debian_menu["Debian_Applications_Science"] },
	{ "Shells", Debian_menu["Debian_Applications_Shells"] },
	{ "Sound", Debian_menu["Debian_Applications_Sound"] },
	{ "System", Debian_menu["Debian_Applications_System"] },
	{ "Viewers", Debian_menu["Debian_Applications_Viewers"] },
}
Debian_menu["Debian_CrossOver"] = {
	{"CrossOver","/opt/cxoffice/bin/crossover","/opt/cxoffice/share/icons/32x32/crossover.png"},
	{"Uninstall CrossOver Linux","/opt/cxoffice/bin/cxuninstall","/opt/cxoffice/share/icons/32x32/cxuninstall.png"},
}
Debian_menu["Debian_Games_Toys"] = {
	{"Oclock","oclock"},
	{"Redshift","redshift-gtk"},
	{"Xclock (analog)","xclock -analog"},
	{"Xclock (digital)","xclock -digital -update 1"},
	{"Xeyes","xeyes"},
	{"Xlogo","xlogo"},
}
Debian_menu["Debian_Games"] = {
	{ "Toys", Debian_menu["Debian_Games_Toys"] },
}
Debian_menu["Debian_Help"] = {
	{"Info", "x-terminal-emulator -e ".."info"},
	{"Xman","xman"},
}
Debian_menu["Debian_Windows_Applications_CLIP_STUDIO"] = {
	{"CLIP STUDIO PAINT","\"/home/lyze/.cxoffice/ClipStudioPaint/desktopdata/cxmenu/StartMenu.C^5E3A_ProgramData_Microsoft_Windows_Start^2BMenu/Programs/CLIP+STUDIO/CLIP+STUDIO+PAINT.lnk\"","/home/lyze/.cxoffice/ClipStudioPaint/windata/cxmenu/icons/hicolor/32x32/apps/5AC0_CLIPStudioPaint.0.png"},
	{"Uninstall Material","\"/home/lyze/.cxoffice/ClipStudioPaint/desktopdata/cxmenu/StartMenu.C^5E3A_ProgramData_Microsoft_Windows_Start^2BMenu/Programs/CLIP+STUDIO/Uninstall+Material.lnk\"","/home/lyze/.cxoffice/ClipStudioPaint/windata/cxmenu/icons/hicolor/32x32/apps/DBA4_MaterialUninstaller.0.png"},
}
Debian_menu["Debian_Windows_Applications"] = {
	{ "CLIP STUDIO", Debian_menu["Debian_Windows_Applications_CLIP_STUDIO"] },
}
Debian_menu["Debian"] = {
	{ "Applications", Debian_menu["Debian_Applications"] },
	{ "CrossOver", Debian_menu["Debian_CrossOver"] },
	{ "Games", Debian_menu["Debian_Games"] },
	{ "Help", Debian_menu["Debian_Help"] },
	{ "Windows Applications", Debian_menu["Debian_Windows_Applications"] },
}
