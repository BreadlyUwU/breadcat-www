#!/bin/env fish
# If you don't know what the hell is fish: https://fishshell.com

# Little tiny so smoool script to use when building a Zola website for Neocities
# It will simply call Zola to build the website and quickly rename the output "404.html" to "not_found.html"
# before uploading the full "public" folder to Neocities (just make sure you did set-up your account on the cli program).
# That's all.

set -g NEOCITIES_UPLOAD true # If set to anything but "true", the script will build the website, but not uploading it
set -g NEOCITIES_COMMAND 'neocities push public/ --prune' # Edit this variable if you use OpenSUSE (ifykyk)
set -g ZOLA_COMMAND 'zola build'

# Checking if the script is running inside the good folder
echo "- Checking current folder's structure"
if test -f config.toml; and test -d content; and test -d sass; and test -d static; and test -d templates
    echo "✅ Current folder's looking good, continuing…" \n
    echo "- Now asking Zola to do all the work"
    eval $ZOLA_COMMAND
    if test $status -eq 0
        echo "✅ Building succeded" \n
        echo "- Now renaming '404.html' to 'not_found.html'"
        eval 'mv -v public/404.html public/not_found.html'
        if test -f public/not_found.html
            echo "✅ Renaming done" \n
            if test $NEOCITIES_UPLOAD = true
                echo "- Now starting the upload of the big baby"
                eval $NEOCITIES_COMMAND
                if test $status -eq 0
                    echo "✅ Perfect"
                    return 0 & exit
                else
                    echo "🛑 The upload has failled, check the neocities-cli output above to see what's wrong :("
                    return 1 & exit
                end
            else
                echo "🛈 An unexpected value has been set to the 'NEOCITIES_UPLOAD' variable (was expecting a 'true' string)."
                echo "At the script's root, set the variable 'NEOCITIES_UPLOAD' to 'true' if you want the script to continue and upload your website."
            end
        else
            echo \n "🛑 This is a *Bruh* moment, the renaming has failled for some reason, exiting."
            return 1 & exit
        end
    else
        echo \n "🛑 Something went wrong when building the website, exiting now before doing anything dramatic"
        return 1 & exit
    end
else
    echo \n "🛑 The current path doesn't look like a Zola root folder, exiting now."
    return 1 & exit
end
