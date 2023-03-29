#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if (%0% = 0) {
	MsgBox, , , Please drag and drop your XML files on top of this application.
	ExitApp
}

Loop, %0%
{
	FileName := %A_Index%
	FullFileName := GetFullFileName(FileName)
	FileRead, FileContents, %FullFileName%
	TextOut =
	LineNum = 1

	Loop, parse, FileContents, `n
	{
		if (InStr(A_LoopField, "<LineNum>"))
		{
			RemoveNumbers := RegExReplace(A_LoopField, "[0-9]+", LineNum)
			TextOut = %TextOut%%RemoveNumbers%`n
			LineNum++
		}
		else
		{
			TextOut = %TextOut%%A_LoopField%`n
		}
	}	
	TextOut := SubStr(TextOut, 1, -1)
	File := FileOpen(FullFileName, "w")
	File.Write(TextOut)
}
MsgBox,, Complete, Success! Converted <LineNum> lines.

GetFullFileName(ShortPath) {
	VarSetCapacity(LongPath, 260, 0), DllCall("GetLongPathName", Str, ShortPath, Str, LongPath, UInt, 260)
	Return LongPath
}