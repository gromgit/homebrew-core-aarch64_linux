class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.23.0.tar.gz"
  sha256 "778221f7309c03d74ed7aac2c6e552e325ab2a85e536029afa8b27d2fa5a22f1"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "9f073ff51580b262d00216ad4e507c6a4236137e0f625a24bacefbd2f29dad8b"
    sha256 cellar: :any_skip_relocation, catalina: "e7ed8b7cee22c502179a0ac8754821eb396a397866c8da3e875343676f7c2e9f"
    sha256 cellar: :any_skip_relocation, mojave:   "f764e8d198451d5e4311830d52b16fa3cdd6f2b2fd4ee459991fab7642c94a84"
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
