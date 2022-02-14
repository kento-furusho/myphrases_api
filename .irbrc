# コンソール起動時
if defined? Rails::Console
 # Hirb.enableの自動化
 Hirb.enable if defined? Hirb
end
