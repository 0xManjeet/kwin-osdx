# Variables
PLUGIN_ID = kde-sd-osd
RX_SRC = desktop_rename
RX_DEST = /usr/local/bin/rx

.PHONY: all install install-osd install-rx uninstall

all: install

install: install-osd install-rx
	@echo ""
	@echo "======================================================"
	@echo "  Success! Installation complete."
	@echo "  Try it out in KRunner: rx <new desktop name>"
	@echo "======================================================"

install-osd:
	@echo "--> 1. Unloading script from KWin memory..."
	-qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "$(PLUGIN_ID)" > /dev/null 2>&1

	@echo "--> 2. Deleting old package to bypass KDE version checks..."
	-kpackagetool6 --type=KWin/Script -r $(PLUGIN_ID) > /dev/null 2>&1

	@echo "--> 3. Installing fresh code..."
	kpackagetool6 --type=KWin/Script -i .

	@echo "--> 4. Telling KWin to start the script back up..."
	qdbus6 org.kde.KWin /KWin reconfigure

install-rx:
	@echo "--> Installing rename script to $(RX_DEST) (will prompt for sudo password)..."
	sudo cp $(RX_SRC) $(RX_DEST)
	sudo chmod +x $(RX_DEST)

uninstall:
	@echo "--> Removing Custom OSD KWin Script..."
	-qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "$(PLUGIN_ID)" > /dev/null 2>&1
	-kpackagetool6 --type=KWin/Script -r $(PLUGIN_ID) > /dev/null 2>&1
	@echo "--> Removing $(RX_DEST)..."
	sudo rm -f $(RX_DEST)
	@echo "Uninstall complete."
