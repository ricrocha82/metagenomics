name="HP01_ATR_MHB_SM_S14.36"
newname=$(echo "$name" | awk '{sub(/\.[0-9]+$/, "")} 1')
echo "$newname"