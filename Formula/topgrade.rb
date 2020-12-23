class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.1.1.tar.gz"
  sha256 "83f24e41a583ffa1b07748b9852a8761c5e4320d3006164448b9d93efba4b405"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "03ad4c55d161e794eebc21d4148ebb0c6ae3c6441eff70f1bf736e5dbe287704" => :big_sur
    sha256 "18adf109b719ca194203f371b7e26ab69fe5078b65f3643467488c007fc8009a" => :catalina
    sha256 "d43f6d94667974fdb90c5475748e34c9673a3b3dfdbbdca195410b1d1ef07d03" => :mojave
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
