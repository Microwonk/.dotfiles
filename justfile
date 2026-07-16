[group('helix')]
install-forge:
    cd helix && cargo xtask steel

[group('helix')]
install-helix:
    cd helix && HELIX_DISABLE_AUTO_GRAMMAR_BUILD=true cargo install \
        --profile opt \
        --config 'build.rustflags="-C target-cpu=native"' \
        --path helix-term \
        --locked

[group('helix')]
install-helix-plugins:
    forge pkg install --git https://github.com/mattwparas/helix-config.git
    forge pkg install --git https://github.com/Ra77a3l3-jar/forest.hx.git
    forge pkg install --git https://github.com/Ra77a3l3-jar/oil.hx.git
