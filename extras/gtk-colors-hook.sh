#!/bin/bash
# Regenera ~/.config/gtk-4.0/gtk.css con la paleta del tema activo de Omarchy.
# Instalar con: omarchy hook install theme-set /ruta/a/gtk-colors.sh
# $1 contiene el slug del tema (no se usa: se lee el tema actual en disco).
set -u

COLORS="$HOME/.local/state/omarchy/current/theme/colors.toml"
[[ -f $COLORS ]] || exit 0

c() { # color del tema con fallback
  omarchy-theme-color --file "$COLORS" "$1" "${2:-}" 2>/dev/null
}

BG=$(c background "#1e1e1e")
FG=$(c foreground "#ffffff")
DBG=$(c dark_background "$BG")
CARD=$(c lighter_background "$BG")
ACC=$(c accent "$FG")
MODE=$(c mode "dark")

[[ $BG =~ ^#[0-9A-Fa-f]{6}$ && $FG =~ ^#[0-9A-Fa-f]{6}$ ]] || exit 0

mkdir -p "$HOME/.config/gtk-4.0"
cat >"$HOME/.config/gtk-4.0/gtk.css" <<EOF
/* Generado por el hook theme-set de Omarchy (gtk-colors.sh).
   Colores libadwaita del tema activo: $MODE. Regenerar: omarchy theme set <tema>. */
@define-color accent_color $ACC;
@define-color accent_bg_color $ACC;
@define-color accent_fg_color $BG;
@define-color window_bg_color $BG;
@define-color window_fg_color $FG;
@define-color view_bg_color $BG;
@define-color view_fg_color $FG;
@define-color headerbar_bg_color $DBG;
@define-color headerbar_fg_color $FG;
@define-color sidebar_bg_color $DBG;
@define-color sidebar_fg_color $FG;
@define-color secondary_sidebar_bg_color $DBG;
@define-color secondary_sidebar_fg_color $FG;
@define-color card_bg_color $CARD;
@define-color popover_bg_color $DBG;
EOF
