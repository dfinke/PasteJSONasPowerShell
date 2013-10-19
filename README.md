Paste JSON as PowerShell
===
Use *PowerShell* to pull *JSON* from the clipboard, convert it to PowerShell functions and then *auto-paste* into an ISE file.

### Installing

To install in your personal modules folder (e.g. ~\Documents\WindowsPowerShell\Modules), run:

```powershell
iex (new-object System.Net.WebClient).DownloadString('https://raw.github.com/dfinke/PasteJSONasPowerShell/master/Install.ps1')
```

### Using

![Image](https://raw.github.com/dfinke/PasteJSONasPowerShell/master/images/PastJSONAsPowerShell.gif)