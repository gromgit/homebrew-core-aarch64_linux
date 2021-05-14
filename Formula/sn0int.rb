class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.21.0.tar.gz"
  sha256 "104444dacfe7548e6ce8b90f30029d855d3ccd25d216fba72c0dc12e28bdf078"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1d8a480cd68568dd4a197570492ddc34cba7a44e7951cab8c330c34c73fcdf4e"
    sha256 cellar: :any, big_sur:       "1673f725ed5100673a7e9694eb9139ff9fc84113ee442f2c3f4635eef5f875e9"
    sha256 cellar: :any, catalina:      "6b285fcc6e0aedef9b7dd2316dd0de3e98b9767115feaddb13bc461119a830f1"
    sha256 cellar: :any, mojave:        "5ad4ae1cc622e95afd6e981f1147d4483b06860da84e97512a0464a1de054a8b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/1/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
