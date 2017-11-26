FNAME="workspace-$(date +%m.%d_%H-%M-%S_%Y).tar.gz"

tar -czpf ~/storage/backups/workspace-backups/$FNAME ~/workspace

echo "Copying to local /tmp..."
cp -v ~/storage/backups/workspace-backups/$FNAME /tmp &
echo "Copying to micro-server..."
scp ~/storage/backups/workspace-backups/$FNAME micro-server:backups/workspace-backups &
echo "Copying to bananapi..."
scp ~/storage/backups/workspace-backups/$FNAME bananapi:/mnt/usb1/backups/workspace-backups &

echo "All done!" 
