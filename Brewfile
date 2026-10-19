# Aggregate for direct `brew bundle` users; install.sh runs these in phases.
# Keep shell + Warp ahead of general apps in both entry points.
["setup/Brewfile.shell", "setup/Brewfile.warp", "setup/Brewfile.apps"].each do |relative|
  path = File.join(__dir__, relative)
  instance_eval(File.read(path), path)
end
# Optional: setup/Brewfile.desktop and setup/Brewfile.app-store.
