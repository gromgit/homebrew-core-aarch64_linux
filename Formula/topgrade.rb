class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.7.0.tar.gz"
  sha256 "7e91995682380dc2a32375c7f5054f8c805fd6c47a06cb1432a315afee5a8405"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b55d9278a597c04fe4d599ba242fb0f90d68fc916343278867185f7ac403964" => :catalina
    sha256 "ec4524bd61765ad656f7ca46df206f32b76ab27594d5e945b022d63ab923a3b3" => :mojave
    sha256 "b89dbe4f4f8300cd1d1ffbb2082e1cb82ab027cdfb6e27497807a88c6051fe71" => :high_sierra
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
