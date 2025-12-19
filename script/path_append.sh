path_append() {
    local tgt=${1:-}
    e_l="export PATH=\"$tgt:\$PATH\""
    grep -F "$e_l" $HOME/.zshrc  || echo "$e_l" >> $HOME/.zshrc
    source $HOME/.zshrc &>/dev/null
}
source_append() {
    local tgt=${1:-}
    s_l="source $tgt"

    grep -F "$s_l" $HOME/.zshrc || echo "$s_l" >> $HOME/.zshrc
    source $HOME/.zshrc &>/dev/null
}