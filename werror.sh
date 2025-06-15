#!/bin/bash
for a in $(grep -RIl \\-Werror $(pwd)); do echo $a; sed -i 's/-Werror=/-Wno-/g' $a; sed -i 's/-Werror-/-Wno-/g' $a; sed -i 's/-Werror//g' $a; done
