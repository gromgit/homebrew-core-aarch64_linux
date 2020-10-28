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
    sha256 "ed48db014d060e3b4fb86a589a46587dbfa54d28a312ee794af1a026cc9fa34f" => :catalina
    sha256 "8c93b986ecbae266972ba42ae872f89d7c167c77e61f70a074146eed1b5fa063" => :mojave
    sha256 "aa0b8590841f4374e96e0a6f12651c0e35e6327a9fe34a22b3540d299e02be44" => :high_sierra
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
