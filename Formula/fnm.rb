class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.22.4.tar.gz"
  sha256 "36db29208285d94e271809fc9ae8df9e5e51bcb1dbfc3fa7a2d3e5daeb873204"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url "https://github.com/Schniz/fnm/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6fcc2543c804fb12bdc67c97ed36e614d194b633ba167e1429ea3eb1c5ee2db7" => :catalina
    sha256 "ec18cec1cf9b7c66a2d536649a73ac8951a6d092808fbf44d446aa40f9fa548b" => :mojave
    sha256 "856837b496e77c6dfd5dd9b59382de0e93ea2f1a73617557a4edd1cada394958" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=zsh")
  end

  test do
    system("#{bin}/fnm", "install", "12.0.0")
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end
