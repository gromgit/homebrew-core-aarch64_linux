class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.7.1.tar.gz"
  sha256 "57d05d806ff95780fc196a5d20d0830b0b9437e3cc84a3735905446e3c0a3860"

  bottle do
    cellar :any_skip_relocation
    sha256 "e01171d8d54234b0bf6b01c694c44a0fdbf9f2a754522c22ffe720d7c912837f" => :catalina
    sha256 "8cc0d2bb6554d5f468b772fb3244d334638a9031b165e1a894423261b2684ab4" => :mojave
    sha256 "0f5455586f29a4189272fc2a768fa485b6f1d41bcb3e55f157b1677f84b5f18e" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on :xcode => :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/master/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/master/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
