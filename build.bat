del rom\output.gba
cp rom\speed.gba rom\output.gba
armips.exe asm\DecompressedGfx.asm
armips.exe asm\VariableWidthFont.asm
armips.exe asm\SmallVWF.asm
armips.exe asm\FixStatsMenu.asm
Atlas -d stdout rom\output.gba script\tf2_script_000.txt
pause