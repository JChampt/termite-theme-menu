# termite-theme-menu
A termite terminal theme and bg transparency selection menu

**Requires:**

[termite](https://github.com/thestinger/termite)

[rofi](https://github.com/davatorium/rofi)

[base16-termite](https://github.com/khamer/base16-termite)

To install, install termite and rofi, make sure your have a termite config file in your $HOME/.config/termite, then clone this repo and make the script executable and add the theme files you want to use.

There are quite a few themes, so I break them up into favthemes and all themes.  I am including the empty folders so the end user can drop the themes they want to use in each folder.  

I suggest renaming the base16 themes to remove the prefix and suffix of the theme to make the menues a bit more readible.  I used rename for this:

    rename base16- '' *
    rename .config '' *
